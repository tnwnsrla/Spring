<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<link href="/resources/css/customUpdate.css" rel="stylesheet">    
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/bxslider/4.2.12/jquery.bxslider.min.js"></script>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원정보 수정</title>
</head>
<body>
	<div class="find-all">
		<form action="/member/update" method="post">
		<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
			<div class="form-group">
				<label>아이디</label>
				<input type="text" id="userid" name="userid" value="<sec:authentication property='principal.username'/>" readonly/>
			</div>
			<div class="form-group">
				<label>비밀번호</label>
				<input type="password" id="userpw" name="userpw" value="<sec:authentication property='principal.member.userpw'/>" />
			</div>
			<div class="form-group">
				<label>이름</label>
				<input type="text" id="user_name" name="user_name" value="<sec:authentication property="principal.member.user_name"/>" />
			</div>
			<div class="form-group">
				<label>이메일</label>
				<input type="text" id="user_email" name="user_email" value="<sec:authentication property="principal.member.user_email"/>" />
			</div>
			<div class="form-group">
				<button type="submit">회원정보 수정</button>
				<a href="/customLogin" class="main-move">메인</a>
			</div>
		</form>
	</div>
</body>
</html>