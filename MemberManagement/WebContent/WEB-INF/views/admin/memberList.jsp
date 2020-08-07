<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	List<Member> list = (List<Member>)request.getAttribute("list");
%>    
 
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<!-- 관리자용 admin.css link -->
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin.css" />

<style>
div#search-container {margin:0 0 10px 0; padding:3px; background-color: rgba(0, 188, 212, 0.3); width: 100%;}
div#search-memberId {display: inline-block;}
div#search-email{display:none;}
div#search-memberRole{display:none;}
</style>
<script>
$(function(){
	
	$("#searchType").change(function(){
		$("#search-memberId, #search-email, #search-memberRole").hide();
		console.log($(this).val());//memberId -> #search-memberId
		$("#search-" + $(this).val()).css("display", "inline-block");
	});
	
});

</script>
<section id="memberList-container">
	<h2>MemberList</h2>
	
	<div id="search-container">
		SearchType : 
		<select id="searchType">
			<option value="memberId">Id</option>		
			<option value="email">Email</option>
			<option value="memberRole">MemberRole</option>
		</select>
		<div id="search-memberId">
			<form action="<%=request.getContextPath()%>/admin/memberFinder">
				<input type="hidden" name="searchType" value="memberId"/>
				<input type="search" name="searchKeyword"  size="25" placeholder="Please enter your Id" />
				<button type="submit">Search</button>			
			</form>	
		</div>
		<div id="search-email">
			<form action="<%=request.getContextPath()%>/admin/memberFinder">
				<input type="hidden" name="searchType" value="email"/>
				<input type="search" name="searchKeyword" size="25" placeholder="Please enter your Email"/>
				<button type="submit">Search</button>			
			</form>	
		</div>
		<div id="search-memberRole">
			<form action="<%=request.getContextPath()%>/admin/memberFinder">
		    	<input type="hidden" name="searchType" value="memberRole"/>
				
				<input type="radio" name="searchKeyword" id="role-A" value="A"> 
				<label for="role-A">Admin</label>
		    	<input type="radio" name="searchKeyword" id="role-U" value="U">
				<label for="role-U">GeneralUser</label>
				
		    	<button type="submit">Search</button>
		    </form>
		</div>
	</div>
	
	<table id="tbl-member">
		<thead>
			<tr>
				<th>Id</th>
				<th>MemberRole</th>
				<th>Email</th>
				<th>EnrollDate</th>
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
					<td><%=m.getMemberRole() %></td>
					<td><%=m.getEmail() != null ? m.getEmail() : "" %></td>
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
