<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">    
<link href="/resources/css/noticeRegister.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
<meta name="viewport" content="width=device-width, initial-scale=1">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<style>
.uploadResult {
	width: 20%;
}
.uploadResult ul {
	display: flex;
	flex-flow: row;
	justify-content: center;
	align-items: center;
}
.uploadResult ul li {
	padding: 30px;
}
</style>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 작성하기</title>
</head>
<body>
<div class="notice-all">
	<h1>게시글 작성화면입니다.</h1>
	<form role="form" action="/notice/register" method="post" >
	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
		<div class="mb-3"> <%-- 작성 제목 --%>
		  <label for="exampleFormControlInput1" class="form-label">제목</label>
		  <input name="notice_title" type="text" class="form-control" id="notice_title" placeholder="50글자 미만으로 입력해주세요.">
		</div>
		<div class="mb-3"><%-- 작성자 --%>
		  <label for="exampleFormControlInput1" class="form-label">작성자</label>
		  <input name="notice_userid" type="text" class="form-control" id="notice_writer" value='<sec:authentication property="principal.username"/>' readonly="readonly"><%--Security로 해야할 부분 --%>
		</div>
		<%-- <div class="mb-3">작성일
		  <label for="exampleFormControlInput1" class="form-label">작성일</label>
		  <input name="notice_regdate" type="text" class="form-control" id="exampleFormControlInput1" value="" > Security로 해야할 부분 
		</div>  --%>
		<div class="mb-3"><%-- 작성내용 --%>
		  <label for="exampleFormControlTextarea1" class="form-label">내용</label>
		  <textarea name="notice_content"class="form-control" id="notice_content" rows="3" placeholder="500글자 미만으로 입력해주세요."></textarea>
		</div>
		<button type="submit" class="reg-button" id="uploadBtn">작성완료</button>
	</form>
	<div class="row">
	  <div class="col-lg-12">
	    <div class="panel panel-default">
	      <div class="panel-heading">File Attach</div><!-- /.panel-heading -->
	      <div class="panel-body">
	        <div class="form-group uploadDiv">
	            <input type="file" name='uploadFile' multiple>
	        </div>
	        <div class='uploadResult'> 
	          <ul>
	          </ul>
	        </div>
	      </div><!--  end panel-body -->
	    </div><!--  end panel-body -->
	  </div><!-- end panel -->
	</div><!-- /.row -->
</div>
</body>
<script src="//code.jquery.com/jquery-1.11.0.min.js"></script>
<script src="https://code.jquery.com/jquery-3.3.1.min.js"
	integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8="
	crossorigin="anonymous">
</script>
<script>
$(document).ready(function(e){
/* 		var notice_title = document.forms[0].notice_title.value;
		var notice_content = document.forms[0].noticE_content.value;
	
		function formCheck() {
			  if(notice_title == null || notice_title == "") {
				  alert("제목을 입력하세요");
				  document.forms[0].notice_title.focus();
				  return false;
			  }
			  if(notice_content == null || notice_content == "") {
				  alert("내용을 입력하세요");
				  document.forms[0].notice_content.focus();
				  return false;
			  }
		} */
		
	  var formObj = $("form[role='form']");
	  $("button[type='submit']").on("click", function(e){    
	    e.preventDefault();
	    console.log("submit clicked");
	    var str = "";
	    $(".uploadResult ul li").each(function(i, obj){
	      var jobj = $(obj);
	      console.dir(jobj);
	      console.log("-------------------------");
	      console.log(jobj.data("filename"));
	      str += "<input type='hidden' name='attachList["+i+"].na_fileName' value='"+jobj.data("filename")+"'>";
	      str += "<input type='hidden' name='attachList["+i+"].na_uuid' value='"+jobj.data("uuid")+"'>";
	      str += "<input type='hidden' name='attachList["+i+"].na_uploadPath' value='"+jobj.data("path")+"'>";
	      str += "<input type='hidden' name='attachList["+i+"].na_fileType' value='"+ jobj.data("type")+"'>";
	    });
	    console.log(str);
	    formObj.append(str).submit();
	  });
	  
	  var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
	  var maxSize = 5242880; //5MB
	  
	  function checkExtension(fileName, fileSize){
	    if(fileSize >= maxSize){
	      alert("파일 사이즈 초과");
	      return false;
	    }
	    
	    if(regex.test(fileName)){
	      alert("해당 종류의 파일은 업로드할 수 없습니다.");
	      return false;
	    }
	    return true;
	  }
	  
	  var cloneObj = $(".uploadDiv").clone();
	  var csrfHeaderName = "${_csrf.headerName}";
	  var csrfTokenValue = "${_csrf.token}";
	  
	  $("input[type='file']").change(function(e){
	    var formData = new FormData();
	    var inputFile = $("input[name='uploadFile']");
	    var files = inputFile[0].files;
	    
	    for(var i = 0; i < files.length; i++){
	      if(!checkExtension(files[i].name, files[i].size) ){
	        return false;
	      }
	      formData.append("uploadFile", files[i]);
	    }
	    
	    $.ajax({
	      url: '/uploadAjaxAction',
	      processData: false, 
	      contentType: false,
	      beforeSend: function(xhr) {
	    	xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);  
	      },
	      data: formData,
	      type: 'POST',
	      dataType:'json',
	      success: function(result){
	        console.log(result); 
			showUploadResult(result); //업로드 결과 처리 함수 
			$(".uploadDiv").html(cloneObj.html());
	      }
	    }); //$.ajax
	  });
	 
	    function showUploadResult(uploadResultArr){
		if(!uploadResultArr || uploadResultArr.length == 0){ return; }
		var uploadUL = $(".uploadResult ul");
		var str ="";
			    
		$(uploadResultArr).each(function(i, obj){
			/*
			//image type
			if(obj.image){
			    var fileCallPath =  encodeURIComponent( obj.uploadPath+ "/s_"+obj.uuid +"_"+obj.fileName);
			    str += "<li><div>";
			    str += "<span> "+ obj.fileName+"</span>";
			    str += "<button type='button' data-file=\'"+fileCallPath+"\' data-type='image' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
			    str += "<img src='/display?fileName="+fileCallPath+"'>";
			    str += "</div>";
			    str +"</li>";
			}else{
			    var fileCallPath =  encodeURIComponent( obj.uploadPath+"/"+ obj.uuid +"_"+obj.fileName);            
			    var fileLink = fileCallPath.replace(new RegExp(/\\/g),"/");
			              
			    str += "<li><div>";
			    str += "<span> "+ obj.fileName+"</span>";
			    str += "<button type='button' data-file=\'"+fileCallPath+"\' data-type='file' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
			    str += "<img src='/resources/img/attach.png'></a>";
			    str += "</div>";
			    str +"</li>";
			}
			*/
			//image type
			if(obj.image){
				var fileCallPath =  encodeURIComponent(obj.uploadPath+ "/s_"+obj.uuid +"_"+obj.fileName);
				str += "<li data-path='"+obj.uploadPath+"'";
				str += " data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.image+"'"
				str += " ><div>";
				str += "<span> "+ obj.fileName+"</span>";
				/* str += "<button type='button' data-file=\'"+fileCallPath+"\' "
				str += "data-type='image' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>"; */
				/* str += "<img src='/display?fileName="+fileCallPath+"'>"; */
				str += "</div>";
				str += "</li>";
			}else{
				var fileCallPath =  encodeURIComponent(obj.uploadPath+"/"+ obj.uuid +"_"+obj.fileName);			      
				var fileLink = fileCallPath.replace(new RegExp(/\\/g),"/");
				str += "<li "
				str += "data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.image+"' ><div>";
				str += "<span> "+ obj.fileName+"</span>";
				str += "<button type='button' data-file=\'"+fileCallPath+"\' data-type='file' " 
				str += "class='btn btn-warning btn-circle'><i class='fa fa-times'>삭제</i></button><br>";
				str += "<img src='/resources/img/attach.png'></a>";
				str += "</div>";
				str += "</li>";
			}
		});    
		uploadUL.append(str);
	  } 
	  
	  $(".uploadResult").on("click", "button", function(e){
		console.log("delete file");
		var targetFile = $(this).data("file");
		var type = $(this).data("type");
		var targetLi = $(this).closest("li");
		$.ajax({
		  url: '/deleteFile',
		  data: {fileName: targetFile, type:type},
		  beforeSend : function(xhr) {
			  xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
		  },
		  dataType:'text',
		  type: 'POST',
		  success: function(result){
			alert(result);
		    targetLi.remove();
		  }
		}); //$.ajax
	  });
	});
</script>
</html>