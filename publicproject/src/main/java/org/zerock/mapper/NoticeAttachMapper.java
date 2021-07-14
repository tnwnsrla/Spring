package org.zerock.mapper;

import java.util.List;

import org.zerock.domain.NoticeAttachVO;

public interface NoticeAttachMapper {
	public void insert(NoticeAttachVO vo);
	public int delete(String na_uuid);
	public List<NoticeAttachVO> findByBno(Integer notice_bno);
	public void deleteAll(Integer notice_bno);
	public List<NoticeAttachVO> getOldFiles();
}
