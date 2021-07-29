<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<link href="/resources/css/customLogin.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/bxslider/4.2.12/jquery.bxslider.css"> <!-- 슬라이드 -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/bxslider/4.2.12/jquery.bxslider.min.js"></script>
<script>
    $(document).ready(function(){
      $('.slider').bxSlider({
    	  slideWidth: 400, // 슬라이드 너비
    	  touchEnabled : (navigator.maxTouchPoints > 0) // 슬라이드 터치
      });
    });
</script>
<%-- <%@ page session="false" %> --%>
<html>
<head>
	<title>프로젝트 메인</title>
</head>
<body>
<div class="custom-all">
	<sec:authorize access="isAnonymous()">
		<div class="login">
			<form role="form" method="post" action="/login">
			<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
					<div class="form-group">
						<input class="login-id" placeholder="아이디 입력란" name="username" type="text" value="${result}" autofocus>
					</div>
					<div class="form-group">
						<input class="login-pw" placeholder="비밀번호 입력란" name="password" type="password" value="">
					</div>
					<div>
						<button class="login-btn" type="submit">로그인</button>
						<span class="join-href" ><a href="/member/join"><b>회원가입</b></a></span>
					</div>
			</form>
			<a href="/member/findId" class="find">아이디 찾기</a>
			<a href="/member/findPw" class="find">비밀번호 찾기</a>
		</div> <!-- login 끝 -->
	</sec:authorize>	
	<sec:authorize access="isAuthenticated()"> <!-- 로그인 성공 시 -->
		<div class="login">
			환영합니다. <b><sec:authentication property="principal.username"/></b>님 <br>
			당신의 이름은 <b><sec:authentication property="principal.member.user_name"/></b>입니다. <br>
			<form role="form" method='post' action="/customLogout">
			    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
			    <button>로그아웃</button>
			</form>
			<form method="get" action="/member/update">
				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
				<button>회원정보 수정</button>
			</form>
		</div> <!-- 로그인 성공시 끝 -->
	</sec:authorize>
		<div class="notice"> <!-- 공지사항으로 이동 -->
			<div class="notice_main">
				<a href="/notice/list">공지사항</a>
			</div>
		</div>
		<div class="town">
			<div class="town_main">
				<a href="/town/list">동네소식</a>
			</div>
		</div>
		<div class="notice-recent">
			<c:forEach items="${noticeList}" var="notice"> <!-- 최신 동네소식 2개  -->
				<div class="noticeList">
					<div class="notice_title">
						<a class='move' href='/notice/get?notice_bno=<c:out value="${notice.notice_bno}" />'><c:out value="${notice.notice_title}"/></a>
					</div>
					<div class="notice_content">
						${notice.notice_content}
					</div>
					<div class="notice_regdate">
						<fmt:formatDate value="${notice.notice_regdate}" pattern="yyyy-MM-dd"/>
					</div>
				</div>
			</c:forEach>
		</div>
	<div class="town-slider">
		<div class="slider">
			<c:forEach items="${townList}" var="town">
				<!-- 동네소식 썸네일 이미지 3개 -->
				<div>
					<c:set var="list" value="${town.attachList}"></c:set>
					<div class="container_visual">
						<ul class="visual_img">
							<c:forEach items="${list}" var="attach">
								<c:url var="furl" value="/display">
									<%-- <c:param name="fileName" value="${attach.ta_uploadPath}/s_${attach.ta_uuid}_${attach.ta_fileName}" /> --%>
									<c:param name="fileName" value="${attach.ta_uploadPath}/${attach.ta_uuid}_${attach.ta_fileName}" />
								</c:url>
								<a class='move' href='/town/get?town_bno=<c:out value="${town.town_bno}" />'>
									<img src="${furl}" />
								</a>
							</c:forEach>
						</ul>
					</div>
				</div>
			</c:forEach>
		</div>
	</div>
</div>		
</body>
</html>
