package member.model.dao;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;

import member.model.vo.Member;

import static common.JDBCTemplate.*;

public class MemberDAO {

	private Properties prop = new Properties();
	
	public MemberDAO() {
		//build-path의 절대경로를 가져오기
		String fileName 
			= MemberDAO.class.getResource("/sql/member/member-query.properties").getPath();
		
		try {
			prop.load(new FileReader(fileName));
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	public Member selectOne(Connection conn, String memberId) {
		Member m = null;
		PreparedStatement pstmt = null;
		ResultSet rset = null;
		
		String query = prop.getProperty("selectOne");
		
		try{
			//미완성쿼리문을 가지고 객체생성.
			pstmt = conn.prepareStatement(query);
			//쿼리문미완성
			pstmt.setString(1, memberId);
			//쿼리문실행
			//완성된 쿼리를 가지고 있는 pstmt실행(파라미터 없음)
			rset = pstmt.executeQuery();
			
			if(rset.next()){
				m = new Member();
				//컬럼명은 대소문자 구분이 X
				m.setMemberId(rset.getString("member_id"));
				m.setPassword(rset.getString("password"));
				m.setMemberRole(rset.getString("member_role"));
				m.setEmail(rset.getString("email"));
				m.setEnrollDate(rset.getDate("enroll_date"));
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			close(rset);
			close(pstmt);
		}
		
//		System.out.println("m@DAO = "+m);
		return m;
	}

	public int insertMember(Connection conn, Member newMember) {
		int result = 0;
		//실제 실행될 쿼리 객체
		PreparedStatement pstmt = null;
		//쿼리객체에 전달할 미완성 쿼리
		String sql = prop.getProperty("insertMember");
		
		try {
			//1. Statement객체 생성(미완성 쿼리 값 대입)
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, newMember.getMemberId());
			pstmt.setString(2, newMember.getPassword());
			pstmt.setString(3, newMember.getMemberRole());
			pstmt.setString(4, newMember.getEmail());
			
			//2. 실행 : executeUpdate
			result = pstmt.executeUpdate();
			
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			//3. 자원반납
			close(pstmt);
		}
		
//		System.out.println("result@dao="+result);
		return result;
	}

	public int updateMember(Connection conn, Member updateMember) {
		int result = 0;
		PreparedStatement pstmt = null;
		String sql = prop.getProperty("updateMember");
		
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, updateMember.getEmail());
			pstmt.setString(2, updateMember.getMemberId());
			
			result = pstmt.executeUpdate();
			
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close(pstmt);
		}
		
//		System.out.println("result@dao="+result);
		return result;
	}

}
