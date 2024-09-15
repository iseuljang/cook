<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="java.sql.*" %>
<%@ page import="cook.*" %>
<%
if(request.getMethod().equals("GET")){
	response.sendRedirect("join.jsp");
}
request.setCharacterEncoding("UTF-8");
String uploadPath = "D:\\code\\awsJava\\workspace\\cook\\src\\main\\webapp\\upload";
int size = 10 * 1024 * 1024;
MultipartRequest multi;
try
{
	multi = 
		new MultipartRequest(request,uploadPath,size,
			"UTF-8",new DefaultFileRenamePolicy());
}catch(Exception e)
{
	response.sendRedirect("join.jsp");
	return;
}

//업로드된 파일명을 얻는다
Enumeration files = multi.getFileNames();
String fileid = (String)files.nextElement();
String filename = (String)multi.getFilesystemName("fname");

String phyname = null;
if(filename != null)
{
	phyname = UUID.randomUUID().toString();
	String srcName    = uploadPath + "/" + filename;
	String targetName = uploadPath + "/" + phyname;
	File srcFile    = new File(srcName);
	File targetFile = new File(targetName);
	srcFile.renameTo(targetFile);
}else{
	filename = "";
	phyname = "";
}


String uid = multi.getParameter("uid");
String upw = multi.getParameter("upw");
String unick = multi.getParameter("unick");
String uemail = multi.getParameter("uemail");

Connection conn = null;			
PreparedStatement psmt = null;

try{
	conn = DBConn.conn();
	
	String sql = "insert into user (uid,upw,unick,uemail,pname,fname) "
			+ " values (?,md5(?),?,?,?,?) ";
	
	psmt = conn.prepareStatement(sql);
	psmt.setString(1, uid);
	psmt.setString(2, upw);
	psmt.setString(3, unick);
	psmt.setString(4, uemail);
	psmt.setString(5, phyname);
	psmt.setString(6, filename);
	
	int result = psmt.executeUpdate();
	
	if(result > 0){
		//등록완료
		%>
		<script>
			alert("등록이 완료되었습니다");
			location.href = "login.jsp";
		</script>
		<%
	}
}catch(Exception e){
	e.printStackTrace();
	out.print(e.getMessage());
}finally{
	DBConn.close(psmt, conn);
}
%>
<script>
alert("등록을 실패했습니다");
location.href = "join.jsp";
</script>