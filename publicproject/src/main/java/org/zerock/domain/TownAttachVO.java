package org.zerock.domain;

import lombok.Data;

@Data
public class TownAttachVO {
	private String ta_uuid;
	private String ta_uploadPath;
	private String ta_fileName;
	private boolean ta_fileType;
	private Integer ta_bno;
}
