package org.zerock.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.zerock.domain.AttachFileDTO;
import org.zerock.domain.UploadForm;

import lombok.extern.log4j.Log4j;
import net.coobird.thumbnailator.Thumbnailator;

@Controller
@Log4j
public class UploadController {
	
	// 저장되는지 실험하는 Ajax 부분..
	@GetMapping("/uploadAjax")
	public void uploadAjax() {
		log.info("upload ajax");
	}
	
	// 실제적으로 컴퓨터에 파일을 저장하기 위한 메소드 + 폼 방법
	@PostMapping("/uploadFormAction")
	public void uploadFormPost(UploadForm form, Model model) {
	   log.info("폼 방식 파일 업로드");
	   String uploadFolder = "D:\\ddd\\upload"; // 업로드 경로설정
	   for(MultipartFile multipartFile : form.getUploadFile()) { // multipartFile 객체에 form 으로 온 uploadFile[]을 가져옴.
	         
	   // File 객체를 생성하여, uploadFolder객체의 폴더에 getOr~() 이름으로 된 파일 생성
	   File saveFile = new File(uploadFolder, multipartFile.getOriginalFilename());
       		try {
       			//파일(saveFile)을 지정된 대상 파일로 전송(transferTo)
    	   multipartFile.transferTo(saveFile);
       		} catch(Exception e) {
       			log.error(e.getMessage());
       		}
	   }
	}
	   
	// 아작스로 파일저장을 하는 방법
//	@PostMapping("/uploadAjaxAction")
//	public void uploadAjaxPost(MultipartFile[] uploadFile, Model model) {
//		log.info("아작스 형식 파일 업로드");
//		String uploadFolder = "E:\\ddd\\upload";
//		
//		//업로드 폴더 생성
//		File uploadPath = new File(uploadFolder, getFolder());
//		if(uploadPath.exists() == false) {
//			uploadPath.mkdirs(); // 년/월/일 폴더 생성
//		}
//
//		for (MultipartFile multipartFile : uploadFile) {
//			
//			String uploadFileName = multipartFile.getOriginalFilename();
//			// IE 브라우저 경로자르기
//			uploadFileName = uploadFileName.substring(uploadFileName.lastIndexOf("\\" + 1));
//			
//			// 파일이름 중복방지
//			UUID uuid = UUID.randomUUID();
//			uploadFileName = uuid.toString() + "_" + uploadFileName;
//			
////			File saveFile = new File(uploadFolder, uploadFileName);
//			File saveFile = new File(uploadPath, uploadFileName);
//			try {
//				multipartFile.transferTo(saveFile);
//				// 이미지 파일 유형인지 검사하여, 이미지 파일이면 썸네일 생성
//				if(checkImageType(saveFile)) {
//					//FileOutputStream 은 데이터를 파일에 바이트 스트림으로 저장하기 위해 사용된다.
//					FileOutputStream thumbnail = new FileOutputStream(new File(uploadPath, "_s" + uploadFileName)); // uploadPath(업로드폴더)에 uuid 파일이름앞에 _s가 붙은 파일생성
//					Thumbnailator.createThumbnail(multipartFile.getInputStream(), thumbnail, 100, 100); // 100,100 사이즈의 thumbnail 을 만든다.
//					thumbnail.close(); // 스트림을 닫아주어야 파일삭제 시 오류가 나지 않는다. OutputStream은 .close()를 생활화하자.
//				}
//			} catch (Exception e) {
//				log.error(e.getMessage());
//			}
//		}
//	}
	
	
	// 아작스로 파일저장을 하는 방법
	@PostMapping(value="/uploadAjaxAction", produces=MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<List<AttachFileDTO>> uploadAjaxPost(MultipartFile[] uploadFile) {
		log.info("아작스 형식 파일 업로드");
		
		List<AttachFileDTO> list = new ArrayList<AttachFileDTO>();
		String uploadFolder = "D:\\ddd\\upload";
		String uploadFolderPath = getFolder();

		// 업로드 폴더 생성
		File uploadPath = new File(uploadFolder, uploadFolderPath);
		log.info("업로드 경로 : " + uploadPath);
		
		if (uploadPath.exists() == false) {
			uploadPath.mkdirs(); // 년/월/일 폴더 생성
		}

		for (MultipartFile multipartFile : uploadFile) {
			AttachFileDTO attachDTO = new AttachFileDTO();
			
			String uploadFileName = multipartFile.getOriginalFilename();
			// IE 브라우저 경로자르기
//			uploadFileName = uploadFileName.substring(uploadFileName.lastIndexOf("\\" + 1));
			log.info("순수 파일 이름 : " + uploadFileName);
			attachDTO.setFileName(uploadFileName);
			
			// 파일이름 중복방지
			UUID uuid = UUID.randomUUID();
			uploadFileName = uuid.toString() + "_" + uploadFileName;

			try {
				File saveFile = new File(uploadPath, uploadFileName);
				multipartFile.transferTo(saveFile);
				
				attachDTO.setUuid(uuid.toString());
				attachDTO.setUploadPath(uploadFolderPath);
				// 이미지 파일 유형인지 검사하여, 이미지 파일이면 썸네일 생성
				if (checkImageType(saveFile)) {
					attachDTO.setImage(true);
					// FileOutputStream 은 데이터를 파일에 바이트 스트림으로 저장하기 위해 사용된다.
					FileOutputStream thumbnail = new FileOutputStream(new File(uploadPath, "s_" + uploadFileName)); // uploadPath(업로드폴더)에
					Thumbnailator.createThumbnail(multipartFile.getInputStream(), thumbnail, 100, 100); // 100,100 사이즈의
					thumbnail.close(); // 스트림을 닫아주어야 파일삭제 시 오류가 나지 않는다. OutputStream은 .close()를 생활화하자.
				}
				list.add(attachDTO);
			} catch (Exception e) {
				log.error(e.getMessage());
			}
		}
		return new ResponseEntity<List<AttachFileDTO>>(list, HttpStatus.OK);
	}
		
	// 년/월/일 폴더 생성 메소드
	private String getFolder() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date date = new Date();
		String str = sdf.format(date);
		// File.separator는 파일구분자로 // 를 -로 대체한다는 의미
		return str.replace("-", File.separator);
	}
	
	// 첨부파일이 이미지인지, 아닌지 판별하는 메소드 (동네소식을 위해서 필요..?)
	private boolean checkImageType(File file) {
		try {
			//파일의 확장자를 이용하여 MIME 타입을 결정, 실제파일이 존재하지않아도 확장자로 마임타입을 반환
			String contentType = Files.probeContentType(file.toPath());
			if(contentType != null) {
				//startsWith 메소드는 어떤 문자열이 특정 문자로 시작하는지 결과를 확인하여 true or false 반환
				return contentType.startsWith("image");
			} else {
				return false;
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
		return false;
	}
	
	// 공지사항 첨부파일 다운로드
	@GetMapping(value = "/download", produces = MediaType.APPLICATION_OCTET_STREAM_VALUE)
	@ResponseBody
	// url 에 쓰는 파라미터가 fileName인데 나는 계속 na_filename으로 요청해서 오류가 났었다. 내가 쓰고 싶은 파라미터명을 받아오고 싶을 때는 @RequestParam을 하거나 fileName 파라미터명을 바꿔주어야 한다.
	public ResponseEntity<Resource> downloadFile(@RequestHeader("User-Agent") String userAgent, @RequestParam("na_filename") String fileName) {
		log.info("download file: " + fileName);
		Resource resource = new FileSystemResource("D:\\ddd\\upload\\" + fileName);
		if(resource.exists() == false) {
			log.info("이쪽으로 빠졌니?");
			return new ResponseEntity<Resource>(HttpStatus.NOT_FOUND);
		}
		
		log.info("resource: " + resource);
		String resourceName = resource.getFilename();
		
		//다운로드는 파일명만 되어야 하니까 UUID 삭제
		String resourceOriginalName = resourceName.substring(resourceName.indexOf("_") + 1);
		
		// 한글로 인코딩
		HttpHeaders headers = new HttpHeaders();
		try {
			String downloadName = null;
			if(userAgent.contains("Trident")) {
				log.info("IE browser");
				downloadName = URLEncoder.encode(resourceOriginalName, "UTF-8").replaceAll("\\+", " ");
			} else if(userAgent.contains("Edge")) {
				log.info("Edge browser");
				downloadName = URLEncoder.encode(resourceOriginalName, "UTF-8");
				log.info("Edge name: " + downloadName);
			} else {
				log.info("Chrome browser");
				downloadName = new String(resourceOriginalName.getBytes("UTF-8"), "ISO-8859-1");
			}
			log.info("downloadName: " + downloadName);
			headers.add("Content-Disposition", "attachment; filename=" + downloadName);
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return new ResponseEntity<Resource>(resource, headers, HttpStatus.OK);
	}
	
	// 동네소식 첨부파일 다운로드
	@GetMapping(value = "/download2", produces = MediaType.APPLICATION_OCTET_STREAM_VALUE)
	@ResponseBody
	// url 에 쓰는 파라미터가 fileName인데 나는 계속 na_filename으로 요청해서 오류가 났었다. 내가 쓰고 싶은 파라미터명을 받아오고 싶을 때는 @RequestParam을 하거나 fileName 파라미터명을 바꿔주어야 한다.
	public ResponseEntity<Resource> downloadFile2(@RequestHeader("User-Agent") String userAgent, @RequestParam("ta_filename") String fileName) {
		log.info("download file: " + fileName);
		Resource resource = new FileSystemResource("D:\\ddd\\upload\\" + fileName);
		if(resource.exists() == false) {
			log.info("이쪽으로 빠졌니?");
			return new ResponseEntity<Resource>(HttpStatus.NOT_FOUND);
		}
			
		log.info("resource: " + resource);
		String resourceName = resource.getFilename();
			
		//다운로드는 파일명만 되어야 하니까 UUID 삭제
		String resourceOriginalName = resourceName.substring(resourceName.indexOf("_") + 1);
			
		// 한글로 인코딩
		HttpHeaders headers = new HttpHeaders();
		try {
			String downloadName = null;
			if(userAgent.contains("Trident")) {
				log.info("IE browser");
				downloadName = URLEncoder.encode(resourceOriginalName, "UTF-8").replaceAll("\\+", " ");
			} else if(userAgent.contains("Edge")) {
				log.info("Edge browser");
				downloadName = URLEncoder.encode(resourceOriginalName, "UTF-8");
				log.info("Edge name: " + downloadName);
			} else {
				log.info("Chrome browser");
				downloadName = new String(resourceOriginalName.getBytes("UTF-8"), "ISO-8859-1");
			}
			log.info("downloadName: " + downloadName);
			headers.add("Content-Disposition", "attachment; filename=" + downloadName);
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return new ResponseEntity<Resource>(resource, headers, HttpStatus.OK);
	}
	
	// 게시글 작성 중 첨부파일 삭제
	@PostMapping("/deleteFile")
	@ResponseBody
	public ResponseEntity<String> deleteFile(String fileName, String type) {
		log.info("deleteFile: " + fileName);
		File file;
		try {
			file = new File("D:\\ddd\\upload\\" + URLDecoder.decode(fileName, "UTF-8"));
			file.delete();
			if (type.equals("image")) {
				// 이미지면 썸네일도 같이 삭제
				String largeFileName = file.getAbsolutePath().replace("s_", "");
				log.info("largeFileName: " + largeFileName);
				file = new File(largeFileName);
				file.delete();
			}
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
		return new ResponseEntity<String>("deleted", HttpStatus.OK);
	}
	
	@GetMapping("/display")	
	@ResponseBody
	public ResponseEntity<byte[]> getFile(String fileName) {
		log.info("fileName: " + fileName);
		File file = new File("D:\\ddd\\upload\\" + fileName);
		log.info("file: " + file);
		ResponseEntity<byte[]> result = null;
		try {
			HttpHeaders header = new HttpHeaders();
			header.add("Content-Type", Files.probeContentType(file.toPath()));
			result = new ResponseEntity<>(FileCopyUtils.copyToByteArray(file), header, HttpStatus.OK);
		} catch (IOException e) {
			e.printStackTrace();
		}
		return result;
	}
}
