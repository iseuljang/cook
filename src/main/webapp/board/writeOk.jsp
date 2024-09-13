<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="cook.*" %>
<%
String method = request.getMethod();
if(method.equals("GET") || session.getAttribute("no") == null){
	%>
	<script>
		alert("잘못된 접근입니다.");
		location.href = "r_board_list.jsp?type=R";
	</script>
	<%
}else{
	request.setCharacterEncoding("UTF-8");
	int uno = (Integer)session.getAttribute("no");
	String star = request.getParameter("star");
	if(star == null || star.equals("")){
		star = "0";
	}
	String title = request.getParameter("title");  // 제목
	String content = request.getParameter("content");  // TinyMCE에서 작성된 HTML 내용
	
	Connection conn = null;
	PreparedStatement pstmt = null;
	
	try {
		conn = DBConn.conn();
	
	    // 게시글 저장 SQL
	    String sql = "insert into board (title, content, star, uno) values (?, ?, ?, ?)";
	    pstmt = conn.prepareStatement(sql);
	    pstmt.setString(1, title);
	    pstmt.setString(2, content);
	    pstmt.setString(3, star);
	    pstmt.setInt(4, uno);
	
	    int result = pstmt.executeUpdate();  // DB에 데이터 저장
	    if (result > 0) {
	        out.println("<script>alert('글이 성공적으로 저장되었습니다.'); location.href='r_board_list.jsp?type=R';</script>");
	    } else {
	        out.println("<script>alert('글 저장에 실패하였습니다.'); history.back();</script>");
	    }
	} catch (Exception e) {
	    e.printStackTrace();
	} finally {
	    if (pstmt != null) pstmt.close();
	    if (conn != null) conn.close();
	}
}
%>