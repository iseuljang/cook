<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*, javax.servlet.http.*, javax.servlet.annotation.MultipartConfig" %>
<%@ page import="org.apache.commons.io.FilenameUtils" %>

<%@ MultipartConfig(
    fileSizeThreshold = 1024 * 1024,  // 1MB
    maxFileSize = 1024 * 1024 * 5,    // 5MB
    maxRequestSize = 1024 * 1024 * 10 // 10MB
) %>

<%
    String uploadPath = application.getRealPath("/") + "uploads";  // 이미지 저장 경로
    File uploadDir = new File(uploadPath);
    if (!uploadDir.exists()) {
        uploadDir.mkdir();  // 폴더가 없으면 생성
    }

    Part filePart = request.getPart("file");
    String fileName = FilenameUtils.getName(filePart.getSubmittedFileName());
    String filePath = uploadPath + File.separator + fileName;

    try {
        filePart.write(filePath);  // 파일 서버에 저장
        String imageUrl = request.getContextPath() + "/uploads/" + fileName;  // 업로드된 이미지 경로
        response.getWriter().write("{\"location\": \"" + imageUrl + "\"}");
    } catch (Exception e) {
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        response.getWriter().write("{\"error\": \"File upload failed.\"}");
    }
%>
