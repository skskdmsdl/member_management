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
div#search-container {margin:0 0 10px 0; padding:3px; width: 100%;}
div#search-memberId {<%= "memberId".equals(searchType) ? "display: inline;" : "display: none;" %>}
div#search-email {<%= "email".equals(searchType) ? "display: inline;" : "display: none;" %>}
div#search-memberRole {<%= "memberRole".equals(searchType) ? "display: inline;" : "display: none;" %>}
</style>
<script>
$(function(){
	
	$("#searchType").change(function(){
		$("#search-memberId, #search-email, #search-memberRole").hide();
		console.log($(this).val());//memberId -> #search-memberId
		$("#search-" + $(this).val()).css("display", "inline");
	});
	
});

function clear(){
    $("section table *").removeAttr("style");
}
$(document).ready(function(){
    $("section tbody tr").mouseenter(function(){
        clear();
        $(this).css("background", "#c6aa4c5c");
        $(this).css("cursor", "pointer");

    });
});
let tdArray = "";
$(document).ready(function(){
    $("section tbody tr").click(function(){
        clear();
        $(this).css("background", "#c6aa4c5c");
        $(this).css("cursor", "pointer");

        let tr = $(this); 
        let td = tr.children();
       
        tdArray = new Array(); // 배열에 값 담기
        td.each(function(i){
            tdArray.push(td.eq(i).text());
        });
        
        setTimeout(memberInfo, 300);
    });
}); 
function memberInfo(){
	
	$.ajax({
		url: "<%= request.getContextPath() %>/member/memberView?memberId="+tdArray[0],
		method: "POST", 
		dataType: "text", //html, text, json, xml 리턴된 데이터에 따라 자동설정됨
		data:  {"memberId": tdArray[0]}, //사용자 입력값전달
		success: function(data){
			//요청성공시 호출되는 함수
			console.log(data);
			location.href="<%=request.getContextPath()%>/member/memberView?memberId="+tdArray[0];
		},
		error: function(xhr, textStatus, errorThrown){
			console.log("ajax 요청 실패!");
			console.log(xhr, textStatus, errorThrown);
		}
	});
}
</script>
<section id="memberList-container">
	<h2>MemberList</h2>
	
	<div id="search-container">
		SearchType : 
		<select id="searchType">
			<option value="memberId" <%= "memberId".equals(searchType) ? "selected" : "" %>>Id</option>		
			<option value="email" <%= "email".equals(searchType) ? "selected" : "" %>>Email</option>
			<option value="memberRole" <%= "memberRole".equals(searchType) ? "selected" : "" %>>MemberRole</option>
		</select>
		<div id="search-memberId">
			<form action="<%=request.getContextPath()%>/admin/memberFinder">
				<input type="hidden" name="searchType" value="memberId"/>
				<input type="search" name="searchKeyword"  size="25" placeholder="Please enter your Id" 
					   value="<%= "memberId".equals(searchType) ? searchKeyword : "" %>"/>
				<button type="submit">Search</button>			
			</form>	
		</div>
		<div id="search-email">
			<form action="<%=request.getContextPath()%>/admin/memberFinder">
				<input type="hidden" name="searchType" value="memberName"/>
				<input type="search" name="searchKeyword" size="25" placeholder="Please enter your Email"
					   value="<%= "email".equals(searchType) ? searchKeyword : "" %>"/>
				<button type="submit">Search</button>			
			</form>	
		</div>
		<div id="search-memberRole">
			<form action="<%=request.getContextPath()%>/admin/memberFinder">
		    	<input type="hidden" name="searchType" value="memberRole"/>
				
				<input type="radio" name="searchKeyword" id="role-A" value="A" <%= "memberRole".equals(searchType) && "A".equals(searchKeyword) ? "checked": "" %>> 
				<label for="role-A">Admin</label>
		    	<input type="radio" name="searchKeyword" id="role-U" value="U" <%= "memberRole".equals(searchType) && "U".equals(searchKeyword) ? "checked": "" %>>
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
				<th colspan="10">No member has been checked.</th>
			</tr>
			
		<% 
			} else { 
				
				for(Member m : list){
		%>
			<%--조회된 회원이 있는 경우 --%>	
				<tr>
					<td><%= m.getMemberId() %></td>
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
