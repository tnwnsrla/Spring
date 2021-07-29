package org.zerock.mapper;

import org.zerock.domain.MemberVO;

public interface MemberMapper {
	public MemberVO read(String userid); // 로그인
	public void insert(MemberVO member);  // 회원가입
	public int idCheck(String id); // 아이디 중복체크
	public String findId(String user_email); // 아이디 찾기
	public int updatePw(MemberVO vo) throws Exception; // 비밀번호 찾기 및 자동 업데이트
	public void memberUpdate(MemberVO vo) throws Exception; // 회원정보 수정
	
}
