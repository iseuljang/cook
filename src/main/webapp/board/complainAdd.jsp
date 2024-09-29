<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="cook.*" %>
<%
String uno = (String)session.getAttribute("loginUserNo");
String bno = request.getParameter("no"); 
String state = request.getParameter("state"); 

Connection conn = null;
PreparedStatement psmt = null;
ResultSet rs = null;
String sql = "";


try {
    conn = DBConn.conn();

    sql = "select cpno from complaint where uno = ? and bno = ?";
    psmt = conn.prepareStatement(sql);
    psmt.setString(1, uno);
    psmt.setString(2, bno);

    rs = psmt.executeQuery();

    if (rs.next()) {
        // 이미 존재하면 delete
        sql = "delete from complaint where uno = ? and bno = ?";
        psmt = conn.prepareStatement(sql);
        psmt.setString(1, uno);
        psmt.setString(2, bno);
    } else {
        // 신고가 없으면 insert
        sql = "insert into complaint (uno, bno, state) values (?, ?, ?)";
        psmt = conn.prepareStatement(sql);
        psmt.setString(1, uno);
        psmt.setString(2, bno);
        psmt.setString(3, state);
    }

    psmt.executeUpdate();

} catch (Exception e) {
    e.printStackTrace();
    out.print("오류 발생: " + e.getMessage());
} finally {
    DBConn.close(rs, psmt, conn);
}
%>