<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="cook.*" %>
<%
request.setCharacterEncoding("UTF-8");
String type = request.getParameter("type");
String path = request.getParameter("path");
if (type == null || type.trim().isEmpty()) {
    type = "F";
}

String title = request.getParameter("title");
String content = request.getParameter("content");
String uno = (String) session.getAttribute("loginUserNo");
String star = request.getParameter("star");
if (star == null) {
    star = "0";
}


Connection conn = null;
PreparedStatement psmt = null;

try {
    conn = DBConn.conn(); // DBConn이 올바르게 구현되어 있는지 확인

    String sql = "";
    if (type.equals("N")) {
        sql = "INSERT INTO notice_board (title, content, top_yn, uno) VALUES (?, ?, ?, ?)";
        psmt = conn.prepareStatement(sql);
        String top_yn = request.getParameter("top_yn");
        psmt.setString(1, title);
        psmt.setString(2, content);
        psmt.setString(3, top_yn);
        psmt.setString(4, uno);
    } else if (type.equals("F")) {
        sql = "INSERT INTO board (title, content, type, uno) VALUES (?, ?, ?, ?)";
        psmt = conn.prepareStatement(sql);
        psmt.setString(1, title);
        psmt.setString(2, content);
        psmt.setString(3, type);
        psmt.setString(4, uno);
    } else if (type.equals("R")) {
        sql = "INSERT INTO board (title, content, type, star, uno) VALUES (?, ?, ?, ?, ?)";
        psmt = conn.prepareStatement(sql);
        psmt.setString(1, title);
        psmt.setString(2, content);
        psmt.setString(3, type);
        psmt.setString(4, star);
        psmt.setString(5, uno);
    }

    int result = psmt.executeUpdate();
    if (result > 0) {
    	%>
    	<script>
    		alert("게시글이 성공적으로 등록되었습니다.");
    		location.href = "<%= path%><%= type%>";
    	</script>
    	<%
    } else {
        %>
    	<script>
    		alert("게시글 등록에 실패하였습니다.");
    		location.href = "<%= path%><%= type%>";
    	</script>
    	<%
    }
} catch (Exception e) {
    e.printStackTrace();
    out.print(e.getMessage());
} finally {
    DBConn.close(psmt, conn);
}
%>