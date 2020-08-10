<%@page import="board.model.vo.BoardComment"%>
<%@page import="java.util.List"%>
<%@page import="board.model.vo.Board"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%
	Board board = (Board)request.getAttribute("board");
	List<BoardComment> commentList
		= (List<BoardComment>)request.getAttribute("commentList");
%>
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/board.css" />
<script>
function fildDownload(oname, rname){
	
	let url = "<%= request.getContextPath() %>/board/fileDownload";
	//한글을 %문자(유니코드)로 변경
	oname = encodeURIComponent(oname);
	console.log(oname);
	location.href = url + "?oname=" + oname + "&rname=" + rname; 
	
}

$(function(){
	/*
	* @ 실습문제
	* 1. 삭제버튼은 작성자 본인과 관리자에게만 노출
	*		-> 로그인한 사용자 == BoardComment.boardCommentWriter
	*		-> 관리자
	* 2. 삭제는 deleteCommentFrm을 통해 POST요청 
	*		-> /board/boardCommentDelete POST
	*		-> deleteCommentFrm POST전송
	*		-> boardCommentNo : delete from board_comment where board_comment_no = ?
	* 3. 삭제후에는 해당게시글 상세보기 페이지로 이동
	*		-> msg.jsp msg loc
	*		-> loc : /board/boardView?boardNo=?
	*
	* 
	*/
	$(".btn-delete").click(function(){
		if(!confirm('Are you sure you want to delete?')) return;
		
		//삭제 : post방식 요청
		//삭제할 번호 가져오기
		let boardCommentNo = $(this).val();
		//alert(boardCommentNo);
		
		let $frm = $("[name=deleteCommentFrm]");
		$frm.children("[name=boardCommentNo]").val(boardCommentNo);
		$frm.attr('action', '<%= request.getContextPath() %>/board/boardCommentDelete')
			.attr('method', 'POST')
			.submit();
	});
	
	$("#boardCommentContent").click(function(){
		if(<%= memberLoggedIn == null %>)
			loginAlert();
	});
	
	$("[name=boardCommentFrm]").submit(function(){
		
		//로그인 여부 검사
		if(<%= memberLoggedIn == null %>){
			loginAlert();
			return false;			
		}
		
		//댓글 검사
		let $boardContent = $("#boardCommentContent");
		if(!/^.{1,}$/.test($boardContent.val())){
			alert("댓글 내용을 작성해 주세요.");
			return false;
		}
		
	});
	
	$(".btn-reply").click(function(){
		if(<%= memberLoggedIn == null %>)
			loginAlert();
		else {
			let $tr = $("<tr></tr>");
			let $td = $("<td style='display:none; text-align:left;' colspan=2></td>");
			let $frm = $("<form action='<%=request.getContextPath() %>/board/boardCommentInsert' method='POST'></form>");
			$frm.append("<input type='hidden' name='boardRef' value='<%= board.getBoardNo() %>' />");
			$frm.append("<input type='hidden' name='boardCommentWriter' value='<%= memberLoggedIn != null ? memberLoggedIn.getMemberId() : "" %>' />");
			$frm.append("<input type='hidden' name='boardCommentLevel' value='2' />");
			$frm.append("<input type='hidden' name='boardCommentRef' value='"+$(this).val()+"' />");
			$frm.append("<textarea name='boardCommentContent' cols=50 rows=1></textarea>");
			$frm.append("<button type='submit' class='btn-insert2'>Enroll</button>");
			
			$td.append($frm);
			$tr.append($td);
			let $boardCommentTr = $(this).parent().parent();
			$tr.insertAfter($boardCommentTr)
			   .children("td").slideDown(800)
			   .children("form").submit(function(){
				   let $textarea = $(this).find("textarea");
				   if($textarea.val().length == 0)
					   return false;
			   })
			   .children("textarea").focus();
		}
		
		//1회만 작동하도록 함.
		$(this).off("click");
	});
	
});

function loginAlert(){
	alert("Available after login");
	$("#memberId").focus();
}
</script>

<section id="board-container">
	<h2>Community</h2>
	<table id="tbl-board-view">
		<tr>
			<th>No</th>
			<td><%= board.getBoardNo() %></td>
		</tr>
		<tr>
			<th>Title</th>
			<td><%= board.getBoardTitle() %></td>
		</tr>
		<tr>
			<th>Writer</th>
			<td><%= board.getBoardWriter() %></td>
		</tr>
		<tr>
			<th>Views</th>
			<td><%= board.getBoardReadCount() %></td>
		</tr>
		<tr>
			<th>Attachments</th>
			<td>
				<% if(board.getBoardOriginalFileName() != null){ %>
				<!-- 첨부파일이 있을경우만, 이미지와 함께 original파일명 표시 -->
				<a href="javascript:fildDownload('<%= board.getBoardOriginalFileName() %>','<%= board.getBoardRenamedFileName() %>');">
					<img alt="Attachments" src="<%=request.getContextPath() %>/images/file.png" width=16px>
					<%= board.getBoardOriginalFileName() %>
				</a>
				<% } %>
			</td>
		</tr>
		<tr>
			<th>Contents</th>
			<td><%= board.getBoardContent() %></td>
		</tr>
		<% if(memberLoggedIn != null 
			&& (MemberService.MEMBER_ROLE_ADMIN.equals(memberLoggedIn.getMemberRole())
				|| board.getBoardWriter().equals(memberLoggedIn.getMemberId()))
			){ %>
		<tr>
			<!-- 작성자와 관리자만 마지막행 수정/삭제버튼이 보일수 있게 할 것 -->
			<th colspan="2">
				<input type="button" value="Modify" 
					   onclick="location.href='<%= request.getContextPath() %>/board/boardUpdate?boardNo=<%= board.getBoardNo() %>';" /> 
				<input type="button" value="Delete" onclick="deleteBoard();"/>
			</th>
		</tr>
		
		<% } %>
	</table>
	
	<hr style="margin-top: 30px;"/>
	
	<div class="comment-container">
		<!-- 댓글 작성폼 -->
		<div class="comment-editor">
			<form action="<%= request.getContextPath() %>/board/boardCommentInsert"
			      method="post"
			      name="boardCommentFrm">
			      <input type="hidden" name="boardRef" 
			      		 value="<%= board.getBoardNo() %>" />
			      <input type="hidden" name="boardCommentWriter" 
			      		 value="<%= memberLoggedIn != null ? memberLoggedIn.getMemberId() : ""%>" />
				  <input type="hidden" name="boardCommentLevel" value="1" />
				  <!-- 대댓글인 경우, 참조하는 댓글번호 -->			      		 
				  <input type="hidden" name="boardCommentRef" value="0" />			      		 
			      
			      <textarea name="boardCommentContent" 
			      			id="boardCommentContent" 
			      			cols="60" rows="2"></textarea>
			      <input type="submit" value="Enroll" id="btn-insert" />
			
			</form>
		</div>
		
		
		<!-- 댓글 보기 -->
		<table id="tbl-comment">
		<% 
			if(commentList != null && !commentList.isEmpty()){ 
				for (BoardComment bc : commentList) {
					if(bc.getBoardCommentLevel() == 1) {
					//댓글
		%>
			<tr class="level1">
				<td>
					<sub class="comment-writer">
						<%= bc.getBoardCommentWriter() %>
					</sub>
					<sub class="comment-date">
						<%= bc.getBoardCommentDate() %>
					</sub>
					<br />
					<%= bc.getBoardCommentContent() %>
				</td>
				<td>
					<button class="btn-reply"
							value="<%= bc.getBoardCommentNo() %>">Reply</button>
					<% if(
						memberLoggedIn != null
						&& (memberLoggedIn.getMemberId().equals(bc.getBoardCommentWriter())
							|| memberLoggedIn.getMemberRole().equals(MemberService.MEMBER_ROLE_ADMIN))
					
						){ %>
					<button class="btn-delete"
							value="<%= bc.getBoardCommentNo() %>">Del</button>
					<% } %>
				</td>
			</tr>	
		<% 
					} else {
					//대댓글
		%>		
			<tr class="level2">
				<td>
					<sub class="comment-writer">
						<%= bc.getBoardCommentWriter() %>
					</sub>
					<sub class="comment-date">
						<%= bc.getBoardCommentDate() %>
					</sub>
					<br />
					<%= bc.getBoardCommentContent() %>
				</td>
				<td>
					<% if(
						memberLoggedIn != null
						&& (memberLoggedIn.getMemberId().equals(bc.getBoardCommentWriter())
							|| memberLoggedIn.getMemberRole().equals(MemberService.MEMBER_ROLE_ADMIN))
					
						){ %>
					<button class="btn-delete"
							value="<%= bc.getBoardCommentNo() %>">Del</button>
					<% } %>
				</td>
		<% 		
					}
				}
			} 
		%>
			</tr>

		</table>
		
		<!-- 댓글 삭제 폼 -->
		<form action="" name="deleteCommentFrm">
			<input type="hidden" name="boardCommentNo" value="" />
			<input type="hidden" name="boardNo" value="<%= board.getBoardNo() %>" />
		</form>
		
	</div>
	
</section>
<% if(memberLoggedIn != null 
	&& (MemberService.MEMBER_ROLE_ADMIN.equals(memberLoggedIn.getMemberRole())
		|| board.getBoardWriter().equals(memberLoggedIn.getMemberId()))
){ %>
<form name="deleteBoardFrm" 
	  action="<%= request.getContextPath() %>/board/boardDelete" 
	  method="POST">
	<input type="hidden" name="boardNo" value="<%= board.getBoardNo() %>" />
	<input type="hidden" name="rname" value="<%= board.getBoardRenamedFileName() != null ? board.getBoardRenamedFileName() : ""%>" />
</form>
<!-- 일반 사용자가 이 함수 구경조차 못하도록 이 위치에 script -->
<script>
function deleteBoard(){
	if(!confirm("Are you sure you want to delete?")) return;
	
	$("[name=deleteBoardFrm]").submit();	
}
</script>
<% } %>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
