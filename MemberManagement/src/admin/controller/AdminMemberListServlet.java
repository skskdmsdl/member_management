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
 * 1. contents영역
 * (공식1) 시작 rownum / 끝 rownum
 * 
 * 2. pageBar영역
 * (공식2) totalPage : ceil((double)totalContens/numPerPage)
 * (공식3) pageBarStartNo 
 * 
 * 필요변수
 * cPage 현재페이지
 * numPerPage 한페이지에 표시할 컨텐츠수 10
 * totalContents 총 컨텐츠수 101
 * totalPage 총 페이지수 11 ceil((double)totalContents/numPerPage)
 * pageNo : 페이지넘버 출력용 증감변수
 * pageStartNo | pageEndNo : 페이지바 범위
 *  
 *  
 */
@WebServlet("/admin/memberList")
public class AdminMemberListServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AdminMemberListServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		//0. 사용자입력값
		int numPerPage = 10;
		int cPage = 1;
		
		try {
			cPage = Integer.parseInt(request.getParameter("cPage"));
		} catch(NumberFormatException e) {
			//예외가 던져진 경우, cPage = 1로 유지
		}
		
		//1. 업무로직 : 회원목록
		//컨텐츠영역에 대한 쿼리 요청
		List<Member> list = new MemberService().selectAll(cPage, numPerPage);
//		System.out.println("list@servlet = " + list);
		
		
		//페이지바 영역 html
		String url = request.getRequestURI() + "?";// /mvc/admin/memberList?
		int totalContents = new MemberService().selectTotalContents();
		System.out.println("totalContents@servlet = " + totalContents);
		String pageBar 
			= Utils.getPageBarHtml(cPage, numPerPage, totalContents, url);
		
		//2. view단 위임
		request.setAttribute("list", list);
		request.setAttribute("pageBar", pageBar);
		
		request.getRequestDispatcher("/WEB-INF/views/admin/memberList.jsp")
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
