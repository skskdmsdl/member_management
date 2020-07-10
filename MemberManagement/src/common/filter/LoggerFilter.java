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

/**
 * web.xml에 직접 등록하지 않아도 됨(둘 다 써놓으면 오류남)
 */
//@WebFilter("/*") //순서가 상관없다면 webFilter쓰면됨(대부분)
public class LoggerFilter implements Filter {

    /**
     * 사용자 요청이 처리되는 순서를 찍어볼 용도의 필터
     */
    public LoggerFilter() {
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
		// /member/login
		HttpServletRequest httpReq = (HttpServletRequest)request;
		String uri = httpReq.getRequestURI();
		
		//1.전처리
		System.out.println("==============================");
		System.out.println(uri);
		System.out.println("------------------------------");
		
		chain.doFilter(request, response);
		
		//2.후처리
		System.out.println("______________________________");
		System.out.println();
				
	}

	/**
	 * @see Filter#init(FilterConfig)
	 */
	public void init(FilterConfig fConfig) throws ServletException {
		// TODO Auto-generated method stub
	}

}
