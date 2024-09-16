<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="cook.*" %>
<%
String no = request.getParameter("no");
List<Comment> commentList = new ArrayList<>();

// 데이터베이스 연결 및 댓글 조회 로직
Connection conn = null;
PreparedStatement psmt = null;
ResultSet rs = null;

try {
    conn = DBConn.conn();
    String sql = "SELECT c.*, u.unick FROM comment c INNER JOIN user u ON c.uno = u.uno WHERE c.bno = ? AND c.state = 'E' ORDER BY c.cno DESC";
    psmt = conn.prepareStatement(sql);
    psmt.setInt(1, Integer.parseInt(no));

    rs = psmt.executeQuery();

    while (rs.next()) {
        Comment c = new Comment(
       		rs.getString("cno"),
       		rs.getString("no"),
       		rs.getString("uno"),
       		rs.getString("content"),
       		rs.getString("state"),
       		rs.getString("rdate"),
       		rs.getString("unick")
        );
        commentList.add(c);
    }
} catch (Exception e) {
    e.printStackTrace();
} finally {
    DBConn.close(rs, psmt, conn);
}
%>

<!-- 댓글 출력 -->
<%
if (!commentList.isEmpty()) {
    for (Comment c : commentList) { 
    %>
    <tr id="comment<%= c.getCno() %>">
        <td><%= c.getUnick() %></td>
        <td><%= c.getContent() %></td>
        <td><%= c.getRdate() %></td>
        <td>
            <button onclick="commentUpdate(<%= c.getCno() %>, '<%= no %>')">수정</button>
            <button onclick="commentDel(<%= c.getCno() %>)">삭제</button>
        </td>
    </tr>
    <% 
    } 
}
%>