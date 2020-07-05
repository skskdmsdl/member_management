package common.filter;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import member.model.service.MemberService;
import member.model.vo.Member;

/**
 * 로그인한 사용자의 상세보기가 아닌 다른 사용자의 상세보기를 요청한 경우,
 * 진행될 수 없도록 처리
 * "잘못된 경로로 접근하셨습니다." 사용자 피드백 후, 
 * 로그인한 사용자의 상세보기 페이지로 이동할 것
 */
@WebFilter("/member/memberView")
public class MemberAuthFilter implements Filter {

    /**
     * Default constructor. 
     */
    public MemberAuthFilter() {
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see Filter#destroy()
	 */
	public void destroy() {
		// TODO Auto-generated method stub
	}

	/**
	 * @see Filter#doFilter(ServletRequest, ServletResponse, FilterChain)
	 */
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
		//로그인 여부는 session에 저장된 memberLoggedIn 객체가 있냐 없냐로 판별가능
		HttpServletRequest httpReq = (HttpServletRequest)request; 
		HttpSession session = httpReq.getSession();
		Member memberLoggedIn = ((Member)session.getAttribute("memberLoggedIn"));
		
		//현재로그인한 사용자와 요청사용자 비교
		String memberId = ((HttpServletRequest)request).getParameter("memberId");
		
//		System.out.println("memberId@MemberAuthFilter="+memberId);
		if((memberLoggedIn==null || memberId==null )
		||!(memberId.equals(memberLoggedIn.getMemberId())
			|| MemberService.MEMBER_ROLE_ADMIN.equals(memberLoggedIn.getMemberRole()))){
			request.setAttribute("msg", "잘못된 경로로 접근하셨습니다.");
			request.setAttribute("loc", "/member/memberView?memberId="+memberLoggedIn.getMemberId());
			request.getRequestDispatcher("/WEB-INF/views/common/msg.jsp")
				.forward(request, response);
			return;
		}
		chain.doFilter(request, response);
	}

	/**
	 * @see Filter#init(FilterConfig)
	 */
	public void init(FilterConfig fConfig) throws ServletException {
		// TODO Auto-generated method stub
	}

}
