package admin.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import common.util.Utils;
import member.model.service.MemberService;
import member.model.vo.Member;

/**
 * Servlet implementation class AdminMemberFinderServlet
 */
@WebServlet("/admin/memberFinder")
public class AdminMemberFinderServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AdminMemberFinderServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//1. 사용자 입력값 처리
		String searchType = request.getParameter("searchType");
		String searchKeyword = request.getParameter("searchKeyword");
		System.out.println("searchType@servlet = " + searchType);
		System.out.println("searchkeyword@servlet = " + searchKeyword);
		
		int numPerPage = 10;
		int cPage = 1;
		try {
			cPage = Integer.parseInt(request.getParameter("cPage"));
		} catch(NumberFormatException e) {
			//예외가 던져진 경우, cPage = 1로 유지
		}
		//2. 업무로직 
		//contents영역 : 
		List<Member> list 
		= new MemberService().searchMember(searchType, searchKeyword, cPage, numPerPage);
		System.out.println("list@servlet = " + list);
		
		//select * from member where member_id like '%k%'
		//select * from member where ? like ?
		//식별자 부분은 PrepareStatement가 지원하는 setter를 이용할 수 없다.
		
		//pageBar영역
		int totalContents = new MemberService().selectTotalContents(searchType, searchKeyword);
		String url 
			= request.getRequestURI() 
			+ "?searchType=" + searchType 
			+ "&searchKeyword=" + searchKeyword 
			+ "&";
		// /mvc/admin/memberFinder?searchType=memberId&searchKeyword=h
		System.out.println("totalContents@servlet = " + totalContents);
		String pageBar = Utils.getPageBarHtml(cPage, numPerPage, totalContents, url);
		
		
		
		//3. view단 처리
		request.setAttribute("list", list);
		request.setAttribute("pageBar", pageBar);
		request.getRequestDispatcher("/WEB-INF/views/admin/memberFinder.jsp")
			   .forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
