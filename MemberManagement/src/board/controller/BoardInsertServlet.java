package board.controller;

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
 * Servlet implementation class BoardFormEndServlet
 */
@WebServlet("/board/boardInsert")
public class BoardInsertServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public BoardInsertServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		//파일업로드 enctype="mulpart/form-data" 속성 사용여부
		if(!ServletFileUpload.isMultipartContent(request))
			throw new BoardException("파일업로드 enctype 속성 미적용! : " + request.getRequestURI());
		
		
		//MultipartRequest객체 생성
		//a.HttpServletRequest
		//b.saveDirectory : 업로드할 파일 저장경로(절대경로)
		//c.maxPostSize : 업로드할 파일 크기 제한 10mb
		//d.encoding 
		//e.FileRenamePolicy객체 : 중복파일 이름 재지정 객체
		String saveDirectory
//			= getServletContext().getRealPath("/") + File.separator+"upload"+File.separator+"board";
			= getServletContext().getRealPath("/") + "/upload/board";
		
		int maxPostSize = 1024 * 1024 * 10; //10MB
		
		FileRenamePolicy policy
//			= new DefaultFileRenamePolicy();//중복인 경우, numbering
			= new MvcFileRenamePolicy();
		
		MultipartRequest multipartRequest
			= new MultipartRequest(request, 
								   saveDirectory, 
								   maxPostSize, 
								   "utf-8", 
								   policy);
		
		//MultipartRequest객체를 사용하면,
		//기존의 HttpServletRequest에서는 사용자 입력값을 가져올 수 없다.
		String boardTitle = multipartRequest.getParameter("boardTitle");
		String boardWriter = multipartRequest.getParameter("boardWriter");
		String boardContent = multipartRequest.getParameter("boardContent");
		//XSS공격대비 : script태그 무효화처리
		boardContent = boardContent.replaceAll("<","&lt;")
								   .replaceAll(">", "&gt;");
		
		String boardOriginalFileName
			= multipartRequest.getOriginalFileName("upFile");
		String boardRenamedFileName
			= multipartRequest.getFilesystemName("upFile");
		
		Board board 
			= new Board(0, boardTitle, boardWriter, boardContent, 
						boardOriginalFileName, boardRenamedFileName, null, 0);
		System.out.println("board@servlet = " + board);
		
		//2. 비지니스로직 호출
		//[[2]]처리결과가 아닌 마지막에 추가한 공지사항 글번호를 가져옴
		int result = new BoardService().insertBoard(board);
		
		//3. 처리결과에 따른 view단에 처리위임.
		String view = "/WEB-INF/views/common/msg.jsp";
		String msg = result > 0 ? "게시판 등록 성공!" : "게시판 등록 실패!";
		String loc = "/board/boardView?boardNo="+board.getBoardNo();
		
		request.setAttribute("msg", msg);
		request.setAttribute("loc", loc);
		request.getRequestDispatcher(view).forward(request, response);

	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
