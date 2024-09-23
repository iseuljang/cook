<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="cook.*" %>
<%
String method = request.getMethod();
request.setCharacterEncoding("UTF-8");
String uno = "";
String no = request.getParameter("no");
if(no == null || no.equals("")){
    out.println("no 값이 유효하지 않습니다.");
    return;
}

String content = request.getParameter("comment");
String path = request.getParameter("path");
if(method.equals("GET") || session.getAttribute("loginUserNo") == null){
	%>
	<script>
		alert("잘못된 접근입니다.");
		location.href = path;
	</script>
	<%
}else{
	//method가 POST인 곳
	uno = (String)session.getAttribute("loginUserNo");
	Connection conn = null;			//DB 연결
	PreparedStatement psmt = null;	//SQL 등록 및 실행. 보안이 더 좋음!
	
	System.out.println("bno:" + no );
	
	try{
		conn = DBConn.conn();
		
		String sql = "insert into comment (uno,bno,content) "
				+ " values (?,?,?) ";
		
		psmt = conn.prepareStatement(sql);
		psmt.setString(1, uno);
		psmt.setString(2, no);
		psmt.setString(3, content.replace("'", "''").replace("<", "&lt;").replace(">", "&gt;").replace("\"","&quot;"));
		
		int result = psmt.executeUpdate();
		
		if(result > 0){
			//등록완료
			System.out.println("댓글등록완료:" + sql);
		}
	}catch(Exception e){
		e.printStackTrace();
		out.print(e.getMessage());
	}finally{
		DBConn.close(psmt, conn);
	}
}
%>