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
		alert("Please enter your details");
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
<h2>Modified</h2>
<form action="<%=request.getContextPath() %>/board/boardUpdate" method="post" 
	  enctype="multipart/form-data">
<input type="hidden" name="boardNo" value="<%= b.getBoardNo() %>" />
	<div id="boardInputUpdate">
		<input class="frmInput" type="text" name="boardTitle" value="<%=b.getBoardTitle()%>" required>
		<textarea class="frmInput" rows="25" cols="60" name="boardContent" required><%=b.getBoardContent() %></textarea>
		<br />
		<div id="frmFile">ps. 
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
				<label for="delFile">Attachment delete</label>
				
			<% } %>
		</div>
		<div id="frmWriter">From. 
			<input class="frmInput" type="text" name="boardWriter" value="<%=memberLoggedIn.getMemberId()%>" readonly/>
		</div>
	</div>
	<input type="submit" onclick="return boardValidate();" value="Modify" />
	<input type="button" value="Cancel" onclick="boardView();">

</form>
</section>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
