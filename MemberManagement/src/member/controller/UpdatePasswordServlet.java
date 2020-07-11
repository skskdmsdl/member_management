package member.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.util.Utils;
import member.model.service.MemberService;
import member.model.vo.Member;

/**
 * Servlet implementation class UpdatePasswordServlet
 */
@WebServlet("/member/updatePassword")
public class UpdatePasswordServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UpdatePasswordServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		request.getRequestDispatcher("/WEB-INF/views/member/updatePassword.jsp")
			   .forward(request, response);
		
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//1.사용자입력값 처리
		String memberId = request.getParameter("memberId");
		String password = Utils.getEncryptedPassword(request.getParameter("password"));
		String newPassword = Utils.getEncryptedPassword(request.getParameter("newPassword"));
		
		System.out.println(memberId);
		System.out.println(password);
		System.out.println(newPassword);
		
		//2.업무로직
		//기존 비밀번호 검사
		Member m = new MemberService().selectOne(memberId);
		String msg = "";
		String loc = "";
		if(m != null && password.equals(m.getPassword())) {
			//새비밀번호로 변경
			int result = new MemberService().updatePassword(memberId, newPassword);
			msg = result > 0 ? "비밀번호 변경 성공!" : "비밀번호 변경 실패!";
			request.setAttribute("script", "self.close();");//팝업창 닫기 처리
		}
		else {
			//비밀번호 재입력
			msg = "비밀번호를 잘못 입력하셨습니다.";
			loc = "/member/updatePassword?memberId="+memberId;
		}
		
		//3.응답  html 처리
		request.setAttribute("msg", msg);
		request.setAttribute("loc", loc);
		request.getRequestDispatcher("/WEB-INF/views/common/msg.jsp")
			   .forward(request, response);
		
		
		
		
	}

}






