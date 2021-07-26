package org.zerock.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.zerock.domain.Criteria;
import org.zerock.domain.NoticeAttachVO;
import org.zerock.domain.NoticeVO;
import org.zerock.mapper.NoticeAttachMapper;
import org.zerock.mapper.NoticeMapper;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@Service
public class NoticeServiceImpl implements NoticeService {

	@Setter(onMethod_ = {@Autowired})
	private NoticeMapper mapper;
	
	@Setter(onMethod_ = {@Autowired})
	private NoticeAttachMapper attachMapper;
	
	
	// Transaction이 적용안되는 느낌은 뭐지..
	@Transactional
	@Override
	public void register(NoticeVO notice) {
		log.info("등록된 공지사항 : " + notice);
		
		// 첨부파일이 존재하지 않으면 게시글만 등록
		if(notice.getAttachList() == null || notice.getAttachList().size() <= 0) {
			mapper.insertSelectKey(notice);
		}   else if(notice.getAttachList() !=null ) { // 첨부파일이 존재하면 첨부파일까지 같이 등록
			notice.getAttachList().forEach(attach -> {
			mapper.insertSelectKey(notice);
			attach.setNa_bno(notice.getNotice_bno());
			attachMapper.insert(attach);
			mapper.updateAttCnt(notice.getNotice_bno(), 1); // 첨부파일이 존재하면 AttCnt도 증가
			});
		}
	}

	@Override
	public NoticeVO get(Integer notice_bno) {
		log.info("조회한 공지사항 번호 : " + notice_bno);
		return mapper.read(notice_bno);
	}

	// 트랜잭션화
	@Transactional
	@Override
	public boolean modify(NoticeVO notice) {
		log.info("수정한 공지사항 : " + notice);
		attachMapper.deleteAll(notice.getNotice_bno());
		boolean modifyResult = mapper.update(notice) == 1;
		
		if(modifyResult && notice.getAttachList() != null && notice.getAttachList().size() > 0) {
			notice.getAttachList().forEach(attach -> {
			attach.setNa_bno(notice.getNotice_bno());
			mapper.updateAttCnt(notice.getNotice_bno(), 1);				
			attachMapper.insert(attach);
			});
		} else {
			mapper.updateAttCnt(notice.getNotice_bno(), 0);
		}
		
		return modifyResult;
	}

	@Override
	public boolean remove(Integer notice_bno) {
		log.info("삭제 한 공지사항 번호 " + notice_bno);
		return mapper.delete(notice_bno) == 1;
	}

	@Override
	public List<NoticeVO> getList(Criteria cri) {
		log.info("공지사항 가져오는 중..");
		return mapper.getListWithPaging(cri);
	}

	@Override
	public int getTotal(Criteria cri) {
		log.info("공지사항 전체 수 ");
		return mapper.getTotalCount(cri);
	}

	@Override
	public List<NoticeAttachVO> getAttachList(Integer notice_bno) {
		log.info("공지사항에 따른 첨부파일 리스트" + notice_bno);
		return attachMapper.findByBno(notice_bno);
	}

	@Override
	public List<NoticeVO> recentList() {
		log.info("최신공지사항 2개 입니다");
		return mapper.recentList();
	}
}
