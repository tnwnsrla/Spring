<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<link href="/resources/css/townModify.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">    
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
<meta name="viewport" content="width=device-width, initial-scale=1">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<style>
.uploadResult {
  width:20%;
}
.uploadResult ul{
  display:flex;
  flex-flow: row;
  justify-content: center;
  align-items: center;
}
.uploadResult ul li {
  padding: 30px;
  align-content: center;
  text-align: center;
}
</style>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>동네소식 수정</title>
</head>
<body>
<div class="town-modify">
	<h1>동네소식 수정화면입니다.</h1>
	<form role="form" action="/town/modify" method="post">
		<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
		<input type="hidden" name="town_bno" value="${town.town_bno}"/>
		<div class="mb-3"> <%-- 작성 제목 --%>
		  <label for="exampleFormControlInput1" class="form-label">제목</label>
		  <input name="town_title" type="text" class="form-control" id="exampleFormControlInput1" placeholder="50글자 미만으로 입력해주세요." value="${town.town_title}">
		</div>
		<div class="mb-3"><%-- 작성자 --%>
		  <label for="exampleFormControlInput1" class="form-label">작성자</label>
		  <input name="town_userid" type="text" class="form-control" id="exampleFormControlInput1" value="${town.town_userid}" readonly ><%--Security로 해야할 부분 --%>
		</div>
		<div class="mb-3"><%-- 작성내용 --%>
		  <label for="exampleFormControlTextarea1" class="form-label">내용</label>
		  <textarea name="town_content"class="form-control" id="exampleFormControlTextarea1" rows="3" placeholder="500글자 미만으로 입력해주세요.">${town.town_content}</textarea>
		</div>
		<button type="submit" data-oper='modify' class="reg-button">수정완료</button>
	</form>
		<div class="row">
			<div class="col-lg-12">
				<div class="panel panel-default">
					<div class="panel-heading">Files</div>
					<!-- /.panel-heading -->
					<div class="panel-body">
						<div class="form-group uploadDiv">
							<input type="file" name='uploadFile' multiple="multiple">
						</div>
						<div class='uploadResult'>
							<ul>
							</ul>
						</div>
					</div>
					<!--  end panel-body -->
				</div>
				<!--  end panel-body -->
			</div>
			<!-- end panel -->
		</div>
		<!-- /.row -->
	</div>
</body>
<script src="//code.jquery.com/jquery-1.11.0.min.js"></script>
<script type="text/javascript">
$(document).ready(function() {
	var formObj = $("form");

	$('button').on("click", function(e){
	    e.preventDefault(); 
	    var operation = $(this).data("oper");
	    console.log(operation);
	    if(operation === 'modify') {
	  	  console.log("submit clicked");
	      var str = "";
	      $(".uploadResult ul li").each(function(i, obj){
	        var jobj = $(obj);
	        console.dir(jobj);
	        str += "<input type='hidden' name='attachList["+i+"].ta_fileName' value='"+jobj.data("filename")+"'>";
	        str += "<input type='hidden' name='attachList["+i+"].ta_uuid' value='"+jobj.data("uuid")+"'>";
	        str += "<input type='hidden' name='attachList["+i+"].ta_uploadPath' value='"+jobj.data("path")+"'>";
	        str += "<input type='hidden' name='attachList["+i+"].ta_fileType' value='"+ jobj.data("type")+"'>";
	    });
	      formObj.append(str).submit();
		}
	    formObj.submit();
	});
	
	// get.jsp 로드 후 자동실행 함수, 첨부파일 리스트를 가져온다.
	(function() {
		var town_bno = '<c:out value="${town.town_bno}"/>';

		$.getJSON("/town/getAttachList", {town_bno: town_bno}, function(arr){
		  console.log(arr);
		  var str = "";
		  $(arr).each(function(i, attach){
		    //image type
			  if(attach.ta_fileType){
			      var fileCallPath =  encodeURIComponent( attach.ta_uploadPath+ "/s_"+attach.ta_uuid +"_"+attach.ta_fileName);
			      str += "<li data-path='"+attach.ta_uploadPath+"' data-uuid='"+attach.ta_uuid+"' "
			      str +=" data-filename='"+attach.ta_fileName+"' data-type='"+attach.ta_fileType+"' ><div>";
			      str += "<span> "+ attach.ta_fileName+"</span>";
			      str += "<button type='button' data-file=\'"+fileCallPath+"\' data-type='image' "
			      str += "class='btn btn-warning btn-circle'><i class='fa fa-times'>삭제</i></button><br>";
			      str += "<img src='/display?fileName="+fileCallPath+"'>";
			      str += "</div>";
			      str +"</li>";
			    }/* else{  
			      str += "<li data-path='"+attach.ta_uploadPath+"' data-uuid='"+attach.ta_uuid+"' "
			      str += "data-filename='"+attach.ta_fileName+"' data-type='"+attach.ta_fileType+"' ><div>";
			      str += "<span> "+ attach.ta_fileName+"</span><br/>";
			      str += "<button type='button' data-file=\'"+fileCallPath+"\' data-type='file' "
			      str += " class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
			      str += "<img src='/resources/img/attach.png'></a>";
			      str += "</div>";
			      str +"</li>";
			    } */
		  });
	      $(".uploadResult ul").html(str);
		}); //end getjson
	})();
	
	// 첨부 파일 추가
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
	      data: formData,  
	      type: 'POST',
	      beforeSend: function(xhr) {
		       	xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);  
		  },
	      dataType:'json',
	      success: function(result){
	          console.log(result); 
			  showUploadResult(result); //업로드 결과 처리 함수
			  $(".uploadDiv").html(cloneObj.html());
	      }
	    }); //$.ajax
	});    

	// 첨부파일 업로드 결과를 보여줌
	function showUploadResult(uploadResultArr){
	    if(!uploadResultArr || uploadResultArr.length == 0){ return; }
	    var uploadUL = $(".uploadResult ul");
	    var str ="";
	    $(uploadResultArr).each(function(i, obj){
	    	// 이미지일 때
		  if(obj.image){
			var fileCallPath =  encodeURIComponent(obj.uploadPath+ "/s_"+obj.uuid +"_"+obj.fileName);
			str += "<li data-path='"+obj.uploadPath+"'";
			str +=" data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.image+"'"
			str +" ><div>";
			str += "<span> "+ obj.fileName+"</span>";
			str += "<button type='button' data-file=\'"+fileCallPath+"\' "
			str += "data-type='image' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
			str += "<img src='/display?fileName="+fileCallPath+"'>";
			str += "</div>";
			str +"</li>";
			// 그냥 첨부파일일 때
		  }/* else{
			var fileCallPath =  encodeURIComponent( obj.uploadPath+"/"+ obj.uuid +"_"+obj.fileName);			      
			var fileLink = fileCallPath.replace(new RegExp(/\\/g),"/");
			str += "<li "
			str += "data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.image+"' ><div>";
			str += "<span> "+ obj.fileName+"</span>";
			str += "<button type='button' data-file=\'"+fileCallPath+"\' data-type='file' " 
			str += "class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
			str += "<img src='/resources/img/attach.png'></a>";
			str += "</div>";
			str +"</li>";
		  } */
	    });    
	    uploadUL.append(str);
	}
	
	$(".uploadResult").on("click", "button", function(e){   
		console.log("delete file");
		if(confirm("Remove this file? ")){
		  var targetLi = $(this).closest("li");
		  targetLi.remove();
		}
	});
});
</script>
</html>