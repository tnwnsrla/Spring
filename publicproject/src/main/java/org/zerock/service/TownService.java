package org.zerock.service;

import java.util.List;

import org.zerock.domain.TownAttachVO;
import org.zerock.domain.TownCriteria;
import org.zerock.domain.TownVO;

// 동네소식 서비스 인터페이스
public interface TownService {
	public void register(TownVO town); // 동네소식 등록
	public TownVO get(Integer town_bno); // 동네소식 세부조회
	public boolean modify(TownVO town); // 동네소식 수정
	public boolean remove(Integer town_bno); // 동네소식삭제
	public List<TownVO> getList(TownCriteria cri); // 동네소식 전체조회
	public int getTotal(TownCriteria cri); // 동네소식 전체 개수(페이징)
	public List<TownAttachVO> getAttachList(Integer town_bno); // 동네소식 번호(town_bno)에 따른 첨부파일 정보 가져오기
	public List<TownVO> recentList();
}
