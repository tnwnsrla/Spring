<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<style>
.join-pw {
	-webkit-text-security : disc;
}
</style>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>
</head>
<body>
	<form role="form" action="/member/join" method="post" id="signFrm">
	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
		<div class="form-group">
			<div>
				<label>ID(아이디)</label>
			</div>
			<div>
				<input class="join-id" placeholder="영어만 입력가능(8글자)" id="userid" name="userid" type="text" maxlength="8" oninput="handleOnInput(this)" autofocus> 
				<input type="button" id="check" value="아이디중복체크">
			</div>
		</div>
		<div class="form-group">
			<div>
				<label>Password(비밀번호)</label>
			</div>
			<div>
				<input class="join-pw" placeholder="숫자만 입력가능(8숫자)" id="userpw" name="userpw" type="password" onkeypress="inNumber();" maxlength="8">
			</div>	
		</div>
		<div class="form-group">
			<div>
				<label>이름</label>
			</div>
			<div>
				<input class="join-name" placeholder="성함을 적어주세요." id="user_name" name="user_name" type="text">
			</div>
		</div>
		<div class="form-group">
			<div>
				<label>이메일</label>
			</div>
			<div>
				<input class="join-email" placeholder="이메일을 적어주세요." id="user_email" name="user_email" type="text">
			</div>
		</div>
		<input type="button" id="signUp" class="btn-join" value="회원가입하기">
	</form>
</body>
<!-- <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"> -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script type="text/javascript">
$(document).ready(function(e){
  
  //아이디  중복체크 여부를 확인하기 위한 변수
  var idx = false;
  
  var formObj = $("form[role='form']");
  $("button[type='submit']").on("click", function(e){    
    e.preventDefault();
    console.log("submit clicked");
    formObj.submit();
  });
  
  // 빈칸 유효성 검사 및 아이디 중복체크 여부 검사
  $('#signUp').click(function(){
	  if($.trim($('#userid').val()) == '') {
		  alert("아이디 입력이 안되었습니다.");
		  $('#userid').focus();
		  return;
	  } else if ($.trim($('#userpw').val()) == '') {
		  alert("패스워드 입력이 안되었습니다.");
		  $('#userpw').focus();
		  return;
	  } else if ($.trim($('#user_name').val()) == '') {
		  alert("이름이 입력안되었습니다.");
		  $("#user_name").focus();
		  return;
	  } else if ($.trim($('#user_email').val()) == '') {
		  alert("이메일이 입력안되었습니다.");
		  $('#user_email').focus();
		  return;
	  } if(idx == false) {
		  alert("아이디 중복체크를 안하셨습니다. 중복체크를 부탁드립니다.");
		  return;
	  } else {
		  $('#signFrm').submit();
	  }
  })
  
  // 아이디 중복체크
  $("#check").click(function(){
	  $.ajax({
		  url : "/idCheck",
		  type : "GET",
		  data : { "userid" : $('#userid').val()},
		  success : function(data) {
			  if(data == 0 && $.trim($('#userid').val()) != '') {
				  idx=true;
				  alert("사용 가능한 아이디입니다.(중복x)");
			  } else {
				  alert("이미 존재하는 아이디입니다. 아이디를 바꿔주세요.")
			  }
		  },
		  error : function() {
			  alert("서버에러");
		  }
	  });
  });
});

// 아이디 영어만 입력가능하게 정규식으로 통제
function handleOnInput(e) {
	  e.value = e.value.replace(/[^A-Za-z]/ig, '')
}

// 비밀번호 숫자만 입력가능하게 키보드 입력키로 통제
function inNumber() {
	if(event.keyCode < 48 || event.keyCode > 57) {
		event.returnValue = false;
	}
}
</script>
</html>