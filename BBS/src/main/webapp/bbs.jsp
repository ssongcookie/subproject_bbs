<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="bbs.Bbs" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<!-- content 크기 최적화 -->
<meta name="viewport" content="width=divice-width", initial-scale="1">
<!-- 참조(css) -->
<link rel="stylesheet" href="css/bootstrap.css">

<title>JSP 게시판 웹 사이트</title>
</head>
<body>
	<!-- 로그인 된 사람들은 로그인 정보를 담을 수 있도록 -->
	<%
		
		String userID = null;
		if(session.getAttribute("userID") != null){
			/* 로그인 한 사람일 경우 userID 변수에 해당 userID를 담아줌 */
			userID = (String) session.getAttribute("userID");
		}
		//기본페이지
		int pageNumber = 1;
		//만약 파라미터로 pageNumber가 넘어왔다면 
		if(request.getParameter("pageNumber") != null){
			pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
		}
	%>
	<nav class="navbar navbar-default">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed"
				data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
				aria-expanded="false">
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>
			<a class="navbar-brand" href="main.jsp">JSP 게시판 웹 사이트</a>
		</div>
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li><a href="main.jsp">메인</a>
				<li class="active"><a href="bbs.jsp">게시판</a>
			</ul>
			
			<!-- 로그인 하지 않은 경우 표출 화면 -->
			<%
				if(userID == null){
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<!-- #:현재 가리키는 링크 없음 -->
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">접속하기<span class="caret"></span> <!-- span태그에 아이콘 -->
					</a>
					<ul class="dropdown-menu">
						<li><a href="login.jsp">로그인</a>
						<li><a href="join.jsp">회원가입</a>
					</ul>
				</li>
			</ul>			
			
			<!-- 로그인 한 경우 표출 화면 -->
			<%
				} else {
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<!-- #:현재 가리키는 링크 없음 -->
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">회원관리<span class="caret"></span> <!-- span태그에 아이콘 -->
					</a>
					<ul class="dropdown-menu">
						<li><a href="logoutAction.jsp">로그아웃</a>
					</ul>
				</li>
			</ul>			
			<%
				}
			%>		
		</div>
	</nav>	
	<!-- 게시판 화면 -->
	<div class="container">
		<div class="row">
			<!-- "table table-striped" : 게시판의 홀수와 짝수 색상 변경 -->
			<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd" >
				<thead>
					<tr>
						<th style="background-color: #eeeeee; text-align: center;">번호</th>
						<th style="background-color: #eeeeee; text-align: center;">제목</th>
						<th style="background-color: #eeeeee; text-align: center;">작성자</th>
						<th style="background-color: #eeeeee; text-align: center;">작성일</th>
					</tr>
				</thead>
				<tbody>
				<!-- 게시글 목록 출력 -->
				<%
					BbsDAO bbsDAO = new BbsDAO();
					ArrayList<Bbs> list = bbsDAO.getList(pageNumber);
					for(int i = 0; i < list.size(); i++){
				%>		
					<tr>
						<td><%= list.get(i).getBbsID() %></td>
						<td><a href="view.jsp?bbsID=<%= list.get(i).getBbsID() %>"><%= list.get(i).getBbsTitle() %></a></td>
						<td><%= list.get(i).getUserID() %></td>
						<td><%= list.get(i).getBbsDate().substring(0, 11) + list.get(i).getBbsDate().substring(11, 13) + "시" + list.get(i).getBbsDate().substring(14, 16) + "분" %></td>
					</tr>
				<%
					}
				%>
				
				</tbody>
			</table>
			<!-- btn-primary pull-right : 버튼 오른쪽 고정 -->
			<a href="write.jsp" class="btn btn-primary pull-right">글쓰기</a>
		</div>
	</div>	
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>