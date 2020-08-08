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
<h2>게시판 작성</h2>
<form action="<%=request.getContextPath() %>/board/boardInsert" 
	  method="post"
	  enctype="multipart/form-data">
	<table id="tbl-board-view">
	<tr>
		<th>제 목</th>
		<td><input type="text" name="boardTitle" required></td>
	</tr>
	<tr>
		<th>작성자</th>
		<td>
			<input type="text" name="boardWriter" value="<%=memberLoggedIn.getMemberId()%>" readonly/>
		</td>
	</tr>
	<tr>
		<th>첨부파일</th>
		<td>			
			<input type="file" name="upFile">
			<!-- 동일한 이름으로 파일 여러개 올라가는 것 주의하기 아래처럼 사용하면 됨 -->
			<!-- <input type="file" name="upFile2">
			<input type="file" name="upFile3"> -->
		</td>
	</tr>
	<tr>
		<th>내 용</th>
		<td><textarea rows="5" cols="40" name="boardContent" required></textarea></td>
	</tr>
	<tr>
		<th colspan="2">
			<input type="submit" value="등록하기" 
				   onclick="return boardValidate();">
		</th>
	</tr>
</table>
</form>
</section>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
