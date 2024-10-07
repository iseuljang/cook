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
/* String uploadPath = "D:\\code\\awsJava\\workspace\\cook\\src\\main\\webapp\\upload"; */
//String uploadPath = "C:\\Users\\DEV\\Desktop\\JangAWS\\01.java\\workspace\\cook\\src\\main\\webapp\\upload";

String uploadPath = request.getServletContext().getRealPath("/upload");
System.out.println("서버의 업로드 폴더 경로 : " + uploadPath);

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
String filename = null;			//원본파일
String phyname = null;			//바뀐이름

if (files.hasMoreElements()) {
    String fileid = (String) files.nextElement();
    filename = multi.getFilesystemName(fileid);

	if (filename != null) {
        System.out.println("업로드된 파일 이름: " + filename);
        phyname = UUID.randomUUID().toString(); // UUID 생성
        String srcName = uploadPath + "/" + filename;
        String targetName = uploadPath + "/" + phyname;
        
        File srcFile = new File(srcName);
        File targetFile = new File(targetName);
        
        boolean renamed = srcFile.renameTo(targetFile);
        if (!renamed) {
            System.out.println("파일 이름 변경 실패");
        } else {
            System.out.println("파일 이름 변경 성공: " + phyname);
        }
    }
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
	if(phyname == null) phyname = "";
	psmt.setString(5, phyname);
	if(filename == null) filename = "";
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