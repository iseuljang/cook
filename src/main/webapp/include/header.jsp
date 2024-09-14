<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="cook.*" %>
<%
String loginName;
String loginNick;
String loginLevel;
String loginNo;
String loginId;

loginName = (String)session.getAttribute("loginUserName");
loginNick = (String)session.getAttribute("loginUserNick");
loginLevel = (String)session.getAttribute("loginUserLevel");
loginNo = (String)session.getAttribute("loginUserNo");
loginId = (String)session.getAttribute("loginUserId");

if(loginName == null || loginLevel == null || loginNick == null ||
loginName.equals("") || loginLevel.equals("") || loginNick.equals("")){
	loginNick = "";
	loginName = "";
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
		        [<%= LevelStr %> <%= loginNick %>]&nbsp;&nbsp;&nbsp;
		        <span id="menutableA">
		            <a href="<%= request.getContextPath() %>/user/myinfo.jsp">
		                <button id="infoBtn">내정보보기</button>
		            </a>
		            <a href="<%= request.getContextPath() %>/user/logout.jsp">
		                <button id="logoutBtn">로그아웃</button>
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
	        <nav>
	            <ul>
	                <li>
	                	<a href="<%= request.getContextPath() %>/board/notice_board_list.jsp?type=N">
						공지게시판
						</a>
					</li>
	                <li>
						<a href="<%= request.getContextPath() %>/board/free_board_list.jsp?type=F">
							자유게시판
						</a>
					</li>
					<li>
						<a href="<%= request.getContextPath() %>/board/r_board_list.jsp?type=R">
							레시피게시판
						</a>
					</li>
	            </ul>
	        </nav>
	  </header>