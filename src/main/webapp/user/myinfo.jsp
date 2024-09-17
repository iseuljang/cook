<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp" %>
<%
request.setCharacterEncoding("UTF-8");



if(session.getAttribute("loginUserNo") == null || session.getAttribute("loginUserNo").equals("")){
	response.sendRedirect( request.getContextPath() +"/index.jsp");
}
String uno = (String)session.getAttribute("loginUserNo");

Connection conn = null;			
PreparedStatement psmt = null;	
ResultSet rs = null;	

String uid = "";
String nick = "";
String email = "";
String rdate = "";
String state = "";
String author = "";

String pname = "";
String fname = "";

String sql = ""; // 게시판 조회용 SQL

String sqlUpdate = "";
PreparedStatement psmtUpdate = null;	

try{
	conn = DBConn.conn();
	// POST 요청으로 회원 정보 수정
    if(request.getMethod().equalsIgnoreCase("POST")) {
        String newNick = request.getParameter("unick");
        Part filePart = request.getPart("fname"); // 프로필 파일

        if(newNick != null && !newNick.trim().isEmpty()) {
        	sqlUpdate = "UPDATE user SET unick=? WHERE uno=?";
        	psmtUpdate = conn.prepareStatement(sqlUpdate);
        	psmtUpdate.setString(1, newNick);
        	psmtUpdate.setInt(2, Integer.parseInt(uno));
        	psmtUpdate.executeUpdate();
        }

        // 파일 업로드 처리
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = filePart.getSubmittedFileName();
            String uploadPath = application.getRealPath("/upload") + "/" + fileName;
            filePart.write(uploadPath);

            sqlUpdate = "UPDATE user SET pname=? WHERE uno=?";
            psmtUpdate = conn.prepareStatement(sqlUpdate);
            psmtUpdate.setString(1, fileName);
            psmtUpdate.setInt(2, Integer.parseInt(uno));
            psmtUpdate.executeUpdate();
        }

        response.sendRedirect("myinfo.jsp");
    }
	
	
	
	sql = "select * from user where uno=? and state='E' ";
	
	psmt = conn.prepareStatement(sql); //사용할 쿼리 등록
	psmt.setInt(1, Integer.parseInt(uno));
		
	rs = psmt.executeQuery();
	
	if(rs.next()){
		uid = rs.getString("uid");
		nick = rs.getString("unick");
		email = rs.getString("uemail");
		pname = rs.getString("pname");
		rdate = rs.getString("rdate");
		state = rs.getString("state");
		author = rs.getString("uauthor");
	}
}catch(Exception e){
	e.printStackTrace();
	out.print(e.getMessage());
}finally{
	DBConn.close(psmtUpdate, null);
	DBConn.close(rs, psmt, conn);
}
%>
<script>
window.onload = function(){
	$("#unick").focus();
	
	$("#file").on('change', function(){
	  var fileName = $("#file").val();
	  $(".upload-name").val(fileName);
	});
	
	$(".upload-name").on('click',function(){
		$("#file").click();
	});
	
	$('#resetBtn').click(function(){
		$('#preview').attr('src', '<%= request.getContextPath() %>/upload/<%= pname %>');
	});
	
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

function DoChange(){
	if(confirm("회원정보를 변경하시겠습니까?") == true) {
		$("#myinfoFn").submit();
		return true;
	}
}

</script>
<section>
    <article>
    	<form action="myinfo.jsp" method="post" id="myinfoFn" enctype="multipart/form-data">
        <div class="article_inner">
            <h2>회원정보</h2>
            <div class="view_inner">
           		<%
           		if(pname != null && !pname.isEmpty()) { 
	            %>
	            <div class="view_img">
		            <img id="preview" class="circular-img"
		            style="border:none; width:250px; height:250px; border-radius:50%;" 
		            src="<%= request.getContextPath() %>/upload/<%= pname %>" alt="첨부된 이미지" style="max-width: 100%; height: auto;" />
	                <div class="profil" style="margin-top:20px;">
	                    <label for="file">
	                     	 <input class="upload-name" style="background-color:white;" value="프로필이미지 선택" placeholder="프로필이미지 선택" readonly>
	                	    <input type="file" id="file" name="fname" onchange="readURL(this);">
	                    </label>
	                </div>
            	</div>
	            <%
		        }
			    %>
            	<div class="view_content">
            		<p>닉네임 : 
              		    <input type="text" name="unick" id="unick" placeholder="닉네임" value="<%= nick %>">
					</p>
					<p>아이디 : <%= uid %></p>
					<p>이메일 : <%= email %></p>
					<p>회원등급 : <%= LevelStr %></p>
					<p>가입일 : <%= rdate %></p>
					<div style="margin-top:60px;">
		        	<button type="button" id="infoBtn" onclick="DoChange();">정보변경</button>
		        	<button type="reset" id="resetBtn">취소</button>
		        	</div>
				</div>	
			</div>
        </div>
        </form>
    </article>
</section>
<%@ include file="../include/footer.jsp" %>