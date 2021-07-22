package org.zerock.service;

import java.io.PrintWriter;

import javax.servlet.http.HttpServletResponse;

import org.apache.commons.mail.HtmlEmail;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
//import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;
import org.zerock.domain.AuthVO;
import org.zerock.domain.MemberVO;
import org.zerock.mapper.MemberAuthMapper;
import org.zerock.mapper.MemberMapper;

import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@Service
@AllArgsConstructor
@Repository
public class MemberServiceImpl implements MemberService {

	@Setter(onMethod_ = @Autowired)
	private MemberMapper mapper;
	
	@Setter(onMethod_ = @Autowired)
	private MemberAuthMapper authMapper;
	
//	 비밀번호 암호화
	@Setter(onMethod_ = @Autowired)
	private PasswordEncoder pwencoder;
	
	// 회원가입
	@Override
	public void join(MemberVO member) {
		log.info("join 메소드 실행");
		
		// 비밀번호 암호화
		String encpw = pwencoder.encode(member.getUserpw());
		member.setUserpw(encpw);
		
		//DB 추가
		mapper.insert(member);
		
		// 디폴트로 ROLE_USER 부여
		AuthVO auth = new AuthVO();
		auth.setUser_id(member.getUserid());
		auth.setUser_auth("ROLE_USER");
		authMapper.insert(auth);
	}

//	@Override
//	public MemberVO login(MemberVO member) {
//		return mapper.login(member);
//	}

//	@Override
//	public int idChk(MemberVO member) throws Exception {
//		int result = sql.selectOne("memberMapper.idChk", member);
//		return result;
//	}

	@Override
	public int idCheck(String id) {
		int result = mapper.idCheck(id);
		return result;
	}

	@Override
	public String findId(HttpServletResponse response, String user_email) throws Exception {
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		String result = mapper.findId(user_email);
		if(result == null) {
			out.println("<script>");
			out.println("alert('가입된 아이디가 없습니다.');");
			out.println("</script>");
			out.close();
			return null;
		} else {
			return result;
		}
	}

	@Override
	public void sendEmail(MemberVO vo, String div) throws Exception {
		String charSet = "utf-8";
		String hostSMTP = "smtp.naver.com";
		String hostSMTPid = "서버 이메일 주소(보내는 사람 이메일 주소)";
		String hostSMTPpwd = "서버 이메일 비번(보내는 사람 이메일 비번)";

		// 보내는 사람 EMail, 제목, 내용
		String fromEmail = "보내는 사람 이메일주소(받는 사람 이메일에 표시됨)";
		String fromName = "프로젝트이름 또는 보내는 사람 이름";
		String subject = "";
		String msg = "";

		if(div.equals("findPw")) {
			subject = "베프마켓 임시 비밀번호 입니다.";
			msg += "<div align='center' style='border:1px solid black; font-family:verdana'>";
			msg += "<h3 style='color: blue;'>";
			msg += vo.getUserid() + "님의 임시 비밀번호 입니다. 비밀번호를 변경하여 사용하세요.</h3>";
			msg += "<p>임시 비밀번호 : ";
			msg += vo.getUserpw() + "</p></div>";
		}

		// 받는 사람 E-Mail 주소
		String mail = vo.getUser_email();
		try {
			HtmlEmail email = new HtmlEmail();
			email.setDebug(true);
			email.setCharset(charSet);
			email.setSSL(true);
			email.setHostName(hostSMTP);
			email.setSmtpPort(465); //네이버 이용시 587

			email.setAuthentication(hostSMTPid, hostSMTPpwd);
			email.setTLS(true);
			email.addTo(mail, charSet);
			email.setFrom(fromEmail, fromName, charSet);
			email.setSubject(subject);
			email.setHtmlMsg(msg);
			email.send();
		} catch (Exception e) {
			System.out.println("메일발송 실패 : " + e);
		}
		
	}

	@Override
	public void findPw(HttpServletResponse response, MemberVO vo) throws Exception {
		response.setContentType("text/html;charset=utf-8");
		MemberVO ck = mapper.read(vo.getUserid());
		PrintWriter out = response.getWriter();
		
		if(mapper.idCheck(vo.getUserid()) == 0) {
			out.print("등록되지 않은 아이디입니다.");
			out.close();
		} else if (!vo.getUser_email().equals(ck.getUser_email())) {
			out.print("등록되지 않은 이메일입니다.");
		} else {
			String pw = "";
			for(int i = 0; i < 8; i++) {
				pw += (char)((Math.random() * 26) + 97);
			}
			
			vo.setUserpw(pw);
			mapper.updatePw(vo);
			sendEmail(vo, "findPw");
			
			out.print("이메일로 임시 비밀번호를 발송하였습니다.");
			out.close();
		}
	}

	@Override
	public int updatePw(MemberVO vo) throws Exception {
		return mapper.updatePw(vo);
	}
}
