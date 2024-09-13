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
String uname = request.getParameter("uname");
String unick = request.getParameter("unick");
String uemail = request.getParameter("uemail");

Connection conn = null;			
PreparedStatement psmt = null;

try{
	conn = DBConn.conn();
	
	String sql = "insert into user (uid,upw,uname,unick,uemail) "
			+ " values (?,md5(?),?,?,?) ";
	
	psmt = conn.prepareStatement(sql);
	psmt.setString(1, uid);
	psmt.setString(2, upw);
	psmt.setString(3, uname);
	psmt.setString(4, unick);
	psmt.setString(5, uemail);
	
	int result = psmt.executeUpdate();
	
	if(result > 0){
		//등록완료
		%>
		<script>
			alert("등록이 완료되었습니다");
			location.href = "login.jsp";
		</script>
		<%
	}
}catch(Exception e){
	e.printStackTrace();
	out.print(e.getMessage());
}finally{
	DBConn.close(psmt, conn);
}
%>
<script>
alert("등록을 실패했습니다");
location.href = "join.jsp";
</script>