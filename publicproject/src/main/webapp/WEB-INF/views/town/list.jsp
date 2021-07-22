<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">    
<link href="/resources/css/townList.css" rel="stylesheet">
<%@ include file="../includes/header.jsp"%>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
<meta name="viewport" content="width=device-width, initial-scale=1">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>동네소식 전체보기</title>
</head>
<body>
<div class="town-all">
	<sec:authorize access="hasRole('ROLE_ADMIN')">
		<div>
			<a href="/town/register" class="town-register">동네소식 작성</a>
		</div>
	</sec:authorize>
		<!-- <div class="all"> -->
			<c:forEach items="${list}" var="town">
				<div class="townList">
					<c:set var="list" value="${town.attachList}"></c:set>
					<c:forEach items="${list}" var="attach">
						<div class="townList-img">
							<c:url var="furl" value="/display">
								<c:param name="fileName" value="${attach.ta_uploadPath}/s_${attach.ta_uuid}_${attach.ta_fileName}" />
							</c:url>
							<a class='move' href='<c:out value="${town.town_bno}" />'>
								<img src="${furl}" />
							</a>
						</div>
					</c:forEach>
				<a class='move' href='<c:out value="${town.town_bno}" />'><c:out value="${town.town_title}" /></a>
				<fmt:formatDate value="${town.town_regdate}" pattern="yyyy-MM-dd" />
				</div>
			</c:forEach>
		<!-- </div> -->
		<div class="text-center"> <%-- 페이징 출력 --%>
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
		<form id='actionForm' action="/town/list" method='get'> <%-- 페이지 이동 --%>
			<input type='hidden' name='pageNum' value='${pageMaker.cri.pageNum}'>
			<input type='hidden' name='amount' value='${pageMaker.cri.amount}'>
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
	
	//세부조회 -> 모록 이동 시 페이지 유지
	  $(".move").on("click", function(e){
		e.preventDefault();
		actionForm.append("<input type='hidden' name='town_bno' value='" + $(this).attr("href") + "'>");
		actionForm.attr("action", "/town/get")
		actionForm.submit();
	  });
	
});
</script>
</html>