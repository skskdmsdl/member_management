package common;

import java.io.FileReader;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;

public class JDBCTemplate {

	public static Connection getConnection() {
		Connection conn = null;
		Properties prop = new Properties();
		String fileName = "/datasource.properties";
		
		//파일을 읽어오기 위한 절대경로
		fileName = JDBCTemplate.class.getResource(fileName).getPath();
		try {
			prop.load(new FileReader(fileName));
			
			String driver = prop.getProperty("driver");
			String url = prop.getProperty("url");
			String user = prop.getProperty("user");
			String password = prop.getProperty("password");
			
//			System.out.println(driver);
//			System.out.println(url);
//			System.out.println(user);
//			System.out.println(password);
			
			//드라이버 클래스 등록
			Class.forName(driver);
			
			//Connection객체 생성
			conn = DriverManager.getConnection(url, user, password); 
			conn.setAutoCommit(false); 
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return conn;
	}
	
	public static void commit(Connection conn){
		try {
			
			if(conn != null && !conn.isClosed())
				conn.commit();
			
 		} catch(SQLException e) {
 			e.printStackTrace();
 		}
	}
	
	public static void rollback(Connection conn){
		try {
			
			if(conn != null && !conn.isClosed())
				conn.rollback();
			
 		} catch(SQLException e) {
 			e.printStackTrace();
 		}
	}
	
	
	public static void close(Connection conn) {
		
		try {		
			if(conn != null && !conn.isClosed())
				conn.close();
		} catch(SQLException e) {
			e.printStackTrace();
		}
		
	}
	
	public static void close(PreparedStatement pstmt) {
		
		try {		
			if(pstmt != null && !pstmt.isClosed())
				pstmt.close();
		} catch(SQLException e) {
			e.printStackTrace();
		}
		
	}
	
	public static void close(ResultSet rset) {
		
		try {		
			if(rset != null && !rset.isClosed())
				rset.close();
		} catch(SQLException e) {
			e.printStackTrace();
		}
		
	}

}
