<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="cook.*" %>
<%
request.setCharacterEncoding("UTF-8");
String method = request.getMethod();
String no = request.getParameter("no");
if(no == null || no.equals("")){
    out.println("no 값이 유효하지 않습니다.");
    return;
}
String cno = request.getParameter("cno");
String content = request.getParameter("comment");
String path = request.getParameter("path");
if(method.equals("GET") || session.getAttribute("loginUserNo") == null){
	%>
	<script>
		alert("잘못된 접근입니다.");
		location.href = "view.jsp?<%= path%>";
	</script>
	<%
}else{
	//method가 POST인 곳
	System.out.println("cno:" + cno );
	Connection conn = null;			//DB 연결
	PreparedStatement psmt = null;	//SQL 등록 및 실행. 보안이 더 좋음!
	
	try{
		conn = DBConn.conn();
		String sql = "update comment set content=? where cno=?";
		
		psmt = conn.prepareStatement(sql);
		psmt.setString(1, content);
		psmt.setString(2, cno);
		
		int result = psmt.executeUpdate();
		
		if(result > 0){
			System.out.println("댓글수정완료:"+sql);
			return;
		}
	}catch(Exception e){
		e.printStackTrace();
		out.print(e.getMessage());
	}finally{
		DBConn.close(psmt, conn);
	}
}
%>