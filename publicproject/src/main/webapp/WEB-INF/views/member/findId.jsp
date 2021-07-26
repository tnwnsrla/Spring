<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>아이디 찾기</title>
</head>
<body>
	<form action="/member/findId" method="post">
	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
		<h3>아이디 찾기</h3>
		<label>Email</label>
		<input type="text" id="email" name="user_email" placeholder="가입했을 때 이메일을 입력">
		<button type="submit" id="findBtn">find</button>
		<a href="/customLogin" class="main-move">메인</a>
	</form>
		<h3>아이디 찾기 결과</h3>
		<h5>아이디는 ${userid} 입니다. 메인을 눌러 메인으로 돌아가세요~</h5>
</body>
</html>