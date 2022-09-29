package user;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

//DAO : 데이터베이스 접근 객체의 약자 실질적으로 데이터베이스에서 회원 정보를 불러오거나 넣고자 할 때 사용
public class UserDAO {

	//conn : 데이터베이스에 접근하게 해주는 하나의 객체
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs; //어떠한 정보를 담을 수 있는 하나의 객체
	
	//UserDAO 생성자를 통해 자동으로 데이터베이스 connection이 이뤄질 수 있도록 해 줌 
	public UserDAO() {
		//예외처리
		try {
			//mysql에 접속
			String dbURL = "jdbc:mysql://localhost:3306/BBS?serverTimezone=UTC";
			String dbID = "root";
			String dbPassword = "1234";
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection(dbURL,dbID,dbPassword);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	//실제로 로그인에 시도하는 함수 생성
	public int login(String userID, String userPassword) {
		//실제 SQL에 입력할 명령어
		String SQL = "SELECT userPassword FROM USER WHERE userID = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			
			//rs에 실행한 결과 삽입
			rs = pstmt.executeQuery();
			if (rs.next()) {
				if (rs.getString(1).equals(userPassword)) {
					return 1; //로그인 성공
				}
				else
					return 0; //비밀번호 불일치
			}
			return -1; //아이디가 없음
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -2; //데이터베이스 오류

	}
	
	
}
