package org.zerock.domain;

import java.util.Date;
import java.util.List;

import lombok.Data;

@Data
public class TownVO {
	private Integer town_bno;
	private String town_title;
	private String town_userid;
	private Date town_regdate;
	private String town_content;
//	private String town_thumbnail;
	private List<TownAttachVO> attachList; // 첨부파일 정보저장
}
