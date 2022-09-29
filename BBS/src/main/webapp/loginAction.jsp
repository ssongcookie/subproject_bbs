<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!-- user패키지의 UserDAO클래스 가져오기 -->
<%@ page import="user.UserDAO" %>
<!-- javascript 문장을 사용하기 위해 작성 -->
<%@ page import="java.io.PrintWriter" %>
<!-- 넘어오는 모든 데이터를 UTF-8으로 받을 수 있도록 준비 -->
<%request.setCharacterEncoding("UTF-8");%>

<!-- javaBeans -->
<!-- scope="page" : 현재 페이지 안에서만 Beans가 사용될 수 있도록 해줌 -->
<jsp:useBean id="user" class="user.User" scope="page"/>

<!-- login.jsp 페이지에서 넘겨준 name="userID"/name="userPassword"를 받아서 userID/userPassword에 넣어줌 -->
<jsp:setProperty name="user" property="userID"/>
<jsp:setProperty name="user" property="userPassword"/>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
	<%
		/* 인스턴스 생성 */
		UserDAO userDAO = new UserDAO();
		/* 로그인 시도 */
		int result = userDAO.login(user.getUserID(), user.getUserPassword());
		if(result == 1){
			/* PrintWriter를 사용해 하나의 script 문장을 넣을 수 있도록 해 줌 */
			PrintWriter script = response.getWriter();
			/* script 문장을 유동적으로 실행 */
			script.println("<script>");
			/* 성공했을때 main.jsp 페이지로 이동 */
			script.println("location.href = 'main.jsp'");
			script.println("</script>");
		}
		else if(result == 0){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('비밀번호가 틀립니다.')");
			/* history.back() : 이전페이지로 돌려보냄 */
			script.println("history.back()");
			script.println("</script>");
		}
		else if(result == -1){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('존재하지 않는 아이디입니다.')");
			script.println("history.back()");
			script.println("</script>");
		}
		else if(result == -2){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('데이터베이스 오류가 발생했습니다.')");
			script.println("history.back()");
			script.println("</script>");
		}
	%>
</body>
</html>