package org.zerock.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
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
	public void join() {
		
	}
	
	// 회원가입
	@PostMapping("/member/join")
	public String join(MemberVO member, RedirectAttributes rttr) {
//		String hashedPw = BCrypt.hashpw(member.getUser_pw(), BCrypt.gensalt());
//		member.setUser_pw(hashedPw);
		
		log.info("회원가입자 : " + member);
		
		service.join(member);
		rttr.addFlashAttribute("result", member.getUserid());
		return "redirect:/";
	}
	
//	@PostMapping("/member/login")
//	public String login(MemberVO member, HttpServletRequest req, RedirectAttributes rttr) throws Exception {
//		log.info("login 한 사람 : " + member);
//		
//		HttpSession session = req.getSession();
//		log.info(service.login(member));
//		MemberVO login = service.login(member);
//		
//		if(login == null) {
//			session.setAttribute("member", null);
//			rttr.addFlashAttribute("msg", false);
//		} else {
//			session.setAttribute("member", login);
//		}
//		
//		return "redirect:/notice/list";
//	}
	
	@RequestMapping(value = "/idCheck", method=RequestMethod.GET, produces="application/text; charset=utf8")
	@ResponseBody
	public String idCheck(HttpServletRequest request) {
		String userid = request.getParameter("userid");
		int result = service.idCheck(userid);
		return Integer.toString(result);
	}
}
