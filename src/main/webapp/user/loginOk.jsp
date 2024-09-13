<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="cook.*" %>
<%
if(request.getMethod().equals("GET")){
	response.sendRedirect("join.jsp");
}
request.setCharacterEncoding("UTF-8");
String uid = request.getParameter("uid");
String upw = request.getParameter("upw");

Connection conn = null;			
PreparedStatement psmt = null;
ResultSet rs = null;
try{
	conn = DBConn.conn();
	
	String sql = "select * from user "
			+ " where uid = ? and upw = md5(?) and state='E' ";
	
	psmt = conn.prepareStatement(sql);
	psmt.setString(1, uid);
	psmt.setString(2, upw);
	
	System.out.println(sql);
	rs = psmt.executeQuery();
	
	if(rs.next()){
		//존재하는 회원
		//세션에 로그인 정보를 기록
		session.setAttribute("loginUserId", rs.getString("uid"));
		session.setAttribute("loginUserName", rs.getString("uname"));
		session.setAttribute("loginUserNick", rs.getString("unick"));
		session.setAttribute("loginUserNo", rs.getString("uno"));
		session.setAttribute("loginUserLevel", rs.getString("uauthor"));
		//정상적으로 로그인되었으니 메인페이지로 보냄
		response.sendRedirect(request.getContextPath()+"/index.jsp");
	}else{
		%>
		<script>
		alert("로그인 정보가 올바르지 않습니다");
		document.location = "login.jsp";
		</script>
		<%
	}
	
}catch(Exception e){
	e.printStackTrace();
	out.print(e.getMessage());
}finally{
	DBConn.close(rs, psmt, conn);
}
%>