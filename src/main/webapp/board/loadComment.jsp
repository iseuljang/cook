<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="cook.*" %>
<%
String no = request.getParameter("no");
List<Comment> commentList = new ArrayList<>();

// 데이터베이스 연결 및 댓글 조회 로직
Connection conn = null;
PreparedStatement psmt = null;
ResultSet rs = null;

try {
    conn = DBConn.conn();
    String sql = "SELECT cno,c.bno,c.uno,c.content,c.state, "
    /* +" DATE_FORMAT(c.rdate, '%y년 %m월 %d일') AS rdate, " */
    +" DATE_FORMAT(c.rdate, '%Y.%m.%d %H:%i') AS rdate, "
    +" u.unick,u.pname FROM comment c "
    +" INNER JOIN user u "
	+" ON c.uno = u.uno WHERE c.bno = ? AND c.state = 'E' ORDER BY c.cno DESC";
    psmt = conn.prepareStatement(sql);
    psmt.setInt(1, Integer.parseInt(no));

    rs = psmt.executeQuery();

    while (rs.next()) {
        Comment c = new Comment(
       		rs.getString("cno"),
       		rs.getString("bno"),
       		rs.getString("uno"),
       		rs.getString("content"),
       		rs.getString("state"),
       		rs.getString("rdate"),
       		rs.getString("unick"),
       		rs.getString("pname")
    	);
    	commentList.add(c);
    }
} catch (Exception e) {
    e.printStackTrace();
} finally {
    DBConn.close(rs, psmt, conn);
}
%>

<!-- 댓글 출력 -->
<%
if (!commentList.isEmpty()) {
    for (Comment c : commentList) { 
    	String cno = c.getCno();
    	String uno = c.getUno();
    %>
    <tr id="comment<%= cno %>" style="font-size:14px;">
        <td  colspan="2">
        <div style="display: flex; align-items: center; gap: 10px;">
        	<div class="view_profil">
		    <% 
		    if(c.getPname() != null && !c.getPname().isEmpty()) { 
		    %>
		        <!-- 프로필 이미지가 있을 경우 -->
		        <img id="previewProfil" class="circular-img" 
		             style="border:none; width:50px; height:50px;" 
		             src="<%= request.getContextPath() %>/upload/<%= c.getPname() %>" alt="프로필 이미지" />
		    <% 
		    }else {
	    	%>
		        <!-- 기본 프로필 이미지 -->
		        <img id="previewProfil" class="circular-img" 
		             style="border:none; width:50px; height:50px;" 
		             src="https://img.icons8.com/?size=100&id=115346&format=png&color=000000" alt="기본 프로필 이미지">
		    <% 
		    } 
		    %>
            </div>
            <span style="font-size:18px;"><%= c.getUnick() %></span> <!-- 닉네임 -->
       </div>
       
			
			
			<div style="margin-top: 5px; margin-left: 70px;" id="content">
                <span><%= c.getContent() %></span>
            </div>
    	
	    	<!-- 작성일 및 수정/삭제 버튼 -->
	        <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 5px; margin-left: 70px; font-size: 12px; color: #999;">
	            <!-- 작성일 -->
	            <span><%= c.getRdate() %></span>
	            <%
	            if(session.getAttribute("loginUserNo") != null && session.getAttribute("loginUserNo").equals(uno)){
            	%>
	            <script>
	       		// menuB 클릭 시 menutableB 보이거나 숨김
	            $("#menuB<%= cno %>").click(function(event){
	            	let loginUno = '<%= session.getAttribute("loginUserNo") %>';
	            	console.log(loginUno);
	            	
	            	if(loginUno != 'null'){
		                $("#menutableB<%= cno %>").toggle(); // 토글로 보이기/숨기기
		                event.stopPropagation();   // 이벤트 전파 막기
	            	}
	            });

	            // 문서의 다른 곳 클릭하면 메뉴 숨김
	            $(document).click(function(){
	                $("#menutableB<%= cno %>").hide();
	            });

	            // 메뉴 내부 클릭 시 메뉴가 닫히지 않도록 방지
	            $("#menutableB<%= cno %>").click(function(event){
	                event.stopPropagation();   // 이벤트 전파 막기
	            });
	            </script>
	            <form>
	            <div style="display: flex; align-items: center; gap: 10px;"> 
		            <span id="menuB<%= cno %>" class="menuB" style="display: flex; align-items: center; gap: 10px;">
		            	<i class="fas fa-solid fa-bars"></i>
				        <span id="menutableB<%= cno %>"  class="menutableB">
			                <div class="menu-container">
		                        <i class="fas fa-solid fa-pen-nib"></i>
				                <span id="cModify" 
		                        onclick="commentUpdate(<%= cno %>, '<%= no %>')">수정</span>
		                    </div>
			                <div class="menu-container">
		                        <i class="fas fa-solid fa-eraser"></i>
				                <span id="cDelete"
	                      		 onclick="commentDel(<%= cno %>)">삭제</span>
		                    </div>
				        </span>
			  	  	</span>
		  	    </div>
		  	    </form>
            	<%
	            }
	            %>
	        </div>
    	</td>
    </tr>
    <form name="commentDelForm" action="commentDel.jsp" method="post">
		<input type="hidden" name="cno" value="<%= cno %>">
		<input type="hidden" name="no" value="<%= no %>">
		<input type="hidden" name="nowPage">
		<input type="hidden" name="searchType">
		<input type="hidden" name="searchValue">
    </form>
    <% 
    } 
}
%>