<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="member.model.vo.Member" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Edit password</title>
<script type="text/javascript" src="<%=request.getContextPath() %>/js/jquery-3.5.1.js"></script>
<style>
div#updatePassword-container{font-family: harryFont;}
div#updatePassword-container table {margin:0 auto; border-spacing: 20px;}
div#updatePassword-container table tr:last-of-type td {text-align:center;font-family: harryFont;}
</style>
<script>
function passwordValidate(){
	var $newPwd = $("#newPassword");
	var $newPwdChk = $("#newPasswordCheck");
	
	if($newPwd.val() != $newPwdChk.val()){
		alert("입력한 비밀번호가 일치하지 않습니다.");
		$newPwd.select();
		return false;
	}
	
	return true;	
}
</script>
</head>
<body>
	<div id="updatePassword-container">
		<form name="updatePasswordFrm" action="" method="post">
			<input type="hidden" name="memberId" value="<%=request.getParameter("memberId") %>" />
			<table>
				<tr>
					<th>Current password</th>
					<td><input type="password" name="password" id="password" required></td>
				</tr>
				<tr>
					<th>New password</th>
					<td>
						<input type="password" name="newPassword" id="newPassword" required>
					</td>
				</tr>
				<tr>
					<th>Check password</th>
					<td>	
						<input type="password" id="newPasswordCheck" required><br>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<input type="submit"  value="Edit" onclick="return passwordValidate();"/>&nbsp;
						<input type="button" onclick="self.close();" value="Close" />						
					</td>
				</tr>
			</table>
		</form>
	</div>
</body>
</html>
