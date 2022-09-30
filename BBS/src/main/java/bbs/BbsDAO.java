package bbs;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class BbsDAO {
	
	private Connection conn;
	//여러개의 함수가 사용되기 때문에 각각의 함수가 데이터베이스 접근할 때 충돌이 생기지 않게 하기 위해 PreparedStatement는 삭제
	//private PreparedStatement pstmt;
	private ResultSet rs;
	
	public BbsDAO() {
		try {
			String dbURL = "jdbc:mysql://localhost:3306/BBS?serverTimezone=UTC";
			String dbID = "root";
			String dbPassword = "1234";
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection(dbURL,dbID,dbPassword);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	//현재 시간을 가져오는 함수/ 게시판에 글을 작성할 때 현재 시간을 넣어주는 역할
	public String getDate() {
		//현재 시간을 가져오는 mysql의 문장
		String SQL = "SELECT NOW()";
		try {
			//현재 연결되는 conn 객체를 이용하여 SQL문장을 실행 준비단계(prepareStatement)로 만들어 줌
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			//실제 실행된 결과 가져오기
			rs = pstmt.executeQuery();
			//만약 결과(rs)가 있다면
			if (rs.next()) {
				//현재 날짜를 그대로 반환
				return rs.getString(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return ""; //데이터베이스 오류
	}
	
	public int getNext() {
		//게시글 번호는 1부터 하나씩 증가되기 때문에 마지막에 쓰인 글을 가져와서 그 번호에 1을 더한 값이 그 다음글의 번호가 됨
		String SQL = "SELECT bbsID FROM BBS ORDER BY bbsID DESC";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return rs.getInt(1) + 1;
			}
			//만약 현재 쓰여있는 게시글이 없는 경우는 결과가 나오지 않기 때문에 첫번째 게시물인 경우는 return 1을 해줌으로서 위치를 알려줌
			return 1;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; //데이터베이스 오류 (게시글 번호로 적절하지 않은 -1을 알려줌으로서 오류 확인)
	}
	
	//실제 글 작성하는 함수
	public int write(String bbsTitle, String userID, String bbsContent) {
		String SQL = "INSERT INTO BBS (bbsID, bbsTitle, userID, bbsDate, bbsContent, bbsAvailable) "
					+ "VALUES (?, ?, ?, ?, ?, ?)";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext());
			pstmt.setString(2, bbsTitle);
			pstmt.setString(3, userID);
			pstmt.setString(4, getDate());
			pstmt.setString(5, bbsContent);
			pstmt.setInt(6, 1); //삭제여부
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; //데이터베이스 오류
	}
	
}
