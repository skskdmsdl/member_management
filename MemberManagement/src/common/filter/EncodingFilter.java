package common.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

public class EncodingFilter implements Filter{
	
	private FilterConfig filterConfig;
	
	/**
	 * 필터객체 생성시 1회 실행
	 */
	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
		//매개인자로 받은 filterConfig객체를 필드에 담기
		this.filterConfig = filterConfig;
	}

	/**
	 * 실제로 처리될 코드 작성 부분
	 */
	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {
		//초기화 파라미터 사용하기
		String encodingType = filterConfig.getInitParameter("encodingType"); //web.xml에 작성한 값 가져오기
		
		//1. 전처리
		request.setCharacterEncoding(encodingType);
		System.out.println(encodingType+"@EncodingFilter 처리됨");
		
		//처리할 다음 필터가 있다면, 해당 필터의 doFilter 실행하고
		//없다면 , servlet 객체의 메소드를 호출
		//전처리 후처리 중 필요한 부분만 작성하면 됨
		chain.doFilter(request, response); //doFilter 호출
		
		//2. 후처리
		
	}

	/**
	 * 자원 반납시 사용되는데 사용할일 거의 없을듯
	 */
	@Override
	public void destroy() {
		// TODO Auto-generated method stub
		
	}


}
