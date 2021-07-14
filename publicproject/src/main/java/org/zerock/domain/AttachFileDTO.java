package org.zerock.domain;

import lombok.Data;

// 첨부파일 정보들을 객체로 처리하고 JSON으로 전송
@Data
public class AttachFileDTO {
	private String fileName;	// 원본 파일의 이름
	private String uploadPath;	// 업로드 경로
	private String uuid;		// UUID 값
	private boolean image;		// 이미지 여부
}