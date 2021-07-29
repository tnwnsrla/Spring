package org.zerock.controller;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.zerock.domain.Criteria;
import org.zerock.domain.NoticeAttachVO;
import org.zerock.domain.NoticeVO;
import org.zerock.domain.PageDTO;
import org.zerock.service.NoticeService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/notice/*")
@AllArgsConstructor
public class NoticeController {
	
	private NoticeService service;
	
	@GetMapping("/list")
	public void list(Criteria cri, Model model) {
		log.info(" 목록 : " + cri);
		model.addAttribute("list", service.getList(cri));
		int total = service.getTotal(cri);
		log.info("전체 공지사항 개수(for 페이징) : " + total);
		model.addAttribute("pageMaker", new PageDTO(cri, total));
	}
	
	// 공지사항 등록
	@PostMapping("/register")
	@PreAuthorize("isAuthenticated()") // 인가된 사용자만
	public String register(NoticeVO notice, RedirectAttributes rttr) {
		log.info(" 등록된 공지사항 : " + notice);
		if(notice.getAttachList() != null) {
			notice.getAttachList().forEach(attach -> log.info(attach));
		} /*
			 * else { notice.getAttachList().forEach(attach ->
			 * log.info("첨부파일이 null이라고 인식하면 출력" + attach)); }
			 */
		service.register(notice);
		rttr.addFlashAttribute("result", notice.getNotice_bno()); // 성공여부
		return "redirect:/notice/list"; // 공지사항목록으로 이동
	}
	
	@GetMapping("/register")
	@PreAuthorize("isAuthenticated()")
	public void register() {
		
	}
	
	// 공지사항 수정 시 내용을 가져올 때
	@GetMapping({"/get", "/modify"})
	public void get(@RequestParam("notice_bno") Integer notice_bno, @ModelAttribute("cri") Criteria cri, Model model) {
		log.info("/get or /modify");
		model.addAttribute("notice", service.get(notice_bno));
	}
	
	// 공지사항 수정 시 내용을 보낼 때
	@PostMapping("/modify")
	@PreAuthorize("isAuthenticated()")
	public String modify(NoticeVO notice, RedirectAttributes rttr) {
		log.info(" 수정된 공지사항 : " + notice);
		if(service.modify(notice)) {
			rttr.addFlashAttribute("result", "success");
		}
		return "redirect:/notice/list";
	}
	
	// 공지사항을 삭제할 때
	@PostMapping("/remove")
	@PreAuthorize("isAuthenticated()")
	public String remove(@RequestParam("notice_bno") Integer notice_bno, @ModelAttribute("cri") Criteria cri, RedirectAttributes rttr) {
		log.info("삭제한 공지글 번호 : " + notice_bno);
		List<NoticeAttachVO> attachList = service.getAttachList(notice_bno);
		if(service.remove(notice_bno)) {
			deleteFiles(attachList);
			rttr.addFlashAttribute("result", "success");
		}
		rttr.addAttribute("pageNum", cri.getPageNum());
		rttr.addAttribute("amount", cri.getAmount());
		return "redirect:/notice/list";
	}
	
	@GetMapping(value = "/getAttachList", produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<List<NoticeAttachVO>> getAttachList(Integer notice_bno) {
		log.info("getAttachList " + notice_bno);
		return new ResponseEntity<>(service.getAttachList(notice_bno), HttpStatus.OK);
	}
	
	private void deleteFiles(List<NoticeAttachVO> attachList) {
	    if(attachList == null || attachList.size() == 0) {
	      return;
	    }
	    
	    log.info("delete attach files...................");
	    log.info(attachList);
	    
	    attachList.forEach(attach -> {
	      try {        
	        Path file  = Paths.get("D:\\ddd\\upload\\"+attach.getNa_uploadPath()+"\\" + attach.getNa_uuid()+"_"+ attach.getNa_fileName());
	        Files.deleteIfExists(file);
	        if(Files.probeContentType(file).startsWith("image")) {
	          Path thumbNail = Paths.get("D:\\ddd\\upload\\"+attach.getNa_uploadPath()+"\\s_" + attach.getNa_uuid()+"_"+ attach.getNa_fileName());
	          Files.delete(thumbNail);
	        }
	      }catch(Exception e) {
	        log.error("delete file error" + e.getMessage());
	      }//end catch
	    });//end foreachd
	}
}
