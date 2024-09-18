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

try{
	conn = DBConn.conn();
	
	sql = "select * from user where uno=? and state='E' ";
	
	psmt = conn.prepareStatement(sql); //사용할 쿼리 등록
	psmt.setInt(1, Integer.parseInt(uno));
	System.out.print(sql);
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
	DBConn.close(rs, psmt, conn);
}
%>
<script>
var IsDuplicate = false;
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
	
	$("#unick,#upw").keyup(function(event){
		if(event.keyCode == 13)	{
			DoChange();
			return;
		}
	});
	
	
	$("#unick").keyup(function(){
		IsDuplicate = false;
		usernick = $(this).val();
		
		$.ajax({
			url : "nickCheck.jsp",
			type : "post",
			data : {unick : usernick},
			dataType : "html",
			success : function(result)
			{
				result = result.trim();
				switch(result)
				{
				case "00" : 
					$("#msg").html("닉네임 체크 오류입니다.");
					break;
				case "01" : 
					$("#msg").html("중복된 닉네임입니다.");
					IsDuplicate = true;
					break;
				case "02" : 
					$("#msg").html("사용 가능한 닉네임입니다.");
					break;
				}
			}
		});
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

function DoChange()
{
	if($("#upw").val() == "") {
		$("#upw").focus();
		alert("비밀번호를 입력하세요");
		return;
	}
	
	if($("#unick").val() == "<%= nick %>") {
		$("#unick").focus();
		alert("닉네임 변경사항이 없습니다.");
		return;
	}
	
	if(IsDuplicate == true)	{
		alert("중복된 닉네임입니다. 새로운 닉네임 입력하세요.");
		$("#unick").focus();
		return;
	}
	
	if(confirm("회원정보를 변경하시겠습니까?") == true) {
		$("#myinfoFn").submit();
		return true;
	}
}

function DoReset(){
	let msg = document.getElementById("msg");
    msg.innerHTML = "";
}	

</script>
<section>
    <article>
    	<form action="myinfoChange.jsp" method="post" id="myinfoFn" enctype="multipart/form-data">
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
              		    <input type="text" name="unick" id="unick" placeholder="<%= nick %>"  onkeydown="DoReset();">
					</p>
					<p>아이디 : <%= uid %></p>
					<p>이메일 : <%= email %></p>
					<p>회원등급 : <%= LevelStr %></p>
					<p>가입일 : <%= rdate %></p>
					<p>비밀번호 : 
						<input type="password" name="upw" id="upw">
					</p>
					<span id="msg" style="color:green;"></span>
					<div style="margin-top:60px;">
		        	<button type="button" id="myinfoBtn" onclick="DoChange();">정보변경</button>
		        	<button type="reset" id="resetBtn">취소</button>
		        	</div>
				</div>	
			</div>
        </div>
        </form>
    </article>
</section>
<%@ include file="../include/footer.jsp" %>