package member.model.service;

import member.model.dao.MemberDAO;
import member.model.vo.Member;
import static common.JDBCTemplate.*;

import java.sql.Connection;
import java.util.List;

public class MemberService {
	
	public static final String MEMBER_ROLE_USER = "U";
	public static final String MEMBER_ROLE_ADMIN = "A";
	
	private MemberDAO memberDAO = new MemberDAO();

	public Member selectOne(String memberId) {
		Connection conn = getConnection();
		Member m = memberDAO.selectOne(conn, memberId);
		close(conn);
//		System.out.println("m@service = "+m);
		return m;
		
	}

	public int insertMember(Member newMember) {
		Connection conn = getConnection();
		
		//dao단에 요청
		int result = memberDAO.insertMember(conn, newMember);
		
		//트랜잭션 처리
		if(result > 0)
			commit(conn);
		else
			rollback(conn);
		
		//자원반납
		close(conn);
		
		return result;
	}

	public int updateMember(Member updateMember) {
		Connection conn = getConnection();
		int result = memberDAO.updateMember(conn, updateMember);
		if(result > 0) commit(conn);
		else rollback(conn);
		close(conn);
		return result;
		
	}

	public int updatePassword(String memberId, String newPassword) {
		Connection conn = getConnection();
		int result = memberDAO.updatePassword(conn, memberId, newPassword);
		if(result > 0) commit(conn);
		else rollback(conn);
		close(conn);
		return result;
	}

	public List<Member> selectAll(int cPage, int numPerPage) {
		Connection conn = getConnection();
		List<Member> list = memberDAO.selectAll(conn, cPage, numPerPage);
		close(conn);
		return list;
	}

	public int selectTotalContents(String searchType, String searchKeyword) {
		Connection conn = getConnection();
		int totalContents = memberDAO.selectTotalContents(conn, searchType, searchKeyword);
		close(conn);
		return totalContents;
	}

	public List<Member> searchMember(String searchType, String searchKeyword, int cPage, int numPerPage) {
		Connection conn = getConnection();
		List<Member> list = memberDAO.searchMember(conn, searchType, searchKeyword, cPage, numPerPage);
		close(conn);
		return list;
	}

	public int selectTotalContents() {
		Connection conn = getConnection();
		int totalContents = memberDAO.selectTotalContents(conn);
		close(conn);
		return totalContents;
	}

	
	

}
