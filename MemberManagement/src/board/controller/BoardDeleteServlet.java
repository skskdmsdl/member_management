package board.controller;

import java.io.File;
import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import board.model.service.BoardService;

/**
 * Servlet implementation class BoardDeleteServlet
 */
@WebServlet("/board/boardDelete")
public class BoardDeleteServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public BoardDeleteServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		//1. 사용자 입력값 처리
		int boardNo = Integer.parseInt(request.getParameter("boardNo"));
		String rname = request.getParameter("rname");//1234_34.txt 혹은 ""
		
		//2. 업무로직
		//첨부파일 삭제
		if(!"".equals(rname)) {
			String saveDirectory = getServletContext().getRealPath("/upload/board");
			File delFile = new File(saveDirectory, rname);
			boolean delOk = delFile.delete();
			System.out.println(delOk ? "파일 삭제 성공!" : "파일 삭제 실패!");
		}
		
		//DB 레코드 삭제
		int result = new BoardService().deleteBoard(boardNo);
		
		//3. view단 처리
		String msg = result > 0 ? "게시글 삭제 성공!" : "게시글 삭제 실패!";
		String loc = "/board/boardList";
		
		request.setAttribute("msg", msg);
		request.setAttribute("loc", loc);
		request.getRequestDispatcher("/WEB-INF/views/common/msg.jsp")
			   .forward(request, response);
		
	}

}
