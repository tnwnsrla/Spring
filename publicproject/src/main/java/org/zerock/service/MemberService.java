package org.zerock.service;

import org.zerock.domain.MemberVO;

public interface MemberService {
	public void join(MemberVO member);
	public int idCheck(String userid);
//	public MemberVO login(MemberVO member);
}
