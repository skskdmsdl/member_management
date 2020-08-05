<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	List<Member> list = (List<Member>)request.getAttribute("list");
	String searchType = request.getParameter("searchType");
	String searchKeyword = request.getParameter("searchKeyword");
%>    
 
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<!-- 관리자용 admin.css link -->
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin.css" />
<style>
div#search-container {margin:0 0 10px 0; padding:3px; background-color: rgba(0, 188, 212, 0.3); width: 100%;}
div#search-memberId {<%= "memberId".equals(searchType) ? "display: inline-block;" : "display: none;" %>}
div#search-memberName {<%= "memberName".equals(searchType) ? "display: inline-block;" : "display: none;" %>}
div#search-gender {<%= "gender".equals(searchType) ? "display: inline-block;" : "display: none;" %>}
</style>
<script>
$(function(){
	
	$("#searchType").change(function(){
		$("#search-memberId, #search-memberName, #search-gender").hide();
		console.log($(this).val());//memberId -> #search-memberId
		$("#search-" + $(this).val()).css("display", "inline-block");
	});
	
});

</script>
<section id="memberList-container">
	<h2>회원관리</h2>
	
	<div id="search-container">
		검색타입 : 
		<select id="searchType">
			<option value="memberId" <%= "memberId".equals(searchType) ? "selected" : "" %>>아이디</option>		
			<option value="memberName" <%= "memberName".equals(searchType) ? "selected" : "" %>>회원명</option>
			<option value="gender" <%= "gender".equals(searchType) ? "selected" : "" %>>성별</option>
		</select>
		<div id="search-memberId">
			<form action="<%=request.getContextPath()%>/admin/memberFinder">
				<input type="hidden" name="searchType" value="memberId"/>
				<input type="search" name="searchKeyword"  size="25" placeholder="검색할 아이디를 입력하세요." 
					   value="<%= "memberId".equals(searchType) ? searchKeyword : "" %>"/>
				<button type="submit">검색</button>			
			</form>	
		</div>
		<div id="search-memberName">
			<form action="<%=request.getContextPath()%>/admin/memberFinder">
				<input type="hidden" name="searchType" value="memberName"/>
				<input type="search" name="searchKeyword" size="25" placeholder="검색할 이름을 입력하세요."
					   value="<%= "memberName".equals(searchType) ? searchKeyword : "" %>"/>
				<button type="submit">검색</button>			
			</form>	
		</div>
		<div id="search-gender">
			<form action="<%=request.getContextPath()%>/admin/memberFinder">
		    	<input type="hidden" name="searchType" value="gender"/>
				
				<input type="radio" name="searchKeyword" id="gender-M" value="M" <%= "gender".equals(searchType) && "M".equals(searchKeyword) ? "checked": "" %>> 
				<label for="gender-M">남</label>
		    	<input type="radio" name="searchKeyword" id="gender-F" value="F" <%= "gender".equals(searchType) && "F".equals(searchKeyword) ? "checked": "" %>>
				<label for="gender-F">여</label>
				
		    	<button type="submit">검색</button>
		    </form>
		</div>
	</div>
	
	<table id="tbl-member">
		<thead>
			<tr>
				<th>아이디</th>
				<th>이름</th>
				<th>회원권한</th>
				<th>성별</th>
				<th>생년월일</th>
				<th>이메일</th>
				<th>전화번호</th>
				<th>주소</th>
				<th>취미</th>
				<th>가입날짜</th>
			</tr>
		</thead>
		<tbody>
		
		<% if(list == null || list.isEmpty()){ %>	
			<%--조회된 회원이 없는 경우 --%>
			<tr>
				<th colspan="10"> 조회된 회원이 없습니다.</th>
			</tr>
			
		<% 
			} else { 
				
				for(Member m : list){
		%>
			<%--조회된 회원이 있는 경우 --%>	
				<tr>
					<td>
						<a href="<%= request.getContextPath()%>/member/memberView?memberId=<%= m.getMemberId() %>">
							<%= m.getMemberId() %>
						</a>
					</td>
					<td><%=m.getMemberName() %></td>
					<td><%=m.getMemberRole() %></td>
					<td><%=m.getGender() %></td>
					<td><%=m.getBirthDay() != null ? m.getBirthDay() : "" %></td>
					<td><%=m.getEmail() != null ? m.getEmail() : "" %></td>
					<td><%=m.getPhone() %></td>
					<td><%=m.getAddress() != null ? m.getAddress() : "" %></td>
					<td><%=m.getHobby() != null ? m.getHobby() : "" %></td>
					<td><%=m.getEnrollDate() %></td>
				</tr>
		<% 		
				}
		   } 
		%>
		</tbody>
	</table>
	
	<div id="pageBar">
		<%= request.getAttribute("pageBar") %>
	</div>
	
</section>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
