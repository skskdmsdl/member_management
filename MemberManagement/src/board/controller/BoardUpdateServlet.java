package board.controller;

import java.io.File;
import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.tomcat.util.http.fileupload.servlet.ServletFileUpload;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.FileRenamePolicy;

import board.model.exception.BoardException;
import board.model.service.BoardService;
import board.model.vo.Board;
import common.MvcFileRenamePolicy;

/**
 * Servlet implementation class BoardUpdateServlet
 */
@WebServlet("/board/boardUpdate")
public class BoardUpdateServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public BoardUpdateServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//1.parameterHandling
		int boardNo;
		try{
			boardNo = Integer.parseInt(request.getParameter("boardNo"));
		}catch(NumberFormatException e){
			throw new BoardException("유효하지 않은 게시글입니다.");
		}
		//2.businessLogic
		Board b = new BoardService().selectOne(boardNo);
		
		//3.view
		request.setAttribute("board", b);
		request.getRequestDispatcher("/WEB-INF/views/board/boardUpdate.jsp").forward(request, response);
	}

	/**
	 *  기존첨부유무 
	 *  1. 기존첨부가 없는 경우
	 *  2. 기존첨부가 있는 경우
	 *  	- 기존 첨부파일 유지
	 *  	- 새첨부파일 추가 : 기존파일 삭제
	 *  	- 기존 첨부파일 삭제(삭제체크) : 기존파일 삭제
	 *  
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//0. enctype=multipart/form-data 여부 확인
		if(!ServletFileUpload.isMultipartContent(request)) {
			throw new BoardException("enctype오류!");
		}
		
		//1. MultipartRequest(cos.jar) 객체
		String saveDirectory = getServletContext().getRealPath("/upload/board");
		int maxPostSize = 1024 *  1024 * 10;
		String encoding = "utf-8";
		FileRenamePolicy policy = new MvcFileRenamePolicy();
		MultipartRequest multipartRequest
			= new MultipartRequest(request, saveDirectory, maxPostSize, encoding, policy);
		
		//2. 사용자입력값, 저장된 파일명, 업로드한 파일명 가져오기
		int boardNo = Integer.parseInt(multipartRequest.getParameter("boardNo"));
		String boardTitle = multipartRequest.getParameter("boardTitle");
		String boardWriter = multipartRequest.getParameter("boardWriter");
		String boardContent = multipartRequest.getParameter("boardContent");
		String boardOriginalFileName = multipartRequest.getOriginalFileName("upFile");
		String boardRenamedFileName = multipartRequest.getFilesystemName("upFile");
		String oldOriginalFileName = multipartRequest.getParameter("oldOriginalFileName");
		String oldRenamedFileName = multipartRequest.getParameter("oldRenamedFileName");
		String delFile = multipartRequest.getParameter("delFile");
		
		//3. 업무로직
		Board board 
		= new Board(boardNo, boardTitle, boardWriter, boardContent, 
				boardOriginalFileName, boardRenamedFileName, null, 0);

		//기존 첨부파일이 있는 경우 처리
		if(!"".equals(oldOriginalFileName)) {
			
			//새 첨부파일이 없는 경우
			if(boardOriginalFileName == null 
			 && delFile == null) {
				board.setBoardOriginalFileName(oldOriginalFileName);
				board.setBoardRenamedFileName(oldRenamedFileName);
			}
			//새 첨부파일이 있는 경우
			else {
				//파일 삭제
				File f = new File(saveDirectory, oldRenamedFileName);
				f.delete();
				System.out.println("[" + oldOriginalFileName + "] 파일 삭제!");
			}
			
		}
		
		
		System.out.println("board@servlet = " + board);
		int result = new BoardService().updateBoard(board);
		
		//4. view단
		String msg = result > 0 ? "게시글 수정 성공!" : "게시글 수정 실패!";
		String loc = "/board/boardView?boardNo=" + boardNo;
		request.setAttribute("msg", msg);
		request.setAttribute("loc", loc);
		request.getRequestDispatcher("/WEB-INF/views/common/msg.jsp")
			   .forward(request, response);
		
			
	}

}
