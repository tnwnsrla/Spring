<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<link href="/resources/css/customLogin.css" rel="stylesheet">
<%-- <%@ page session="false" %> --%>
<html>
<head>
	<title>프로젝트 메인</title>
</head>
<body>
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
		</div> <!-- login 끝 -->
	</sec:authorize>	
	<sec:authorize access="isAuthenticated()"> <!-- 로그인 성공 시 -->
		<div class="login">
			환영합니다. <b><sec:authentication property="principal.username"/></b>님 <br>
			당신의 이름은 <b><sec:authentication property="principal.member.user_name"/></b>입니다. <br>
			<form role="form" method='post' action="/customLogout">
			    <button>로그아웃</button>
				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
			</form>
		</div> <!-- 로그인 성공시 끝 -->
	</sec:authorize>
		<div class="notice">
			<a href="/notice/list" class="notice_main">공지사항</a>
		</div>
		<div class="town">
			<a href="/town/list">동네소식</a>
		</div>
			<c:forEach items="${noticeList}" var="notice">
			<div class="noticeList">
				<div>
					<a class='move' href='/notice/get?notice_bno=<c:out value="${notice.notice_bno}" />'><c:out value="${notice.notice_title}"/></a>
				</div>
				<div>
					<fmt:formatDate value="${notice.notice_regdate}" pattern="yyyy-MM-dd"/>
				</div>
				<div>
					${notice.notice_content}
				</div>
			</div>
		</c:forEach>
		<div>
			<div>
				<c:forEach items="${townList}" var="town">
					<div>
						<c:set var="list" value="${town.attachList}"></c:set>
						<div class="container_visual">
						<ul class="visual_img">
						<c:forEach items="${list}" var="attach">
							<c:url var="furl" value="/display">
								<c:param name="fileName" value="${attach.ta_uploadPath}/s_${attach.ta_uuid}_${attach.ta_fileName}" />
							</c:url>
							<%-- <a class='move' href='/town/get?town_bno=<c:out value="${town.town_bno}" />'> --%>
								<li><img src="${furl}"/></li>
							<!-- </a> -->
						</c:forEach>
						</ul>
						</div>
					</div>
				</c:forEach>	
			</div>
		</div>
</body>
</html>
