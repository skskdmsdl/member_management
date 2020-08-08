<%@page import="board.model.vo.BoardForList"%>
<%@page import="board.model.vo.Board"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%
	List<Board> list = (List<Board>)request.getAttribute("list");
	String pageBar = (String)request.getAttribute("pageBar");
%>

<link rel="stylesheet" href="<%=request.getContextPath()%>/css/board.css" />
<section id="board-container">
	<h2>게시판 </h2>
	
	<%-- 로그인한 경우 글쓰기 버튼 노출 --%>
	<% if(memberLoggedIn != null){ %>
	<input type="button" value="글쓰기" id="btn-add" 
		   onclick="location.href = '<%= request.getContextPath() %>/board/boardForm';" />
	<% } %>
	<table id="tbl-board">
		<tr>
			<th>번호</th>
			<th>제목</th>
			<th>작성자</th>
			<th>작성일</th>
			<th>첨부파일</th><%--첨부파일이 있는 경우, /images/file.png 표시 width:16px --%>
			<th>조회수</th>
		</tr>
		<% if(list == null || list.isEmpty()){ %>
			<%--조회된 행이 없는 경우 --%>
			<tr>
				<th colspan="6">조회된 행이 없습니다.</th>
			</tr>
		<% 
			} 
		   	else {
		   		
				for(Board b : list){
		%>
		<%--조회된 행이 있는 경우 --%>
				<tr>
					<td><%= b.getBoardNo() %></td>
					<td>
						<a href="<%= request.getContextPath() %>/board/boardView?boardNo=<%= b.getBoardNo() %>"><%= b.getBoardTitle() %></a>
						<%-- 댓글이 있는 경우 개수표시 --%>
			            <% if(((BoardForList)b).getCommentCnt()>0){ %>
			            (<%= ((BoardForList)b).getCommentCnt() %>)
			            <%} %>
					</td>
					<td><%= b.getBoardWriter() %></td>
					<td><%= b.getBoardDate() %></td>
					<td>
						<% if(b.getBoardOriginalFileName() != null) { %>
						<img alt="첨부파일" 
							 width="16px"
							 src="<%= request.getContextPath() %>/images/file.png">
						<% } %>
					</td>
					<td><%= b.getBoardReadCount() %></td>
				</tr>
		
		<% 		}
		
			} 
		%>
	</table>

	<div id='pageBar'>
		<%= pageBar %>
	</div>
</section>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
