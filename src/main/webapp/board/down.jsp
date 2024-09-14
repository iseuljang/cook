<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection"%>    
<%@ page import="java.sql.DriverManager"%>    
<%@ page import="java.sql.ResultSet"%>    
<%@ page import="java.sql.Statement"%> 
<%@ page import="java.io.*" %> 
<%@ include file="../include/header.jsp" %>
<%
Class.forName("com.mysql.cj.jdbc.Driver");

String host = "jdbc:mysql://localhost:3306/cook";
host += "?useUnicode=true&characterEncoding=utf-8";
host += "&serverTimezone=UTC";
String user = "root";
String pass = "1234";
Connection conn = DriverManager.getConnection(host, user, pass);
Statement stmt = conn.createStatement();
//게시물 번호
String bno = request.getParameter("no");
String sql = "";
sql  = "select pname, fname ";
sql += "from attach ";
sql += "where bno = " + bno;
ResultSet rs = stmt.executeQuery(sql);
String pname = "";
String fname = "";
if(rs.next() == true)
{
	pname = rs.getString("pname");
	fname = rs.getString("fname");
}
//작업 할당을 해제한다.
stmt.close();
//DB 연결을 종료합니다
conn.close();

// 첨부파일을 브라우저로 전송한다
String uploadPath = "D:\\code\\awsJava\\workspace\\cook\\src\\main\\webapp\\upload";

response.setContentType("application/octet-stream");   
response.setHeader("Content-Disposition","attachment; filename=" + fname + "");   
String fullname = uploadPath + "\\" + pname;
File file = new File(fullname);
FileInputStream fileIn = new FileInputStream(file);
ServletOutputStream ostream = response.getOutputStream();

byte[] outputByte = new byte[4096];
//copy binary contect to output stream
while(fileIn.read(outputByte, 0, 4096) != -1)
{
	ostream.write(outputByte, 0, 4096);
}
fileIn.close();
ostream.flush();
ostream.close();
%> 