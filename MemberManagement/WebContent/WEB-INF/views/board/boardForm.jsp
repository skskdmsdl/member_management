<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/header.jsp" %>    
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/board.css" />

<script>
function boardValidate(){
	//내용을 작성하지 않은 경우에 대한 유효성 검사하세요.
	//공백만 작성한 경우도 폼이 제출되어서는 안됨.
	let $boardTitle = $("[name=boardTitle]");
	let $boardContent = $("[name=boardContent]");
	
	if($boardTitle.val().trim().length == 0){
		alert("제목을 입력하세요.");
		return false;
	}

	if($boardContent.val().trim().length == 0){
		alert("내용을 입력하세요.");
		return false;
	}
	
	return true;
}
</script>
<section id="board-container">
<h2>Write a post</h2>
<form action="<%=request.getContextPath() %>/board/boardInsert" 
	  method="post"
	  enctype="multipart/form-data">
	<table id="tbl-board-view">
	<tr>
		<th>Title</th>
		<td><input type="text" name="boardTitle" required></td>
	</tr>
	<tr>
		<th>Writer</th>
		<td>
			<input type="text" name="boardWriter" value="<%=memberLoggedIn.getMemberId()%>" readonly/>
		</td>
	</tr>
	<tr>
		<th>Attachments</th>
		<td>			
			<input type="file" name="upFile">
			<!-- 동일한 이름으로 파일 여러개 올라가는 것 주의하기 아래처럼 사용하면 됨 -->
			<!-- <input type="file" name="upFile2">
			<input type="file" name="upFile3"> -->
		</td>
	</tr>
	<tr>
		<th>Contents</th>
		<td><textarea rows="5" cols="40" name="boardContent" required></textarea></td>
	</tr>
	<tr>
		<th colspan="2">
			<input type="submit" value="Enroll" 
				   onclick="return boardValidate();">
		</th>
	</tr>
</table>
</form>
</section>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
