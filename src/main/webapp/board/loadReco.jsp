<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="cook.*" %>
<%
request.setCharacterEncoding("UTF-8");

String bno = request.getParameter("no");
String uno = "";

if(session.getAttribute("loginUserNo") != null){
	uno = (String)session.getAttribute("loginUserNo");
}
	

Connection conn = null;
PreparedStatement psmt = null;
ResultSet rs = null;

String rState = "D"; // 기본값은 추천하지 않은 상태

try {
    conn = DBConn.conn();

    // 사용자가 이 게시물을 추천했는지 확인
    String checkReco = "select state from recommend where uno = ? and bno = ?";
    psmt = conn.prepareStatement(checkReco);
    psmt.setInt(1, Integer.parseInt(uno));
    psmt.setInt(2, Integer.parseInt(bno));
    
    rs = psmt.executeQuery();
    
    if (rs.next()) {
        rState = rs.getString("state");
    }

} catch (Exception e) {
    e.printStackTrace();
} finally {
    DBConn.close(rs, psmt, conn);
}

// 추천 상태에 따라 적절한 이미지를 표시
if (rState.equals("E")) {
    // 추천한 상태일 때
    out.print("<img style='width:30px; cursor:pointer;' src='https://img.icons8.com/?size=100&id=12306&format=png&color=000000' onclick='recoAdd(" + bno + ", \"D\")' />");
} else {
    // 추천하지 않은 상태일 때
    out.print("<img style='width:30px; cursor:pointer;' src='https://img.icons8.com/?size=100&id=87&format=png&color=EEEEEE' onclick='recoAdd(" + bno + ", \"E\")' />");
}
%>