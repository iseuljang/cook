<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="cook.*" %>
<%
request.setCharacterEncoding("UTF-8");

String uploadPath = "C:\\Users\\DEV\\Desktop\\JangAWS\\01.java\\workspace\\cook\\src\\main\\webapp\\upload";
int size = 10 * 1024 * 1024; // 최대 10MB 파일 허용

MultipartRequest multi;
try {
    multi = new MultipartRequest(request, uploadPath, size, "UTF-8", new DefaultFileRenamePolicy());
} catch (Exception e) {
    e.printStackTrace();
    response.sendRedirect("myinfo.jsp");
    return;
}

// 업로드된 파일명 가져오기
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
if(session.getAttribute("loginUserNo") == null || session.getAttribute("loginUserNo").equals("")){
	response.sendRedirect(request.getContextPath()+"/index.jsp");
    return;
}
String uno = (String) session.getAttribute("loginUserNo");
String upw = multi.getParameter("upw");
if (upw == null || upw.trim().isEmpty()) {
    System.out.println("비밀번호가 전송되지 않았습니다.");
    out.println("<script>alert('비밀번호를 입력하세요.'); history.back();</script>");
    return;
}
String unick = multi.getParameter("unick");
String deleteFile = multi.getParameter("deleteFile"); // 체크박스 값
if(deleteFile == null || deleteFile.equals("")){
	deleteFile = "N";
}

Connection conn = null;
PreparedStatement psmt = null;
ResultSet rs = null;

PreparedStatement psmtUpdate = null;
PreparedStatement psmtFile = null;

try {
    conn = DBConn.conn(); // DB 연결

    // 비밀번호 체크
    String sql = "SELECT * FROM user WHERE uno = ? AND upw = md5(?) AND state = 'E'";
    psmt = conn.prepareStatement(sql);
    psmt.setString(1, uno);
    psmt.setString(2, upw);
    
    System.out.println("비밀번호 확인 SQL: " + sql);
    
    rs = psmt.executeQuery();

    if (rs.next()) {
        // 파일 삭제 처리
        if (deleteFile.equals("Y")) {
            String sqlDelete = "UPDATE user SET pname = '', fname = '' WHERE uno = ?";
            psmtFile = conn.prepareStatement(sqlDelete);
            psmtFile.setInt(1, Integer.parseInt(uno));
            int deleteCount = psmtFile.executeUpdate();
            System.out.println("프로필 삭제 SQL: " + sqlDelete);
            System.out.println("프로필 삭제 결과: " + deleteCount);
            session.setAttribute("loginUserProfilF", null);
            session.setAttribute("loginUserProfilP", null);
        } else if (filename != null) {
            // 파일 업로드 처리
            String sqlFile = "UPDATE user SET pname = ?, fname = ? WHERE uno = ?";
            psmtFile = conn.prepareStatement(sqlFile);
            psmtFile.setString(1, phyname); // 저장된 파일명 (UUID)
            psmtFile.setString(2, filename); // 실제 파일명
            psmtFile.setInt(3, Integer.parseInt(uno));

            int fileUpdateCount = psmtFile.executeUpdate();
            System.out.println("프로필 업데이트 SQL: " + sqlFile);
            System.out.println("프로필 업데이트 결과: " + fileUpdateCount);
            
            if (fileUpdateCount > 0) {
                session.setAttribute("loginUserProfilF", filename);
                session.setAttribute("loginUserProfilP", phyname);
            }
        }

        // 닉네임 업데이트 처리
        if (unick != null && !unick.trim().isEmpty()) {
            String sqlUpdate = "UPDATE user SET unick = ? WHERE uno = ?";
            psmtUpdate = conn.prepareStatement(sqlUpdate);
            psmtUpdate.setString(1, unick);
            psmtUpdate.setInt(2, Integer.parseInt(uno));

            int nickUpdateCount = psmtUpdate.executeUpdate();
            System.out.println("닉네임 업데이트 SQL: " + sqlUpdate);
            System.out.println("닉네임 업데이트 결과: " + nickUpdateCount);

            if (nickUpdateCount > 0) {
                session.setAttribute("loginUserNick", unick);
            }
        }

        out.println("<script>alert('회원정보가 성공적으로 업데이트되었습니다.'); location.href='myinfo.jsp';</script>");
    } else {
        out.println("<script>alert('비밀번호가 일치하지 않습니다.'); history.back();</script>");
    }
} catch (Exception e) {
    e.printStackTrace();
    out.println("<script>alert('회원정보 변경 중 오류가 발생했습니다.'); history.back();</script>");
} finally {
    DBConn.close(rs, psmt, null);
    DBConn.close(psmtFile, null);
    DBConn.close(psmtUpdate, conn);
}
%>