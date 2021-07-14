package org.zerock.domain;

import lombok.Data;

@Data
public class NoticeAttachVO {
	private String na_uuid;
	private String na_uploadPath;
	private String na_fileName;
	private boolean na_fileType;
	private Integer na_bno;
}
