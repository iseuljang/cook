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

Connection conn = null;			
PreparedStatement psmt = null;
ResultSet rs = null;	


try{
	conn = DBConn.conn();
	
	String sql = "select uid from user "
			+ " where uid=? ";
	
	psmt = conn.prepareStatement(sql);
	psmt.setString(1, uid);
	
	rs = psmt.executeQuery();
	
	if(rs.next()){
		out.println("01");
	}else{
		out.println("00");
	}
}catch(Exception e){
	e.printStackTrace();
	out.print(e.getMessage());
}finally{
	DBConn.close(rs,psmt, conn);
}
%>