<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp" %>
<%@ page import="cook.*" %>
<%@ page import="java.sql.*" %>
<%
String no = request.getParameter("no");
if(no == null || no.equals("")){
	%>
	<script>
		alert("잘못된 접근입니다");
		location.href = "<%= request.getContextPath() %>/list.jsp";
	</script>
	<%
}
String type = request.getParameter("type");
String nowPage = request.getParameter("nowPage");
String searchType  = request.getParameter("searchType");
String searchValue  = request.getParameter("searchValue");
if(searchValue == null || searchValue.equals("")){
	searchValue = "";
}

String path = "";
if(type == null || type.equals("")){
	type = "R";
}
switch(type) {
    case "N": 
    	path = "view.jsp?type=N&no="+ no +"&nowPage="+ nowPage +"&searchType="+ searchType +"&searchValue="+ searchValue; 
    	break;
    case "F": 
    	path = "view.jsp?type=F&no="+ no +"&nowPage="+ nowPage +"&searchType="+ searchType +"&searchValue="+ searchValue; 
    	break;
    case "R": 
    	path = "view.jsp?type=R&no="+ no +"&nowPage="+ nowPage +"&searchType="+ searchType +"&searchValue="+ searchValue; 
    	break;
}

Connection conn = null;			
PreparedStatement psmt = null;	
ResultSet rs = null;	

PreparedStatement psmtFile = null;
ResultSet rsFile = null;

PreparedStatement psmtHit = null;

PreparedStatement psmtComment = null;
ResultSet rsComment = null;

int uno = 0;
String nick = "";
String title = "";
String content = "";
String rdate = "";
String star = "";
String state = "";
String topYn = "";

String pname = "";
String fname = "";

String sqlBoard = ""; // 게시판 조회용 SQL
String sqlFile = "";  // 첨부파일 조회용 SQL


try{
	conn = DBConn.conn();
	if(type.equals("N")){
		sqlBoard = "select b.*,unick,pname from notice_board b "
				+ "inner join user u "
				+ "on b.uno = u.uno "
				+ "where nno=?";
	}else{
		sqlBoard = "select b.*,unick,pname, "
		+ "(select count(*) from recommend where bno = b.bno and state='E') as rCount "
		+ " from board b "
		+ " inner join user u "
		+ " on b.uno = u.uno "
		+ " where bno=?";
	}
	
	psmt = conn.prepareStatement(sqlBoard); //사용할 쿼리 등록
	psmt.setInt(1, Integer.parseInt(no));
		
	rs = psmt.executeQuery();
	
	if(rs.next()){
		if(type.equals("N")){
			topYn = rs.getString("top_yn");
		}else{
			star = rs.getString("star");
		}
		nick = rs.getString("unick");
		uno = rs.getInt("uno");
		title = rs.getString("title");
		content = rs.getString("content");
		rdate = rs.getString("rdate");
		state = rs.getString("state");
	}
	/* 첨부파일 확인 */
	if(!type.equals("N")){
		sqlFile = "select pname, fname from attach where bno=?";
		
		psmtFile = conn.prepareStatement(sqlFile); //사용할 쿼리 등록
		psmtFile.setInt(1, Integer.parseInt(no));
		rsFile = psmtFile.executeQuery();
		
		if(rsFile.next()){
			pname = rsFile.getString("pname");
			fname = rsFile.getString("fname");
		}
	}
}catch(Exception e){
	e.printStackTrace();
	out.print(e.getMessage());
}finally{
	DBConn.close(rsFile, psmtFile, null);
	DBConn.close(rs, psmt, conn);
}
%>
<script>
	let type = "";
	let fileName = "";
    window.onload = function() {
    	$("#titleId").focus();
    	type = '<%= type %>';
    	fileName = '<%= pname %>';
    	console.log(type);
   		
    	if(fileName == null || fileName == ""){
    		$(".deleteFile").css("display","none");
    		$("#preview").css("display","none");
    	}
    	
    	$("#file").on('change', function(){
	   		var fileName = $("#file").val();
	   		$(".upload-name").val(fileName);
   		  
  		 	// 새 파일이 선택된 경우 삭제 체크박스 보이기
   	   		$(".deleteFile").show(); // 체크박스를 보이게 함
   	  	 	$("#preview").show();
   	   		$("input[name='deleteFile']").prop('checked', false); // 체크 해제
   		});
    	
    	$(".upload-name").on('click',function(){
    		$("#file").click();
    	});
    	
    	$("input[name='deleteFile']").click(function(){
    		if($(this).is(':checked')) {
    			$(".upload-name").val("첨부파일");
    			$(".deleteFile").css("display","none");
    			$("#preview").css("display","none");
    	        document.getElementById('preview').src = "";
    	    }
    	});
    }
    
    function DoModify(){
		if($("#titleId").val() == ""){
			$("#msg").html("제목을 입력해주세요.");
			$("#titleId").focus();
			return false;
		}
		if(type == "R"){
			if($('input:radio[name=star]').is(':checked') != true){
				$("#msg").html("난이도를 선택해주세요.");
				return false;
			}
		}
		
		if(confirm("게시글을 수정하시겠습니까?") == true) {
			document.modifyForm.submit();
    		return true;
    	}
	}
    
    function readURL(input) {
        if(input.files && input.files[0]) {
            var reader = new FileReader();
            reader.onload = function(e) {
                // input-container에 있는 이미지 변경
                document.getElementById('preview').src = e.target.result;
            };
            reader.readAsDataURL(input.files[0]);
        }else {
            // 파일이 없을 경우 이미지 초기화
            document.getElementById('preview').src = "<%= request.getContextPath() %>/upload/<%= pname %>";
        }
    }
	
	
</script>
<section>
	<article>
        <div class="article_inner">
        <%
		if(type.equals("N")){
			%><h2>공지게시판</h2><%
		}else if(type.equals("F")){
			%><h2>자유게시판</h2><%
		}else{
			%><h2>레시피게시판</h2><%
		}
		%>
            <div class="content_inner">
	       		<form action="modifyOk.jsp" method="post" id="modifyForm" name="modifyForm" enctype="multipart/form-data">
		            <input type="hidden" name="no" value="<%= no %>">
		            <input type="hidden" name="type" value="<%= type %>">
		            <input type="hidden" name="path" value="<%= path %>">
                    <table>
                         <tr>
                             <th align="right">제목&nbsp;</th>
                             <td><input type="text" name="title" id="titleId" value="<%= title %>"></td>
                         </tr>
                         <%
						 if(type.equals("R")){
						 %>
						 <tr>
						 	<th align="right">난이도&nbsp;</th>
						 	<td>
							 <div class="rating" id="starview">
							 	<input id="star5_view" name="starview" type="radio" value="5" <%= star.equals("5") ? "checked" : "" %> /><label for="star5_view">★</label>
							 	<input id="star4_view" name="starview" type="radio" value="4" <%= star.equals("4") ? "checked" : "" %> /><label for="star4_view">★</label>
							 	<input id="star3_view" name="starview" type="radio" value="3" <%= star.equals("3") ? "checked" : "" %> /><label for="star3_view">★</label>
							 	<input id="star2_view" name="starview" type="radio" value="2" <%= star.equals("2") ? "checked" : "" %> /><label for="star2_view">★</label>
							 	<input id="star1_view" name="starview" type="radio" value="1" <%= star.equals("1") ? "checked" : "" %> /><label for="star1_view">★</label>
						     </div>
					     	</td>
					     </tr>
						 <%
                         }else if(type.equals("N")){
                       	 %>
                         <tr>
                             <th align="right">상위노출여부&nbsp;</th>
                             <td align="left">
                             	 <div class="top_yn">
                             	 <input type="radio" name="top_yn" value="Y" <%= topYn.equals("Y") ? "checked" : "" %> id="top_y"><label for="top_y">노출</label>
                             	 <input type="radio" name="top_yn" value="N" <%= topYn.equals("N") ? "checked" : "" %> id="top_n"><label for="top_n">비노출</label>
                                 </div>
                             </td>
                         </tr>
                       	 <%
                         }
                         if(!type.equals("N")){
                         %>
                         <tr>
                             <th align="right">첨부파일&nbsp;</th>
                             <td align="left">
                                 <div class="profil" 
                                 style="margin-top:20px; width:200px;">
                                 <label for="file">
			                     	 <input class="upload-name" style="background-color:white;" value="첨부파일" readonly>
			                	     <input type="file" id="file" name="fname" onchange="readURL(this);">
	                     		 </label>
                                 </div>
                                 <!-- 첨부파일 삭제 여부 체크박스 추가 -->
                                 <div class="deleteFile">
		                          	 <input type="checkbox" name="deleteFile" value="Y" id="deleteFile">
		                          	 <label for="deleteFile"><i class="fas fa-solid fa-circle-xmark"></i></label>
	                             </div>
                                 <img id="preview"  
                                     src="<%= request.getContextPath() %>/upload/<%= pname %>" alt="첨부된 이미지" 
                                     style="max-width:150px; max-height:150px; border-radius:5px;" />
                             </td>
                         </tr>
                         <%
                         }
                         %>
                         <tr>
                             <th align="right">내용&nbsp;</th>
                             <td>
                                 <textarea name="content" id="mytextarea" rows="10" cols="50"><%= content.replace("<br>","\n") %></textarea>
                             </td>
                         </tr>
                         <tr>
                             <td colspan="2" style="text-align: center;">
                                 <span id="msg" style="color:green;">&nbsp;</span>
                             </td>
                         </tr>
                         <tr>
                             <td colspan="2" align="center">
                                 <button type="button" id="wBtn" onclick="DoModify();">글수정</button>
                                 <button type="reset" id="resetBtn">취소</button>
                             </td>
                         </tr>
                     </table>
	      	 	 </form>
			</div>
		</div>
	</article>
</section>
<%@ include file="../include/footer.jsp" %>