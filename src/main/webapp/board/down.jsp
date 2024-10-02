<%@ page language="java" contentType="application/octet-stream; charset=UTF-8"
    pageEncoding="UTF-8" isErrorPage="false" %>
<%@ page import="java.sql.*"%>    
<%@ page import="java.io.*" %> 
<%@ page import="java.net.URLEncoder" %>
<%@ page import="cook.*" %>
<%
try {
	//JDBC 연결 설정
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
	
	
	System.out.println("원본 파일명 : " + fname);
	System.out.println("실제 파일명 : " + pname);
	/* DB에 첨부파일의 원본 파일명과, 실제 파일명을 저장해서 관리 */
	
	// 실제 파일의 절대 경로를 문자열로 완성한다
	//String uploadPath = "C:\\Users\\DEV\\Desktop\\JangAWS\\01.java\\workspace\\cook\\src\\main\\webapp\\upload";
	String uploadPath = request.getServletContext().getRealPath("/upload");
	System.out.println("서버의 업로드 폴더 경로 : " + uploadPath);
	pname = uploadPath + "\\" + pname;
	// 브라우저의 응답에 파일과 원본 파일명을 담아서 보냅니다
	response.setContentType("application/octet-stream");
	// 원본 파일명을 인코딩 처리
	fname = URLEncoder.encode(fname, "UTF-8");
	// 보낼 파일의 이름을 response에 담음
	response.setHeader("Content-Disposition", "attachment; filename=" + fname );
	
	System.out.println(pname);
	System.out.println(fname);
	
	// 파일 객체를 생성해서 스트림으로 전송한다
	// 실제 파일명으로 파일 객체 생성
	File file = new File(pname);
	// 파일 이름이 담긴 파일 객체로 실제 파일을 읽어옴
	FileInputStream fileIn = new FileInputStream(file);
	// 서블렛의 아웃풋 스트림 객체를 생성
	ServletOutputStream ostream = response.getOutputStream();
	// 파일을 4kb크기로 나눠서 전송
	byte[] outputByte = new byte[4096];
	// 데이터가 읽어와지면, 아웃풋 스트림으로 보냄
	while(fileIn.read(outputByte, 0, 4096 ) != -1){
		ostream.write(outputByte, 0, 4096);
	}
	fileIn.close();
	// 준비된 서블렛의 아웃풋 스트림을 전송한다
	ostream.flush();
	ostream.close();
}catch (Exception e) {
    e.printStackTrace();
    response.setContentType("text/html; charset=UTF-8");
    response.getWriter().print("<script>alert('파일 다운로드 중 오류가 발생했습니다.'); history.back();</script>");
}
%>