package common.listener;

import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

public class SessionCounterListener implements HttpSessionListener{
	private static int activeSessions;

	@Override
	public void sessionCreated(HttpSessionEvent se) {
		System.out.println("[세션객체 생성 : "+ ++activeSessions +"]");
	}

	@Override
	public void sessionDestroyed(HttpSessionEvent se) {
		if(activeSessions > 0)
			activeSessions--;
		
		System.out.println("[세션객체 해제 : "+ activeSessions +"]");
		
	}

}
