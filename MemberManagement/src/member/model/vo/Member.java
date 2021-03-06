package member.model.vo;

import java.io.Serializable;
import java.sql.Date;

import javax.servlet.http.HttpSessionBindingEvent;
import javax.servlet.http.HttpSessionBindingListener;

public class Member implements Serializable, HttpSessionBindingListener{

	private String memberId;
	private String password;
	private String memberRole;
	private String email;
	private Date enrollDate;
	
	public Member() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	public Member(String memberId, String password, String memberRole, String email, Date enrollDate) {
		super();
		this.memberId = memberId;
		this.password = password;
		this.memberRole = memberRole;
		this.email = email;
		this.enrollDate = enrollDate;
	}
	
	public String getMemberId() {
		return memberId;
	}
	public void setMemberId(String memberId) {
		this.memberId = memberId;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getMemberRole() {
		return memberRole;
	}
	public void setMemberRole(String memberRole) {
		this.memberRole = memberRole;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public Date getEnrollDate() {
		return enrollDate;
	}
	public void setEnrollDate(Date enrollDate) {
		this.enrollDate = enrollDate;
	}
	
	@Override
	public String toString() {
		return "Member [memberId=" + memberId + ", password=" + password + ", memberRole=" + memberRole + ", email="
				+ email + ", enrollDate=" + enrollDate + "]";
	}

	@Override
	public void valueBound(HttpSessionBindingEvent e) {
		//로그인한경우
		System.out.println( "(" + memberId + ")님이 로그인했습니다!" );
	}
	
	@Override
	public void valueUnbound(HttpSessionBindingEvent e) {
		//로그아웃한경우
		System.out.println("(" + memberId + ")님이 로그아웃했습니다!" );
		
	}
	
	
}
