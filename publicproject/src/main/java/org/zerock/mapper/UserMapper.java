package org.zerock.mapper;

import org.zerock.domain.UserVO;

public interface UserMapper {
	public UserVO read(String user_id);
	public void insert(UserVO user);
}
