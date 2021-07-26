<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀번호 찾기</title>
</head>
<body>
<h3>비밀번호 찾기</h3>
	<p>
		<label>아이디</label>
		<input class="w3-input" type="text" id="userid" name="userid" placeholder="회원가입한 아이디를 입력하세요" required>
	</p>
	<p>
		<label>이메일</label>
		<input class="w3-input" type="text" id="user_email" name="user_email" placeholder="네이버만 가능.." required>
	</p>
	<p class="w3-center">
		<button type="button" id="findBtn" class="w3-button w3-hover-white w3-ripple w3-margin-top w3-round mybtn">찾기</button>
		<a href="/customLogin" class="main-move">메인</a>
	</p>
</body>
<script src="http://code.jquery.com/jquery-latest.js"></script>
<script>
	var csrfHeaderName = "${_csrf.headerName}";
	var csrfTokenValue = "${_csrf.token}";
	
	$(function(){
		$("#findBtn").click(function(){
			$.ajax({
				url : "/member/findPw",
				type : "POST",
				data : {
					userid : $("#userid").val(),
					user_email : $("#user_email").val()
				},
				beforeSend: function(xhr) {
			       	xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);  
			  	},
				success : function(result) {
					alert(result);
				},
			})
		});
	})
</script>
</html>