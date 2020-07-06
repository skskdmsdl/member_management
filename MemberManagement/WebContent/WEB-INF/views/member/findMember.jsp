<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<script>
$(function(){
	$("[name=memberEnrollFrm]").submit(function(){
		//아이디검사
		let $memberId = $("#memberId_");
//		if(!/^[a-zA-Z0-9_]{4,}$/.test($memberId.val())){
		if(!/^[\w]{4,}$/.test($memberId.val())){
			alert("아이디가 유효하지 않습니다.");
			$memberId.focus();
			return false;
		}
		
		//아이디 중복검사 
		let $isIdValid = $("#isIdValid");
		if($isIdValid.val() == 0){
			alert("아이디 중복검사 해주세요.");
			return false;
		}
		
		//비밀번호 검사
		let $pwd1 = $("#password_");
		let $pwd2 = $("#password2");
		
		if($pwd1.val() !== $pwd2.val()){
			alert("비밀번호가 일치하지 않습니다.");
			$pwd1.focus();
			return false;
		}
		
		
		
		return true;
	});
});

/**
 * 팝업 + 폼제출
 */
function checkIdDuplicate(){
	let $memberId = $("#memberId_");
	if(!/^[\w]{4,}$/.test($memberId.val())){
		alert("유효한 아이디를 입력해주세요.");
		$memberId.select();
		return;
	}
	
	//팝업생성
	let title = "checkIdDuplicatePopup";
	let spec = "left=300px, top=300px, width=300px, height=200px";
	let popup = open("", title, spec);
	//url부분은 form이 제출될 주소가 오므로, 공란처리
	
	let $frm = $("[name=checkIdDuplicateFrm]");
	$frm.attr("action", "<%=request.getContextPath()%>/member/checkIdDuplicate");
	$frm.attr("method", "POST");
	$frm.attr("target", title);//폼과 팝업을 연결
	$frm.find("[name=memberId]").val($memberId.val());
	$frm.submit();
	
	
}

</script>
<section id=enroll-container>
	<h2>Find ID</h2>
	
	<!-- 아이디 중복 체크폼 -->
	<form name="checkIdDuplicateFrm">
		<input type="hidden" name="memberId" />
	</form>
	
	<form name="memberEnrollFrm" action="" method="post">
		<table>
			
			<tr>
				<th>이메일</th>
				<td>	
					<input type="email" placeholder="abc@xyz.com" name="email" id="email"><br>
				</td>
			</tr>
			<tr>
				<th>휴대폰</th>
				<td>	
					<input type="tel" placeholder="(-없이)01012345678" name="phone" id="phone" maxlength="11" required><br>
				</td>
			</tr>
			
		</table>
		<input type="submit" value="가입" >
		<input type="reset" value="취소">
	</form>
</section>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
