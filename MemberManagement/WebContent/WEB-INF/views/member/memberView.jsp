<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%
	//request에 저장해 놓은 회원정보 가져오기
	Member member = (Member)request.getAttribute("member");
%>
<script>
$(function(){
	$("[name=memberUpdateFrm]").submit(function(){
		
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
 * 정말 탈퇴하시겠습니까? 사용자 확인후, 
 * OK한 경우만 탈퇴 진행.
 * delete 요청은 POST방식으로 요청해야한다.
 * deleteMemberFrm을 생성후에 /mvc/member/deleteMember로 삭제요청한다.
 * 삭제처리 성공후에는 /mvc 로 이동.
 * 세션의 memberLoggedIn도 적절한 처리할 것.
 */
function deleteMember(){
	if(!confirm("정말 탈퇴하시겠습니까?")) return;
	
	$("[name=deleteMemberFrm]").submit();
	
}


function updatePassword(){
	
	let url = "<%= request.getContextPath() %>/member/updatePassword?memberId=<%= member.getMemberId() %>";
	let title = "updatePasswordPopup";
	let spec = "left=500px, top=200px, width=480px, height=220px";
	
	open(url, title, spec);
}

</script>
<section id=enroll-container>
	<h2>Edit profile</h2>
	<form action="<%=request.getContextPath() %>/member/deleteMember" name="deleteMemberFrm" method="POST">
		<input type="hidden" name="memberId" value="<%=member.getMemberId() %>" readonly />
	</form>

	<form name="memberUpdateFrm" 
		  action="<%= request.getContextPath() %>/member/memberUpdate" method="post">
		<table>
			<tr>
				<th>ID</th>
				<td>
					<input type="text" placeholder="4글자이상" name="memberId" id="memberId_" 
						   value="<%= member.getMemberId() %>" readonly required>
				</td>
			</tr>
			<tr>
				<th>EMAIL</th>
				<td>	
					<input type="email" placeholder="abc@xyz.com" name="email" id="email"
						   value="<%= member.getEmail() %>"><br>
				</td>
			</tr>
		</table>
		<input type="submit" value="Edit profile" >
		<input type="button" value="Edit password" onclick="updatePassword();" >
		<input type="reset" value="Cancel">
		<input type="button" value="Quit" onclick="deleteMember();" />
	</form>
	<form action="<%=request.getContextPath() %>/member/deleteMember" name="deleteMemberFrm" method="POST">
		<input type="hidden" name="memberId" value="<%=member.getMemberId() %>" />
	</form>
</section>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
