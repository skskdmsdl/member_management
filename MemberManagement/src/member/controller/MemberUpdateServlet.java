package member.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import member.model.service.MemberService;
import member.model.vo.Member;

/**
 * Servlet implementation class MemberUpdateServlet
 */
@WebServlet("/member/memberUpdate")
public class MemberUpdateServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public MemberUpdateServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//1. 인코딩 처리
		request.setCharacterEncoding("utf-8");
		
		//2. 사용자입력값 처리
		String memberId = request.getParameter("memberId");
		String password = request.getParameter("password");
		String email = request.getParameter("email");
		
		Member updateMember = new Member(memberId, password, null, email, null);
//		System.out.println("updateMember@servlet-"+updateMember);
		
		//3. 업무로직(dml)
		int result = new MemberService().updateMember(updateMember);
//		System.out.println("result@servlet="+result);
		
		//세션에 변경 내역 반영
		HttpSession session = request.getSession();
		Member memberLoggedIn 
			= (Member)session.getAttribute("memberLoggedIn");
		
		if(result > 0 && memberId.equals(memberLoggedIn.getMemberId())) {
			memberLoggedIn.setEmail(email);
		}
		
		//4. 응답 view단 처리
		//jsp 주소(view)
		String view = "/WEB-INF/views/common/msg.jsp";
		//전달 메시지
		String msg = result > 0 ? "회원정보 수정 성공!" : "회원정보 수정 실패!";
		//수정을 마치고 이동할 페이지
		String loc = "/member/memberView?memberId="+memberId;
		
		request.setAttribute("msg", msg);
		request.setAttribute("loc", loc);
		request.getRequestDispatcher(view).forward(request, response);
	
	}

}
