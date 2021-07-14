package org.zerock.mapper;

import java.util.List;

import org.zerock.domain.NoticeVO;
import org.zerock.domain.TownCriteria;
import org.zerock.domain.TownVO;

public interface TownMapper {
	public List<TownVO> getList(); // 동네소식 전체글 조회(select)
	public void insert(TownVO notice); // 동네소식 추가(insert)
	public void insertSelectKey(TownVO notice); // 동네소식 번호를 바로 insert 에 저장(for 첨부파일)
	public TownVO read(Integer town_bno); // 동네소식 세부조회
	public int delete(Integer town_bno); // 동네소식 삭제
	public int update(TownVO notice); // 동네소식 수정
	public List<TownVO> getListWithPaging(TownCriteria cri); // 동네소식 페이징
	public int getTotalCount(TownCriteria cri); // 동네소식 전체 갯수 for 페이징
	public List<TownVO> recentList();
	
}
