package board.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import board.model.service.BoardService;
import board.model.vo.Board;
import board.model.vo.BoardComment;

/**
 * Servlet implementation class BoardViewServlet
 */
@WebServlet("/board/boardView")
public class BoardViewServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public BoardViewServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			
			//1. 사용자 입력값 처리
			int boardNo = Integer.parseInt(request.getParameter("boardNo"));
			
			//2. 업무로직 
			//쿠키검사 : boardCookie
			Cookie[] cookies = request.getCookies();
			String boardCookieVal = "";
			boolean hasRead = false;
			
			if(cookies != null) {
				for(Cookie c : cookies) {
					String name = c.getName();
					String value = c.getValue();
					
					if("boardCookie".equals(name)) {
						boardCookieVal = value;
						
						if(value.contains("[" + boardNo + "]"))
							hasRead = true;
					}
				}
			}
			
			if(!hasRead) {			
				//boardCookie생성
				Cookie boardCookie = new Cookie("boardCookie", boardCookieVal + "[" + boardNo + "]");
				boardCookie.setPath(request.getContextPath()+"/board");
				boardCookie.setMaxAge(365*24*60*60);
				response.addCookie(boardCookie);
			}
			
			//조회
			Board board = new BoardService().selectOne(boardNo, hasRead);
			System.out.println("board@servlet = " + board);
			
			//개행문자처리
			String boardContentWithBr = board.getBoardContent()
					.replaceAll("\\n", "<br/>");
			board.setBoardContent(boardContentWithBr);
			
			//댓글 목록조회
			List<BoardComment> commentList
			= new BoardService().selectCommentList(boardNo);
			System.out.println("commentList@servlet = " + commentList);
			
			//3. view단 처리
			request.setAttribute("board", board);
			request.setAttribute("commentList", commentList);
			
			request.getRequestDispatcher("/WEB-INF/views/board/boardView.jsp")
			.forward(request, response);
		} catch(Exception e) {
			
			e.printStackTrace(); //디버깅용
			
			throw e; //was 웹 컨테이너에게 오류 던지기*** => 우리 프로젝트는 서버에 배포 후 서버를 실행하는것 우리는 오류 발생시 던지기만 하면됨
		}
		
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
