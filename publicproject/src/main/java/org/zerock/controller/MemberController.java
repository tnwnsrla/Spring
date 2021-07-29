package org.zerock.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.zerock.domain.MemberVO;
import org.zerock.service.MemberService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping
@AllArgsConstructor
public class MemberController {

	private MemberService service;
	
	@GetMapping("/member/join")
	public void join() {}
	
	@GetMapping("/member/findId")
	public void findId() {}
	
	@GetMapping("/member/findPw")
	public void findPw() {}
	
	// 회원가입
	@PostMapping("/member/join")
	public String join(MemberVO member, RedirectAttributes rttr) {
		log.info("회원가입자 : " + member);
		
		service.join(member);
		rttr.addFlashAttribute("result", member.getUserid());
		return "redirect:/";
	}
	
	// 아이디 중복체크
	@RequestMapping(value = "/idCheck", method=RequestMethod.GET, produces="application/text; charset=utf8")
	@ResponseBody
	public String idCheck(HttpServletRequest request) {
		String userid = request.getParameter("userid");
		int result = service.idCheck(userid);
		return Integer.toString(result);
	}
	
	// 아이디 찾기
	@RequestMapping(value = "/member/findId", method= RequestMethod.POST)
	public String findId(HttpServletResponse response, @RequestParam("user_email") String user_email, Model model) throws Exception {
		model.addAttribute("userid", service.findId(response, user_email));
		return "/member/findId";
	}
	
	// 비밀번호 찾기
	@RequestMapping(value="/member/findPw", method= RequestMethod.POST)
	public void findPw(@ModelAttribute MemberVO member, HttpServletResponse response) throws Exception {
		service.findPw(response, member);
	}
	
	// 회원정보 수정을 위한 회원정보 가져오기
	@RequestMapping(value="/member/update", method=RequestMethod.GET)
	public void registerUpdateView(MemberVO vo, Model model) throws Exception {
		// security 때문에 필요없네..
	}
	
	// 회원정보 수정
	@RequestMapping(value="/member/update", method=RequestMethod.POST)
	public String registerUpdate(MemberVO vo, HttpSession session) throws Exception {
		service.memberUpdate(vo);
		session.invalidate();
		return "redirect:/";
	}
}
