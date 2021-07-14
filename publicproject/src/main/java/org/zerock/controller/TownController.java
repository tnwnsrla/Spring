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
import org.zerock.domain.TownAttachVO;
import org.zerock.domain.TownCriteria;
import org.zerock.domain.TownPageDTO;
import org.zerock.domain.TownVO;
import org.zerock.service.TownService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/town/*")
@AllArgsConstructor
public class TownController {
	private TownService service;
	
	// 동네소식 리스트
	@GetMapping("/list")
	public void list(TownCriteria cri, Model model) {
		log.info(" 목록 : " + cri);
		List<TownVO> list = service.getList(cri); 
		log.info("list: " + list);
		model.addAttribute("list", list);
		int total = service.getTotal(cri);
		log.info("전체 동네소식 개수(for 페이징) : " + total);
		model.addAttribute("pageMaker", new TownPageDTO(cri, total));
	}
	
	// 동네소식 등록
	@PostMapping("/register")
	@PreAuthorize("isAuthenticated()") // 인가된 사용자만
	public String register(TownVO town, RedirectAttributes rttr) {
		log.info(" 등록된 공지사항 : " + town);
		if(town.getAttachList() != null) {
			town.getAttachList().forEach(attach -> log.info(attach));
		} else {
			town.getAttachList().forEach(attach -> log.info("첨부파일이 null이라고 인식하면 출력" + attach));
		}
		
		service.register(town);
		rttr.addFlashAttribute("result", town.getTown_bno()); // 성공여부
		return "redirect:/town/list"; // 동네소식 목록으로 이동
	}
	
	@GetMapping("/register")
	@PreAuthorize("isAuthenticated()")
	public void register() { }
	
	// 동네소식 수정 시 내용 가져오기
	@GetMapping({"/get", "/modify"})
	public void get(@RequestParam("town_bno") Integer town_bno, @ModelAttribute("cri") TownCriteria cri, Model model) {
		log.info("/get or /modify");
		model.addAttribute("town", service.get(town_bno));
	}
	
	// 공지사항 수정 시 내용을 보낼 때
	@PostMapping("/modify")
	public String modify(TownVO town, RedirectAttributes rttr) {
		log.info(" 수정된 공지사항 : " + town);
		if(service.modify(town)) {
			rttr.addFlashAttribute("result", "success");
		}
		return "redirect:/town/list";
	}
	
	// 공지사항을 삭제할 때
	@PostMapping("/remove")
	public String remove(@RequestParam("town_bno") Integer town_bno, @ModelAttribute("cri") TownCriteria cri, RedirectAttributes rttr) {
		log.info("삭제한 공지글 번호 : " + town_bno);
		List<TownAttachVO> attachList = service.getAttachList(town_bno);
		if(service.remove(town_bno)) {
			deleteFiles(attachList);
			rttr.addFlashAttribute("result", "success");
		}
		rttr.addAttribute("pageNum", cri.getPageNum());
		rttr.addAttribute("amount", cri.getAmount());
		return "redirect:/town/list";
	}
	
	@GetMapping(value = "/getAttachList", produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<List<TownAttachVO>> getAttachList(Integer town_bno) {
		log.info("getAttachList " + town_bno);
		return new ResponseEntity<>(service.getAttachList(town_bno), HttpStatus.OK);
	}
	
	// 동네소식 해당 게시글 첨부파일 리스트 삭제
	private void deleteFiles(List<TownAttachVO> attachList) {
	    if(attachList == null || attachList.size() == 0) {
	      return;
	    }
	    
	    log.info("delete attach files...................");
	    log.info(attachList);
	    
	    attachList.forEach(attach -> {
	      try {        
	        Path file  = Paths.get("D:\\ddd\\upload\\"+attach.getTa_uploadPath()+"\\" + attach.getTa_uuid()+"_"+ attach.getTa_fileName());
	        Files.deleteIfExists(file);
	        if(Files.probeContentType(file).startsWith("image")) {
	          Path thumbNail = Paths.get("D:\\ddd\\upload\\"+attach.getTa_uploadPath()+"\\s_" + attach.getTa_uuid()+"_"+ attach.getTa_fileName());
	          Files.delete(thumbNail);
	        }
	      }catch(Exception e) {
	        log.error("delete file error" + e.getMessage());
	      }
	    });
	}
	
	
}
