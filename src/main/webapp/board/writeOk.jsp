<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>    
<%@ page import="java.sql.*" %>
<%@ page import="cook.*" %>
<%
request.setCharacterEncoding("UTF-8");
//업로드가 가능한 최대 파일 크기를 지정한다.
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
	response.sendRedirect("write.jsp");
	return;
}

String title = multi.getParameter("title");
String content  = multi.getParameter("content");

//업로드된 파일명을 얻는다
// 업로드된 파일명을 얻는다
Enumeration files = multi.getFileNames();
String filename = null;
String phyname = null;

// 첨부파일이 있는 경우에만 처리
if (files.hasMoreElements()) {
    String fileid = (String) files.nextElement();
    filename = multi.getFilesystemName(fileid);

    if (filename != null) {
        phyname = UUID.randomUUID().toString();
        String srcName = uploadPath + "/" + filename;
        String targetName = uploadPath + "/" + phyname;
        File srcFile = new File(srcName);
        File targetFile = new File(targetName);
        srcFile.renameTo(targetFile);
    }
}


String path = multi.getParameter("path");
String type  = multi.getParameter("type");
if (type == null || type.equals("")) {
    type = "R";
}

String uno = (String) session.getAttribute("loginUserNo");
String star = multi.getParameter("star");
if (star == null) {
    star = "0";
}


Connection conn = null;
PreparedStatement psmt = null;

PreparedStatement psmtFile = null;
ResultSet rs = null;

try {
    conn = DBConn.conn(); // DBConn이 올바르게 구현되어 있는지 확인

    String sql = "";
    if (type.equals("N")) {
        sql = "INSERT INTO notice_board (title, content, top_yn, uno) VALUES (?, ?, ?, ?)";
        psmt = conn.prepareStatement(sql);
        String top_yn = multi.getParameter("top_yn");
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
    	String sqlBno = "select last_insert_id() as bno";
    	psmtFile = conn.prepareStatement(sqlBno);
    	rs = psmtFile.executeQuery();
    	rs.next();
    	String bno = rs.getString("bno");

    	// 첨부파일을 등록한다
    	if(filename != null)
    	{
    		String sqlFile  = "insert into attach (bno, pname, fname) values "
    			+ "(?,?,?)";
    		psmtFile = conn.prepareStatement(sqlFile);
    		psmtFile.setString(1, bno);
    		psmtFile.setString(2, phyname); // 저장된 파일명 (UUID)
    		psmtFile.setString(3, filename);// 실제 파일명
    		System.out.println(sqlFile);
    		psmtFile.executeUpdate();
    	}
    	%>
    	<script>
    		alert("게시글이 성공적으로 등록되었습니다.");
    		location.href = "<%= path%>";
    	</script>
    	<%
    } else {
        %>
    	<script>
    		alert("게시글 등록에 실패하였습니다.");
    		location.href = "<%= path%>";
    	</script>
    	<%
    }
} catch (Exception e) {
    e.printStackTrace();
    out.print(e.getMessage());
} finally {
    DBConn.close(psmt, null);
    DBConn.close(rs,psmtFile, conn);
}
%>