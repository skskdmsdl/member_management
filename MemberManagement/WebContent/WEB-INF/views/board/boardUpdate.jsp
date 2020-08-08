<%@page import="board.model.vo.Board"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%
	Board b = (Board)request.getAttribute("board");
%>    
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/board.css" />

<script>
function boardValidate(){
	var $content = $("[name=content]");
	if($content.val().trim().length==0){
		alert("내용을 입력하세요");
		return false;
	}
	return true;
}
function boardView(){
	history.go(-1);
}

$(function(){
	//사용자가 파일을 선택/해제한 경우
	$("[name=upFile]").change(function(){
		console.log($(this).val());
		if($(this).val() != ""){
			$("#fname").hide();
		}
		else {
			$("#fname").show();
		}
	});
	
	
});


</script>
<section id="board-container">
<h2>게시판 수정</h2>
<form action="<%=request.getContextPath() %>/board/boardUpdate" method="post" 
	  enctype="multipart/form-data">
<input type="hidden" name="boardNo" value="<%= b.getBoardNo() %>" />
<table id="tbl-board-view">
	<tr>
		<th>제목</th>
		<td>
			<input type="text" name="boardTitle" 
				   value="<%=b.getBoardTitle()%>" required/>
		</td>
	</tr>		
	<tr>
		<th>작성자</th>
		<td>
			<input type="text" name="boardWriter" 
					value="<%=b.getBoardWriter()%>" readonly required/>
		</td>
	</tr>		
	<tr>
		<th>첨부파일</th>
		<td style="position:relative; ">
			<input type="file" name="upFile"/>
			<!-- 파일태그의 value속성값은 보안상 이유로 임의변경할 수 없다 -->
			<span id="fname"><%= b.getBoardOriginalFileName() != null ? b.getBoardOriginalFileName() : "" %></span>
			<input type="hidden" name="oldOriginalFileName"
				   value="<%= b.getBoardOriginalFileName() != null ? b.getBoardOriginalFileName() : "" %>" />
			<input type="hidden" name="oldRenamedFileName"
				   value="<%= b.getBoardRenamedFileName() != null ? b.getBoardRenamedFileName() : "" %>" />
			
			<%-- 첨부파일 삭제 버튼 --%>
			<% if(b.getBoardOriginalFileName() != null){ %>
				<br />
				<input type="checkbox" name="delFile" id="delFile" />
				<label for="delFile">첨부파일 삭제</label>
				
			<% } %>
		</td>
	</tr>		
	<tr>
		<th>내 용</th>
		<td>
			<textarea name="boardContent" cols="50" rows="5"><%=b.getBoardContent() %></textarea>
		</td>
	</tr>		
	<tr>
		<th colspan="2">
			<input type="submit" onclick="return boardValidate();" value="수정하기" />
			<input type="button" value="취소" onclick="boardView();">
		</th>
	</tr>
	</table>
</form>
</section>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
