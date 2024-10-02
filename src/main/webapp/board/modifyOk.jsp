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
String method = request.getMethod();
if(method.equals("GET") || session.getAttribute("loginUserNo") == null){
	response.sendRedirect("index.jsp");
	return;
}

Connection conn = null;
PreparedStatement psmt = null;
ResultSet rs = null;

//String uploadPath = "C:\\Users\\DEV\\Desktop\\JangAWS\\01.java\\workspace\\cook\\src\\main\\webapp\\upload";

String uploadPath = request.getServletContext().getRealPath("/upload");
System.out.println("서버의 업로드 폴더 경로 : " + uploadPath);

int size = 10 * 1024 * 1024; // 10MB

String title = "";
String content = "";
String star = "";
String topYn = "";
String fname = "";
String pname = "";
String no = "";

MultipartRequest multi;
try {
    multi = new MultipartRequest(request, uploadPath, size, "UTF-8", new DefaultFileRenamePolicy());
	
    // 업로드된 파일명 가져오기
    Enumeration files = multi.getFileNames();
    String filename = null;			// 원본파일
    String phyname = null;			// 바뀐이름

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
    
    no = multi.getParameter("no");
    String type = multi.getParameter("type");
    title = multi.getParameter("title");
    content = multi.getParameter("editorTxt");
    star = multi.getParameter("starview");
    topYn = multi.getParameter("top_yn");
    fname = filename;
    pname = phyname;
    
    conn = DBConn.conn();
    
    // 기존 게시글 수정 쿼리
    String sqlUpdate = "";
    if (type.equals("N")) {
        sqlUpdate = "update notice_board set title=?, top_yn=?, content=? where nno=?";
        psmt = conn.prepareStatement(sqlUpdate);
        psmt.setString(1, title);
        psmt.setString(2, topYn);
        psmt.setString(3, content);
        psmt.setInt(4, Integer.parseInt(no));
    } else if (type.equals("F")) {
        sqlUpdate = "update board set title=?, content=? where bno=?";
        psmt = conn.prepareStatement(sqlUpdate);
        psmt.setString(1, title);
        psmt.setString(2, content);
        psmt.setInt(3, Integer.parseInt(no));
    } else {
        sqlUpdate = "update board set title=?, star=?, content=? where bno=?";
        psmt = conn.prepareStatement(sqlUpdate);
        psmt.setString(1, title);
        psmt.setString(2, star);
        psmt.setString(3, content);
        psmt.setInt(4, Integer.parseInt(no));
    }
    
    int updateResult = psmt.executeUpdate();
    System.out.println("게시글 수정 결과: " + updateResult);
    
    // 파일 삭제가 체크되었을 때 처리 로직
    if (multi.getParameter("deleteFile") != null && multi.getParameter("deleteFile").equals("Y")) {
        String sqlDeleteFile = "DELETE FROM attach WHERE bno=?";
        psmt = conn.prepareStatement(sqlDeleteFile);
        psmt.setInt(1, Integer.parseInt(no));
        psmt.executeUpdate();
        
        // 실제 파일 삭제
        String deleteFilePath = uploadPath + "/" + pname;
        File deleteFile = new File(deleteFilePath);
        if (deleteFile.exists()) {
            deleteFile.delete();
            System.out.println("기존 파일 삭제 성공: " + pname);
        } else {
            System.out.println("삭제할 파일이 없습니다: " + pname);
        }
    } else if (fname != null) {  // 새 파일 업로드 시
        String sqlFileSelect = "select * from attach where bno=?";
        psmt = conn.prepareStatement(sqlFileSelect);
        psmt.setInt(1, Integer.parseInt(no));
        rs = psmt.executeQuery();
        
        if (rs.next()) {
            String sqlFileUpdate = "UPDATE attach SET fname = ?, pname = ? WHERE bno = ?";
            psmt = conn.prepareStatement(sqlFileUpdate);
            psmt.setString(1, fname);
            psmt.setString(2, pname);
            psmt.setInt(3, Integer.parseInt(no));
            psmt.executeUpdate();
        } else {
            String sqlFileInsert = "INSERT INTO attach (fname, pname, bno) VALUES (?, ?, ?)";
            psmt = conn.prepareStatement(sqlFileInsert);
            psmt.setString(1, fname);
            psmt.setString(2, pname);
            psmt.setInt(3, Integer.parseInt(no));
            psmt.executeUpdate();
        }
    }
    
    if (updateResult > 0) {
        response.sendRedirect(multi.getParameter("path"));
    } else {
        out.println("<script>alert('게시글 수정에 실패했습니다.'); history.back();</script>");
    }

} catch (Exception e) {
    e.printStackTrace();
    out.println("<script>alert('오류가 발생했습니다: " + e.getMessage() + "'); history.back();</script>");
} finally {
    DBConn.close(psmt, conn);
}
%>