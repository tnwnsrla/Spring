package org.zerock.service;

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
}
