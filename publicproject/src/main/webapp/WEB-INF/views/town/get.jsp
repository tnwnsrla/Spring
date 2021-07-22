<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<link href="/resources/css/townGet.css" rel="stylesheet">    
<!-- <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">    
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script> -->
<meta name="viewport" content="width=device-width, initial-scale=1">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<style>
  table {
    width: 100%;
    border: 1px solid #444444;
  }
  th{
    border: 1px solid #444444;
    width: 100px;
    background-color : Lightgray;
  }
  td{
    border: 1px solid #444444;
  }
  uploadResult{
  	backgroun-color : Lightgray;
  }
</style>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>동네소식 조회</title>
</head>
<body>
	<div> <%-- 게시글 내용 조회 --%>
	 	<table>
	        <tr>
	          <th>제목</th>
	          <td>${town.town_title}</td>
	        </tr>
	        <tr>
	          <th>작성자</th>
	          <td>${town.town_userid}</td>
	        </tr>
	        <tr>
	          <th>작성일</th>
	          <td><fmt:formatDate value="${town.town_regdate}" pattern="yyyy-MM-dd"/></td>
	        </tr>
	        <tr>
	          <th>내용</th>
	          <td>${town.town_content}</td>
	        </tr>
	    </table>
	    <div>첨부파일</div>
	    <div class='uploadResult'>
	          	<ul>
	          	</ul>
	    </div>
    </div>
    <div class="button-all"> <%--목록, 수정, 삭제 버튼 --%>
    	<button data-oper='list' class="btn-list" onclick="location.href='/town/list'">목록</button>
    	<sec:authentication property="principal" var="userinfo"/>
    	<sec:authorize access="isAuthenticated()">
    	<c:if test="${userinfo.username eq town.town_userid}"> <%-- 작성자만 수정,삭제버튼 --%>
    		<button data-oper='modify' class="btn-modify" onclick="location.href='/town/modify?town_bno=<c:out value="${town.town_bno}" />'">수정</button> <%--data-oper 로 javascript에서 사용할 data 명칭 지정 --%>
    		<button type="submit" data-oper='remove' class = "btn-remove">삭제</button>
    	</c:if>
    	</sec:authorize>
    	<input type="hidden" id="csrftest" name="${_csrf.parameterName}" value="${_csrf.token}" />
    </div>
    <%-- 세부조회에서 목록으로 이동 시 페이지(pageNum,amount)를 보내서 페이지수 유지 --%>
    <form id='operForm' action="/town/modify" method="get">
 		<input type='hidden' id='town_bno' name='town_bno' value='<c:out value="${town.town_bno}"/>'>
		<input type='hidden' name='pageNum' value='<c:out value="${cri.pageNum}"/>'>
 		<input type='hidden' name='amount' value='<c:out value="${cri.amount}"/>'>
	</form>
</body>
<script src="//code.jquery.com/jquery-1.11.0.min.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	var operForm = $("#operForm") // 목록페이지(전체 공지사항 조회) 이동
	$("button[data-oper='list']").on("click", function(e){
		operForm.find("#town_bno").remove();
		operForm.attr("action", "/town/list");
		operForm.submit();
	});
	
	var formObj = $("form");
	var csrfHeaderName = "${_csrf.headerName}";
    var csrfTokenValue = "${_csrf.token}";
    
	$('button').on("click", function(e){
		e.preventDefault();
		var operation = $(this).data("oper");
		console.log(operation);
		if(operation === 'remove') {
			formObj.attr("action", "/town/remove").attr("method", "post");
			var csrfTag = $("#csrftest").clone();
			formObj.append(csrfTag);
			alert("정말 삭제하시겠습니까?");
		} else if(operation === 'list') { // operation 이 list로 동작할 경우
			  formobj.attr("action", "/town/list").attr("method", "get");
			  var pageNumTag = $("input[name='pageNum']").clone();
		      var amountTag = $("input[name='amount']").clone();
		      var keywordTag = $("input[name='keyword']").clone();	// 검색 관련
		      var typeTag = $("input[name='type']").clone();
		      formObj.empty();
		      formObj.append(pageNumTag);
		      formObj.append(amountTag);
		      formObj.append(keywordTag);					// 검색 관련
		      formObj.append(typeTag);
		}
		formObj.submit();
	});
	
	
	
	(function() {
		var town_bno = '<c:out value="${town.town_bno}"/>';

		$.getJSON("/town/getAttachList", {town_bno: town_bno}, function(arr){
		  console.log(arr);
		  var str = "";
		  $(arr).each(function(i, attach){
		    if(attach.ta_fileType){
		      var fileCallPath =  encodeURIComponent(attach.ta_uploadPath+ "/"+attach.ta_uuid +"_"+attach.ta_fileName);
		      str += "<li data-path='"+attach.ta_uploadPath+"' data-uuid='"+attach.ta_uuid+"' data-filename='"+attach.ta_fileName+"' data-type='"+attach.ta_fileType+"' ><div>";
		      str += "<img src='/display?fileName="+fileCallPath+"' width='800px', height='500px'>";
		      str += "</div>";
		      str +"</li>";
		    }else{
		      str += "<li data-path='"+attach.ta_uploadPath+"' data-uuid='"+attach.ta_uuid+"' data-filename='"+attach.ta_fileName+"' data-type='"+attach.ta_fileType+"' ><div>";
		      str += "<span> "+ attach.ta_fileName+"</span><br/>";
		      str += "<img src='/resources/img/attach.png'></a>";
		      str += "</div>";
		      str +"</li>";
		    }
		  });
	      $(".uploadResult ul").html(str);
		}); //end getjson
	})();
	
	$(".uploadResult").on("click", "li", function(e){
		var liObj = $(this);
		var path = encodeURIComponent(liObj.data("path") + "/" + liObj.data("uuid") + "_" + liObj.data("filename"));
		self.location = "/download2?ta_filename=" + path;
	})
});
</script>
</html>