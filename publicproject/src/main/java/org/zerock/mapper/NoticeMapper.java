package org.zerock.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.zerock.domain.Criteria;
import org.zerock.domain.NoticeVO;

public interface NoticeMapper {
	public List<NoticeVO> getList(); // 공지사항 전체글 조회(select)
	public void insert(NoticeVO notice); // 공지사항 추가(insert)
	public void insertSelectKey(NoticeVO notice); // 공지사항 번호를 바로 insert 에 저장(for 첨부파일)
	public NoticeVO read(Integer notice_bno); // 공지사항 세부조회
	public int delete(Integer notice_bno); // 공지사항 삭제
	public int update(NoticeVO notice); // 공지사항 수정
	public List<NoticeVO> getListWithPaging(Criteria cri); // 공지사항 페이징
	public int getTotalCount(Criteria cri); // 공지사항 전체 갯수 for 페이징
	
	public void updateAttCnt(@Param("notice_bno") Integer bno, @Param("amount") int amount);
	
	public List<NoticeVO> recentList();
}
