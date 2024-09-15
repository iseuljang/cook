<%@ page language="java" contentType="application/octet-stream; charset=UTF-8"
    pageEncoding="UTF-8" isErrorPage="false" %>
<%@ page import="java.sql.*"%>    
<%@ page import="java.io.*" %> 
<%@ page import="cook.*" %>
<%
try {
    // JDBC 연결 설정
    Connection conn = DBConn.conn(); 

    // 게시물 번호 가져오기
    String bno = request.getParameter("no");
    String sql = "SELECT pname, fname FROM attach WHERE bno = " + bno;
    PreparedStatement psmt = conn.prepareStatement(sql);
    ResultSet rs = psmt.executeQuery(sql);

    String pname = "";
    String fname = "";
    if (rs.next()) {
        pname = rs.getString("pname");
        fname = rs.getString("fname");
    }

    // 작업 할당 해제 및 DB 연결 종료
    DBConn.close(rs, psmt, conn);

    // 첨부파일 경로 및 파일 설정
    String uploadPath = "D:\\code\\awsJava\\workspace\\cook\\src\\main\\webapp\\upload";
    String fullname = uploadPath + "\\" + pname;
    File file = new File(fullname);

    // 파일이 존재하는지 확인
    if (file.exists()) {
        response.setContentType("application/octet-stream");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + fname + "\"");
        FileInputStream fileIn = new FileInputStream(file);
        ServletOutputStream ostream = response.getOutputStream();

        byte[] outputByte = new byte[4096];
        int bytesRead;

        // 파일을 스트림으로 복사
        while ((bytesRead = fileIn.read(outputByte)) != -1) {
            ostream.write(outputByte, 0, bytesRead);
        }

        fileIn.close();
        ostream.flush();
        ostream.close();
    } else {
        // 파일이 없을 경우 오류 처리
        response.setContentType("text/html; charset=UTF-8");
        response.getWriter().print("<script>alert('파일을 찾을 수 없습니다.'); history.back();</script>");
    }

} catch (Exception e) {
    e.printStackTrace();
    response.setContentType("text/html; charset=UTF-8");
    response.getWriter().print("<script>alert('파일 다운로드 중 오류가 발생했습니다.'); history.back();</script>");
}
%>