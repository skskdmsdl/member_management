<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="member.model.vo.Member" %>    
<%
	Member memberLoggedIn = (Member)session.getAttribute("memberLoggedIn");
%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Member Management Project</title>
<link rel="stylesheet" href="<%=request.getContextPath() %>/css/style.css" />
<script src="<%= request.getContextPath() %>/js/jquery-3.5.1.js"></script>
<script>
$(function(){
	$("#login").submit(function(){
		let $loginId = $("#loginId");
		let $loginPwd = $("#loginPwd");
		
		if($loginId.val().length == 0) {
			alert("아이디를 입력하세요.");
			$loginId.focus();
			return false;
		}
		
		if($loginPwd.val().length == 0) {
			alert("비밀번호를 입력하세요.");
			$loginPwd.focus();
			return false;
		}
		
		return true;
	});
	
});


</script>
</head>
<body>
	<div id="container">
		<header>
			<h1>Harry Potter</h1>

			<!-- 로그인 버튼 -->
			<div class="login-container">
			<% if(memberLoggedIn == null) { %>
					<a href="#wrap" id="signup-button" onclick="signupbtn()" >Login</a>
					
			<% } else { %>
				<table id="logged-in">
					<tr>
						<td>
							Welcom, <strong><%= memberLoggedIn.getMemberId() %></strong>
						</td>
					</tr>
					<tr>
						<td>
							<input type="button" value="Infomation" />
							&nbsp;
							<input type="button" value="Logout" 
								   onclick="location.href='<%=request.getContextPath()%>/member/logout'"/>
						</td>
					</tr>
				
				</table>
			
			
			
			<% } %>
			</div>
			
			
			<!-- 메인메뉴 시작 -->
			<nav>
				<ul class="main-nav">
					<li><a href="<%= request.getContextPath() %>">Home</a></li>
					<li><a href="<%= request.getContextPath() %>/board/boardList">Community</a></li>
					<%-- <% if(memberLoggedIn != null 
						&& MemberService.MEMBER_ROLE_ADMIN.equals(memberLoggedIn.getMemberRole())){ %>
					<li><a href="<%= request.getContextPath() %>/admin/memberList">회원관리</a></li>
					<% } %> --%>
				</ul>
			</nav>
			<!-- 메인메뉴 끝 -->
			
		</header>
		
		<section id="content">
			
			<div id="signWrap"></div> 
	        <div id="wrap">
	            <div class="form-wrap">
	                <div class="button-wrap">
	                    <div id="btn"></div>
	                    <button type="button" id="loginBtn" class="togglebtn" onclick="login()">LOG IN</button>
	                    <button type="button" id="registerBtn" class="togglebtn" onclick="register()">REGISTER</button>
	                </div>
	                <input type="button" id="closeBtn" value="x" onclick="closeBtn();">
	                <div class="icons">
	                    <img src="images/Snitch.png" alt="Golden-Snitch">
	                </div>   
	                <form action="<%= request.getContextPath() %>/member/login" id="login" method="post" class="input-group">
	                    <input type="text" id="loginId" name="memberId" class="input-field" placeholder="User ID" required>
	                    <input type="password" id="loginPwd" name="password" class="input-field" placeholder="Enter Password" required>
	                    <input type="checkbox" class="checkbox"><span>Remember Password</span>
	                    <input type="submit" class="submit" value="LOG IN" />
	                </form>
	                <form id="register" action="javascript:alert('가입완료');" onsubmit="return resisterVal();" class="input-group">
	                    <input type="text" id="userId" class="input-field" placeholder="User ID" required>
	                    <input type="email" id="userEmail" class="input-field" placeholder="User Email" required>
	                    <input type="password" id="userPwd" class="input-field" placeholder="Enter Password" required>
	                    <input type="password" id="userPwdChk" class="input-field" placeholder="Enter Password Check" required>
	                    <input type="checkbox" class="checkbox"><span>Terms and conditions</span>
	                    <button class="submit">REGISTER</button>
	                </form>
	            </div>
	        </div>
		<script>
		//로그인 관련
		var x = document.getElementById("login");
		var y = document.getElementById("register");
		var z = document.getElementById("btn");
		var loginbtn = document.getElementById("loginBtn");
		var registerbtn = document.getElementById("registerBtn");
		
		function login(){
		    x.style.left = "50px";
		    y.style.left = "450px";
		    z.style.left = "0";
		    loginbtn.style.color = "white";
		    registerbtn.style.color = "black";
		}
		function register(){
		    x.style.left = "-400px";
		    y.style.left = "50px";
		    z.style.left = "110px";
		    loginbtn.style.color = "black";
		    registerbtn.style.color = "white";
		}
		function signupbtn() {
		    wrap.style.display = "block";
		    signWrap.style.display = "block";
		}
		function closeBtn() {
		    wrap.style.display = "none";
		    signWrap.style.display = "none";
		}
		</script>
	        