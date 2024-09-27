<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="cook.*" %>
<%
String loginFileF;
String loginFileP;
String loginLevel;
String loginNo;

loginFileF = (String)session.getAttribute("loginUserProfilF");
loginFileP = (String)session.getAttribute("loginUserProfilP");
loginLevel = (String)session.getAttribute("loginUserLevel");
loginNo = (String)session.getAttribute("loginUserNo");

if(loginFileF == null || loginLevel == null ||
loginFileF.equals("") || loginLevel.equals("")){
	loginFileF = "";
	loginLevel = "";
	loginNo = "";
}

String LevelStr = "";
switch(loginLevel){
case "A" : LevelStr = "&#127800;"; break;
case "U" : LevelStr = "&#127808;"; break;
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Cook</title>
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/cook.css"> 
<script src="<%= request.getContextPath() %>/js/jquery-3.7.1.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<script type="text/javascript" src="<%= request.getContextPath() %>/static/js/HuskyEZCreator.js"></script>
<script>
    $(document).ready(function(){
    	// menuA 클릭 시 menutableA 보이거나 숨김
        $("#menuA").click(function(event){
            $("#menutableA").toggle(); // 토글로 보이기/숨기기
            event.stopPropagation();   // 이벤트 전파 막기
        });

        // 문서의 다른 곳 클릭하면 메뉴 숨김
        $(document).click(function(){
            $("#menutableA").hide();
        });

        // 메뉴 내부 클릭 시 메뉴가 닫히지 않도록 방지
        $("#menutableA").click(function(event){
            event.stopPropagation();   // 이벤트 전파 막기
        });
        
        $("nav a").click(function() {
            // 모든 <a> 태그에서 기존 클래스 제거
            $("nav a").removeClass("active");

            // 클릭한 <a> 태그에 클래스 추가
            $(this).addClass("active");
        });
        
    });
</script>
</head>
<body>
<!-- head 영역 -->
<div id="outDiv">
<header>
       <div class="title_inner">
           <div class="logo">
              <a href="<%= request.getContextPath() %>/index.jsp" style="cursor:pointer;">
	       <img src="<%= request.getContextPath() %>/image/logo.jpg" width="150px" height="150px" style="border-radius: 70%;">
	   	   </a>
           </div>
           <div class="login">
             <%
	    if(session.getAttribute("loginUserNo") != null){
	    %>
	    <span id="menuA">
	        <%
		    if(!loginFileF.equals("")) {
		        // 이미지 파일 확장자 체크
		        String[] imageExtensions = { "jpg", "jpeg", "png", "gif", "bmp" };
		        String fileExtension = loginFileF.substring(loginFileF.lastIndexOf(".") + 1).toLowerCase();
		        boolean isImage = false;
		
		        // 파일 확장자가 이미지인지 체크
		        for (String ext : imageExtensions) {
		            if (fileExtension.equals(ext)) {
		                isImage = true;
		                break;
		            }
		        }
		        // 이미지 파일일 경우 미리보기 제공
		        if(isImage){
	            %>
	            <img id="previewProfil" class="circular-img" style="border:none;" src="<%= request.getContextPath() %>/upload/<%= loginFileP %>" alt="첨부된 이미지" />
	            <%
		        }
		    }else{
		    	%>
				<!-- <img id="previewProfil" class="circular-img" src="https://img.icons8.com/?size=100&id=fX8vkLDeFBha&format=png&color=000000" /> -->
		    	<!-- <img id="previewProfil" class="circular-img" style="border:none;" src="https://img.icons8.com/?size=100&id=ulp2NT1Q9vQ8&format=png&color=FF7F50" /> -->
		    	<img id="previewProfil" class="circular-img" 
		    	style="border:none; width:120px; height:120px;" 
		    	src="https://img.icons8.com/?size=100&id=115346&format=png&color=000000">
		    	<%
		    }
		    %>
	        <span id="menutableA">
	            <a href="<%= request.getContextPath() %>/user/myinfo.jsp">
	                <div class="menu-container">
                           <!-- <i class="fas fa-id-badge"></i> -->
                        <i class="fas fa-address-card"></i>
		                <button id="infoBtn">내정보보기</button>
                    </div>
	            </a>
	            <a href="<%= request.getContextPath() %>/user/reco_list.jsp">
	                <div class="menu-container">
                        <!-- <i class="fas fa-solid fa-bookmark"></i> -->
                        <i class="fas fa-solid fa-heart"></i>
		                <button id="infoBtn">추천목록</button>
                    </div>
	            </a>
	            <%
	            if(session.getAttribute("loginUserLevel") != null && session.getAttribute("loginUserLevel").equals("A")){
            	%>
	            <a href="<%= request.getContextPath() %>/user/complain_list.jsp">
	                <div class="menu-container">
                        <!-- <i class="fas fa-cog"></i> 톱니바퀴 아이콘 -->
                        <img style='width:20px; cursor:pointer;' src='https://img.icons8.com/?size=100&id=8773&format=png&color=5D4037' />
		                <button id="logoutBtn">신고게시글</button>
                    </div>
	            </a>	
            	<%
	            }
	            %>
	            <a href="<%= request.getContextPath() %>/user/logout.jsp">
	                <div class="menu-container">
                           <i class="fas fa-sign-out-alt"></i>
		                <button id="logoutBtn">로그아웃</button>
                    </div>
	            </a>
	        </span>
	    </span>
	    <%    
	    } else {
	    %>
	    <a href="<%= request.getContextPath() %>/user/join.jsp">
	        <button id="jBtn">회원가입</button>&nbsp;
	    </a>
	    <a href="<%= request.getContextPath() %>/user/login.jsp">
	        <button id="lBtn">로그인</button>
	    </a>&nbsp;&nbsp;
	    <%
	    }
	    %>
            </div>
        </div>
	<%
	/* 
	현재 페이지 URL 가져오기
	request.getServletPath() 메서드를 사용하여 현재 요청된 서블릿의 경로를 가져옵니다. 
	이 경로를 사용하여 현재 페이지를 식별합니다.
	*/
	String currentPage = request.getServletPath();
	%>
    <nav>
       <ul>
           <li>
<!-- 
request.getContextPath() 
: 웹 애플리케이션의 컨텍스트 경로를 동적으로 가져옵니다. 
이 경로를 사용하여 상대 경로를 절대 경로로 변환합니다.

class="currentPage.contains("/board/board_list.jsp") 
&& request.getParameter("type") != null 
&& request.getParameter("type").equals("N") ? "active" : "">"
: 조건부로 active 클래스를 추가합니다.

currentPage.contains("/board/board_list.jsp")
: 현재 페이지 URL이 /board/board_list.jsp를 포함하는지 확인합니다.

조건이 참일 경우, active 클래스를 추가하여 링크를 활성화 상태로 만듭니다.
 -->
           	<a href="<%= request.getContextPath() %>/board/board_list.jsp?type=N" 
           	class="<%= currentPage.contains("/board/board_list.jsp") 
           	&& request.getParameter("type") != null 
           	&& request.getParameter("type").equals("N") ? "active" : "" %>">
			공지게시판
			</a>
			</li>
            <li>
			<a href="<%= request.getContextPath() %>/board/board_list.jsp?type=F"
			class="<%= currentPage.contains("/board/board_list.jsp") 
           	&& request.getParameter("type") != null 
           	&& request.getParameter("type").equals("F") ? "active" : "" %>">
			자유게시판
			</a>
			</li>
			<li>
			<a href="<%= request.getContextPath() %>/board/board_list.jsp?type=R"
			class="<%= currentPage.contains("/board/board_list.jsp") 
           	&& request.getParameter("type") != null 
           	&& request.getParameter("type").equals("R") ? "active" : "" %>">
				레시피게시판
			</a>
			</li>
        </ul>
    </nav>
</header>