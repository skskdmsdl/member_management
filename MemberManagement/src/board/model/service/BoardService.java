package board.model.service;

import static common.JDBCTemplate.*;

import java.sql.Connection;
import java.util.List;

import board.model.dao.BoardDAO;
import board.model.vo.Board;
import board.model.vo.BoardComment;

public class BoardService {
	private BoardDAO boardDAO = new BoardDAO();

	public int selectBoardCount() {
		Connection conn = getConnection();
		int totalContents = boardDAO.selectBoardCount(conn);
		close(conn);
		return totalContents;
	}

	public List<Board> selectBoardList(int cPage, int numPerPage) {
		Connection conn = getConnection();
		List<Board> list= boardDAO.selectBoardList(conn, cPage, numPerPage);
		close(conn);
		return list;
	}

	public Board selectOne(int boardNo) {
		Connection conn = getConnection();
		Board board = boardDAO.selectOne(conn, boardNo);
		close(conn);
		return board;
	}

	public int insertBoard(Board board) {
		Connection conn = getConnection();
		int result = new BoardDAO().insertBoard(conn, board);
		//트랜잭션 처리
		if(result>0) {
			int boardNo = new BoardDAO().selectLastBoardSeq(conn);
			//controller에서도 board객체의 참조주소를 통해 접근할 수 있다.
			board.setBoardNo(boardNo);
			commit(conn);
		}
		else 
			rollback(conn);
		close(conn);
		return result;
	}

	public Board selectOne(int boardNo, boolean hasRead) {
		Connection conn = getConnection();
		int result = 0;
		//조회수 증가
		if(!hasRead)
			result = boardDAO.increaseBoardReadCount(conn, boardNo);
		
		Board board = boardDAO.selectOne(conn, boardNo);
		
		if(result > 0) commit(conn);
		else rollback(conn);
		
		close(conn);
		return board;
	}

	public int deleteBoard(int board_no) {
		Connection conn = getConnection();
		int result = new BoardDAO().deleteBoard(conn, board_no);
		if(result>0)
			commit(conn);
		else 
			rollback(conn);
		close(conn);
		
		return result;
	}

	public int updateBoard(Board board) {
		Connection conn = getConnection();
		int result = boardDAO.updateBoard(conn, board);
		if(result > 0) commit(conn);
		else rollback(conn);
		close(conn);
		return result;
	}

	public int insertBoardComment(BoardComment bc) {
		Connection conn = getConnection();
		int result = boardDAO.insertBoardComment(conn, bc);
		if(result > 0) commit(conn);
		else rollback(conn);
		close(conn);
		return result;
	}

	public List<BoardComment> selectCommentList(int boardNo) {
		Connection conn = getConnection();
		List<BoardComment> commentList
			= boardDAO.selectCommentList(conn, boardNo);
		close(conn);
		return commentList;
	}

	public int deleteBoardComment(int boardCommentNo) {
		Connection conn = getConnection();
		int result = boardDAO.deleteBoardComment(conn, boardCommentNo);
		if(result > 0) commit(conn);
		else rollback(conn);
		close(conn);
		
		return result;
	}


}
