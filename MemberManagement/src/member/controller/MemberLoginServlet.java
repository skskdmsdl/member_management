package member.controller;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import common.JDBCTemplate;
import member.model.service.MemberService;
import member.model.vo.Member;

/**
 * Servlet implementation class MemberLoginServlet
 */
@WebServlet("/member/login")
public class MemberLoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public MemberLoginServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
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
		System.out.println("memberId@servlet="+memberId);
		System.out.println("password@servlet="+password);
		
		System.out.println(JDBCTemplate.getConnection());
		//3. 업무로직
		Member m = new MemberService().selectOne(memberId);
		System.out.println(m);
		
		//4. 응답처리
		//아이디, 비번이 모두 일치하는 경우 
		if(m != null 
		&& memberId.equals(m.getMemberId())
		&& password.equals(m.getPassword())) {
			
//			//로그인한 사용자 정보 저장
//			request.setAttribute("memberLoggedIn", m);
//			
//			RequestDispatcher reqDispatcher
//				= request.getRequestDispatcher("/index.jsp");
//			reqDispatcher.forward(request, response);
			
			//세션가져오기 : create 여부 true 
			//세션객체가 없다면, 새로 생성후 리턴
			//세션객체가 있다면, 가져오기
			HttpSession session = request.getSession(true);
			//System.out.println("sessionId="+session.getId());
			
			//세션유효시간설정 : 초
			//web.xml 선언한 session-config > session-timeout 보다 우선순위가 높다.
			session.setMaxInactiveInterval(30*60);
			
			
			//세션에 로그인한 사용자 정보 저장
			session.setAttribute("memberLoggedIn", m);
			
//			//쿠키(saveId) 처리
//			Cookie c = new Cookie("saveId", memberId);
//			c.setPath(request.getContextPath());//쿠키유효디렉토리 설정
//			
//			//saveId 체크한 경우 : 쿠키 생성
//			if(saveId != null) {
//				c.setMaxAge(7*24*60*60);//7일				
//			}
//			//saveId를 체크하지 않은 경우: 쿠키 삭제
//			else {
//				c.setMaxAge(0);//브라우져에서 즉시삭제
//			}
//			
//			response.addCookie(c);
			
			//리다이렉트 처리
			//로그인 요청페이지로 이동
			String referer = request.getHeader("referer");
			response.sendRedirect(referer);
			
		}
		//아이디 또는 비번이 틀린경우
		else {
			request.setAttribute("msg", "아이디 또는 비밀번호가 일치하지 않습니다.");
			request.setAttribute("loc", "/"); //사용자 피드백 이후 이동할 페이지
			
			RequestDispatcher reqDispatcher
			= request.getRequestDispatcher("/WEB-INF/views/common/msg.jsp");
			reqDispatcher.forward(request, response);
			
		}
		
		
		
	}

}
