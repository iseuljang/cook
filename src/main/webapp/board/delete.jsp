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


String type = request.getParameter("type");
String path = request.getParameter("path");

if(method.equals("GET") || session.getAttribute("loginUserNo") == null){
	%>
	<script>
		alert("잘못된 접근입니다.");
		location.href = "view.jsp?no=<%= no%><%= path%>";
	</script>
	<%
}else{
	//method가 POST인 곳
	System.out.println("no:" + no );
	Connection conn = null;			//DB 연결
	PreparedStatement psmt = null;	//SQL 등록 및 실행. 보안이 더 좋음!
	
	try{
		conn = DBConn.conn();
		String sql = "";
		if(type.equals("N")){
			sql = "update notice_board set state='D' where nno=?";
		}else{
			sql = "update board set state='D' where bno=?";
		}
		
		psmt = conn.prepareStatement(sql);
		psmt.setString(1, no);
		
		int result = psmt.executeUpdate();
		
		if(result > 0){
			//삭제완료
			System.out.println("게시글삭제완료:"+sql);
		}
	}catch(Exception e){
		e.printStackTrace();
		out.print(e.getMessage());
	}finally{
		DBConn.close(psmt, conn);
	}
}
%>