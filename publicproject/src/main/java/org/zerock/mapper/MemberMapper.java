package org.zerock.mapper;

import org.zerock.domain.MemberVO;

public interface MemberMapper {
	public MemberVO read(String userid);
//	public MemberVO login(MemberVO member);
	public void insert(MemberVO member); 
	public int idCheck(String id);
}