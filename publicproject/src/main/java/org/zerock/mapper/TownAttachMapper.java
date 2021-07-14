package org.zerock.mapper;

import java.util.List;

import org.zerock.domain.TownAttachVO;

public interface TownAttachMapper {
	public void insert(TownAttachVO vo);
	public int delete(String ta_uuid);
	public List<TownAttachVO> findByBno(Integer town_bno);
	public void deleteAll(Integer town_bno);
	public List<TownAttachVO> getOldFiles();
}
