<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<link href="/resources/css/customfindId.css" rel="stylesheet">
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>아이디 찾기</title>
</head>
<body>
<div class="find-all">
	<form action="/member/findId" method="post">
	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
		<div class="form-group">
			<h3>아이디 찾기</h3>
			<label for="email">Email</label>
			<input type="text" id="email" name="user_email" placeholder="가입했을 때 이메일을 입력">
			<button type="submit" class="findBtn">find</button>
		</div>
	</form>
		<h3>아이디 찾기 결과</h3>
		<div class="find-result">
			<h5>아이디는 ${userid} 입니다. 메인을 눌러 메인으로 돌아가세요~</h5>
		</div>
		<a href="/customLogin" class="main-move">메인</a>
</div>
</body>
</html>