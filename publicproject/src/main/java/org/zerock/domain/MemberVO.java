package org.zerock.domain;

import java.util.List;

import lombok.Data;

@Data
public class MemberVO {
	private String userid;
	private String userpw;
	private String user_name;
	private String user_email;
	private boolean enabled;
	
	private List<AuthVO> authList;
}
