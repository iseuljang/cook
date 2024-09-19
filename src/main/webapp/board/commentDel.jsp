<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<<<<<<< HEAD
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
String nowPage = request.getParameter("nowPage");
String type = request.getParameter("type");
String searchType  = request.getParameter("searchType");
String searchValue  = request.getParameter("searchValue");
if(method.equals("GET") || session.getAttribute("loginUserNo") == null){
	%>
	<script>
		alert("잘못된 접근입니다.");
		location.href = "view.jsp?no=<%= no%>&nowPage=<%= nowPage %>&type=<%= type%>&searchType=<%= searchType %>&searchValue=<%= searchValue %>";
	</script>
	<%
}else{
	//method가 POST인 곳
	System.out.println("cno:" + cno );
	Connection conn = null;			//DB 연결
	PreparedStatement psmt = null;	//SQL 등록 및 실행. 보안이 더 좋음!
	
	try{
		conn = DBConn.conn();
		String sql = "update comment set state='D' where cno=?";
		
		psmt = conn.prepareStatement(sql);
		psmt.setString(1, cno);
		
		int result = psmt.executeUpdate();
		
		if(result > 0){
			//삭제완료
			System.out.println("댓글삭제완료:"+sql);
		}
	}catch(Exception e){
		e.printStackTrace();
		out.print(e.getMessage());
	}finally{
		DBConn.close(psmt, conn);
	}
}
%>
<script>
	alert("삭제 실패했습니다.");
	location.href = "view.jsp?no=<%= no%>&nowPage=<%= nowPage %>&type=<%= type%>&searchType=<%= searchType %>&searchValue=<%= searchValue %>";
</script>
=======
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

</body>
</html>
>>>>>>> 2b343ea79dfa498ebd10a21732d49a1bb284962f
