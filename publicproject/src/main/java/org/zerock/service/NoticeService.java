package org.zerock.service;

import java.util.List;

import org.zerock.domain.Criteria;
import org.zerock.domain.NoticeAttachVO;
import org.zerock.domain.NoticeVO;

// 공지사항 서비스 인터페이스
public interface NoticeService {
	public void register(NoticeVO notice); // 공지사항 등록
	public NoticeVO get(Integer notice_bno); // 공지사항 세부조회
	public boolean modify(NoticeVO notice); // 공지사항 수정
	public boolean remove(Integer notice_bno); // 공지사항 삭제
	public List<NoticeVO> getList(Criteria cri); // 공지사항 전체조회
	public int getTotal(Criteria cri); // 공지사항 전체 개수(페이징)
	public List<NoticeAttachVO> getAttachList(Integer notice_bno); // 공지사항 번호(notice_bno)에 따른 첨부파일 정보 가져오기
	public List<NoticeVO> recentList();
}
