package org.zerock.domain;

import java.util.Date;
import java.util.List;

import lombok.Data;

@Data
public class NoticeVO {
	private Integer notice_bno;
	private String notice_title;
	private String notice_userid;
	private Date notice_regdate;
	private String notice_content;
	private List<NoticeAttachVO> attachList; // 첨부파일 정보저장
	
	private int notice_attCnt; // 해당 notice_bno에 대한 첨부파일 수
}
