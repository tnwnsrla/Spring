package org.zerock.service;

import javax.servlet.http.HttpServletResponse;

import org.zerock.domain.MemberVO;

public interface MemberService {
	public MemberVO read(String userid);
	public void join(MemberVO member);
	public int idCheck(String userid);
//	public MemberVO login(MemberVO member);
	public String findId(HttpServletResponse response, String user_email) throws Exception;
	public void sendEmail(MemberVO vo, String div) throws Exception;
	public void findPw(HttpServletResponse response, MemberVO vo) throws Exception;
	public int updatePw(MemberVO vo) throws Exception;
	public void memberUpdate(MemberVO vo) throws Exception;
}
