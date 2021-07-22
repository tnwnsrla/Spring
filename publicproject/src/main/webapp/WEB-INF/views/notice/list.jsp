<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">    
<link href="/resources/css/noticeList.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
<%@ include file="../includes/header.jsp"%>
<meta name="viewport" content="width=device-width, initial-scale=1">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지사항 전체보기</title>
</head>
<body>
<%-- !!Spring Security 게시글 작성출력여부 추가필요 --%>
<div class="notice-all">
<sec:authorize access="hasRole('ROLE_ADMIN')">
<div class="notice-register"><a href="/notice/register">게시글 작성</a></div>
</sec:authorize>
	<div class="table-all">
		<table class="table table-hover">
	  		<thead>
	    		<tr>
			      <th scope="col">번호</th>
			      <th scope="col">제목</th>
			      <th scope="col">첨부</th> 
			      
			      <th scope="col">작성자</th>
			      <th scope="col">작성일</th>
	    		</tr>
	 		 </thead>
	  		<tbody> <%-- 공지사항 리스트로 출력 --%>
	 		 <c:forEach items="${list}" var="notice"> 
	 		   <tr>
	  		    <th scope="row"><c:out value="${notice.notice_bno}"/></th>
	    		  <%-- <td><a class='move' href='/notice/get?notice_bno=<c:out value="${notice.notice_bno}" />'><c:out value="${notice.notice_title}"/></a></td> --%>
	    		  <td><a class='move' href='<c:out value="${notice.notice_bno}" />'><c:out value="${notice.notice_title}"/></a></td>     	  
	        	  <c:if test="${notice.notice_attCnt == '0'}" >
		  	     	  <td>&nbsp;&nbsp;</td>
	  	     	  </c:if>
	  	     	  <c:if test="${notice.notice_attCnt != '0'}" >
		  	     	  <td><img width="20" height="20" src="/resources/img/attach.png"></td>
	  	     	  </c:if>
	  	     	  <td><c:out value="${notice.notice_userid}"/></td>
	  	     	  <td><fmt:formatDate value="${notice.notice_regdate}" pattern="yyyy-MM-dd"/></td>
	   		   </tr>
	   		 </c:forEach>
			</tbody> <%-- 공지사항 리스트 출력 끝 --%>
		</table>
	</div>
	<div class="searchForm-all"> <%-- 검색 조건설정 --%>
		<form id='searchForm' action="/notice/list" method='get'>
			<select class="form-select" name='type'> <!-- type을 주어야 Criteria에서 type을 찾는다. -->
			<!-- NoticeController에서 pageMaker 개체 지정 -->
			  <option value="" <c:out value="${pageMaker.cri.type == null? 'selected' : ' '}"/>>검색조건</option>
			  <option value="T" <c:out value="${pageMaker.cri.type eq 'T'?'selected':''}"/>>제목</option>
			  <option value="C" <c:out value="${pageMaker.cri.type eq 'C'?'selected':''}"/>>내용</option>
			  <option value="TC" <c:out value="${pageMaker.cri.type eq 'TC'?'selected':''}"/>>제목 또는 내용</option>
			</select> <%-- 검색 조건설정 끝 --%>
			<input type ='text' name='keyword' value='<c:out value="${pageMaker.cri.keyword}"/>' />
			<%-- 검색 시 조건에 따른 페이지 유지 --%>
			<input type ='hidden' name='pageNum' value='<c:out value="${pageMaker.cri.pageNum}"/>' />
			<input type ='hidden' name='amount' value='<c:out value="${pageMaker.cri.amount}"/>' />
			<button class='btn-search'>검색</button>
		</form>
	</div>
	<div> <%-- 페이징 출력 --%>
		<nav aria-label="...">
	  		<ul class="pagination">
	  			<c:if test="${pageMaker.prev}">
	    			<li class="page-item"> <%-- 이전 페이지로 이동 --%>
	      				<a class="page-link" href="${pageMaker.startPage-1}" tabindex="-1" aria-disabled="true">이전</a>
	    			</li>
	    		</c:if>
	    		<c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage}"> <%-- 해당 페이지로 이동 --%>
	    			<li class="page-item ${pageMaker.cri.pageNum == num ? "active":""} ">
	    				<a class="page-link" href="${num}">${num}</a></li>
	    		</c:forEach>
	    		<c:if test="${pageMaker.next}"> <%-- 다음 페이지로 이동 --%>
	    			<li class="page-item">
	      				<a class="page-link" href="${pageMaker.endPage+1}">다음</a>
	    			</li>
	    		</c:if>
	  		</ul>
		</nav>
	</div> <%-- 페이징 출력 끝 --%>
	<form id='actionForm' action="/notice/list" method='get'> <%-- 페이지 이동 --%>
		<input type='hidden' name='pageNum' value='${pageMaker.cri.pageNum}'>
		<input type='hidden' name='amount' value='${pageMaker.cri.amount}'>
		<%-- 검색조건 유지를 위한 파라미터--%>
		<input type='hidden' name='type' value='<c:out value="${pageMaker.cri.type}"/>'>
		<input type='hidden' name='keyword' value='<c:out value="${pageMaker.cri.keyword}"/>'>
	</form> <%-- 페이지 이동 끝 --%>
</div>
</body>
<script src="//code.jquery.com/jquery-1.11.0.min.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	
	// 페이지 이동 시 url로 파라미터 값 전송
	var actionForm = $("#actionForm");
	$(".page-item a").on ("click", // .page-item a 로 해야한다.. a 밑에 page-link 는 필요없다. a로 되기 때문에, 디버깅좀 잘하자~
			function(e){
				e.preventDefault();
				actionForm.find("input[name='pageNum']").val($(this).attr("href"));
				actionForm.submit();
	});
	
	// notice/get으로 pageNum을 추가하여 세부조회에서 목록으로 다시 이동해도 페이지수가 유지되도록 함.
	  $(".move").on("click", function(e){
		e.preventDefault();
		actionForm.append("<input type='hidden' name='notice_bno' value='" + $(this).attr("href") + "'>");
		actionForm.attr("action", "/notice/get")
		actionForm.submit();
	  });
	
	// 검색조건 버튼이벤트
	var searchForm = $("#searchForm");
	$("#searchForm button").on("click", function(e){
		if(!searchForm.find("option:selected").val()) { // 검색종류 선택을 안했다면
			alert("검색종류를 선택하여 주십시오.");
			return false;
		}
		if(!searchForm.find("input[name='keyword']").val()){//검색키워드를 입력안했다면
			alert("검색 키워드를 입력하여 주십시오.");
			return false;
		}
		searchForm.find("input[name='pageNum']").val("1"); // 검색 했을 때 1페이지로
		e.preventDefault;
		searchForm.submit();
	});
});
</script>
</html>