package org.zerock.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.zerock.domain.TownAttachVO;
import org.zerock.domain.TownCriteria;
import org.zerock.domain.TownVO;
import org.zerock.mapper.TownAttachMapper;
import org.zerock.mapper.TownMapper;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@Service
public class TownServiceImpl implements TownService {

	@Setter(onMethod_ = {@Autowired})
	private TownMapper mapper;
	
	@Setter(onMethod_ = {@Autowired})
	private TownAttachMapper attachMapper;
	
	@Transactional
	@Override
	public void register(TownVO town) {
		log.info("등록된 동네소식 : " + town);
		mapper.insertSelectKey(town);
		
		if(town.getAttachList() == null || town.getAttachList().size() <= 0) {
			return;
		}
		town.getAttachList().forEach(attach -> {
			attach.setTa_bno(town.getTown_bno());
			attachMapper.insert(attach);
		});
		
	}

	@Override
	public TownVO get(Integer town_bno) {
		log.info("조회한 동네소식 번호 : " + town_bno);
		return mapper.read(town_bno);
	}

	@Transactional
	@Override
	public boolean modify(TownVO town) {
		log.info("수정한 공지사항 : " + town);
		attachMapper.deleteAll(town.getTown_bno());
		boolean modifyResult = mapper.update(town) == 1;
		
		if(modifyResult && town.getAttachList() != null && town.getAttachList().size() > 0) {
			town.getAttachList().forEach(attach -> {
				attach.setTa_bno(town.getTown_bno());
				attachMapper.insert(attach);
			});
		}
		return modifyResult;
	}

	@Override
	public boolean remove(Integer town_bno) {
		log.info("삭제한 동네소식 번호 : " + town_bno);
		attachMapper.deleteAll(town_bno);
		return mapper.delete(town_bno) == 1;
	}

	@Override
	public List<TownVO> getList(TownCriteria cri) {
		log.info("동네소식 리스트를 가져오는 중입니다.");
		
		List<TownVO> townList = mapper.getListWithPaging(cri);
		
		for(TownVO vo : townList) {
			List<TownAttachVO> attachList = attachMapper.findByBno(vo.getTown_bno());
			vo.setAttachList(attachList);
		}
		return townList;
	}

	
	@Override
	public int getTotal(TownCriteria cri) {
		log.info("동네소식 전체 수 ");
		return mapper.getTotalCount(cri);
	}

	@Override
	public List<TownAttachVO> getAttachList(Integer town_bno) {
		log.info("해당 동네소식에 따른 첨부파일 리스트" + town_bno);
		return attachMapper.findByBno(town_bno);
	}

	@Override
	public List<TownVO> recentList() {
		log.info("최신 동네소식 2개 입니다.");
		
		List<TownVO> townList = mapper.recentList();
		for(TownVO vo : townList) {
			List<TownAttachVO> attachList = attachMapper.findByBno(vo.getTown_bno());
			vo.setAttachList(attachList);
		}
		return townList;
	}

}
