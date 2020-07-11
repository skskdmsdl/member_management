package member.controller;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.util.Utils;
import member.model.service.MemberService;
import member.model.vo.Member;

/**
 * Servlet implementation class MemberEnrollServlet
 */
@WebServlet("/member/enroll")
public class MemberEnrollServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public MemberEnrollServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//memberEnroll.jsp view단 forwarding 처리
		
		RequestDispatcher reqDispatcher = request.getRequestDispatcher("/WEB-INF/views/header.jsp");
		reqDispatcher.forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//사용자 회원가입정보를 db에 insert
		//1. 인코딩
		request.setCharacterEncoding("utf-8");
		
		//2. 사용자입력값 처리
		String memberId = request.getParameter("memberId");
		String password = Utils.getEncryptedPassword(request.getParameter("password")); //암호화
		String email = request.getParameter("email");
		
		//Member객체로 만들기
		Member newMember = new Member(memberId, password, MemberService.MEMBER_ROLE_USER, email, null);
		
		System.out.println("newMember="+newMember);
		
		//3. 업무로직: db에 insert (DML -> int =>1,0)
		int result = new MemberService().insertMember(newMember);
		System.out.println("result@memberEnrollServlet="+result);
		
		//4. 사용자 응답처리 : msg.jsp
		String msg = result > 0 ? "회원 가입 성공!" : "회원 가입 실패!";
		String loc = "/";  //회원 가입 성공 후 인덱스 페이지로 가도록 설정
		
		request.setAttribute("msg", msg);
		request.setAttribute("loc", loc);
		
		request.getRequestDispatcher("/WEB-INF/views/common/msg.jsp").forward(request, response);
		
	}

}
