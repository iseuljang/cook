<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="cook.*" %>
<%
if(request.getMethod().equals("GET")){
	response.sendRedirect("myinfo.jsp");
}
request.setCharacterEncoding("UTF-8");
String unick = request.getParameter("unick");

Connection conn = null;			
PreparedStatement psmt = null;
ResultSet rs = null;	


try{
	conn = DBConn.conn();
	
	String sql = "select unick from user "
			+ " where unick=? ";
	
	psmt = conn.prepareStatement(sql);
	psmt.setString(1, unick);
	
	rs = psmt.executeQuery();
	
	if(rs.next()){
		out.println("01");
	}else{
		out.println("02");
	}
}catch(Exception e){
	out.println("00");
	e.printStackTrace();
	out.print(e.getMessage());
}finally{
	DBConn.close(rs,psmt, conn);
}
%>