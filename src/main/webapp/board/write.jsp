<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp" %>
<%
String type = request.getParameter("type");
String path = "";
if(type == null || type.equals("")){
	type = "R";
}
switch(type) {
    case "N": path = "board_list.jsp?type=N"; break;
    case "F": path = "board_list.jsp?type=F"; break;
    case "R": path = "board_list.jsp?type=R"; break;
}
%>
<script>
	let type = "";
    window.onload = function() {
    	$("#titleId").focus();
    	type = '<%= type %>';
    	console.log(type);
   		
    	$("#file").on('change', function(){
   		  var fileName = $("#file").val();
   		  $(".upload-name").val(fileName);
   		});
    }
    
    function DoWrite(){
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
		
		
		if(confirm("게시글을 등록하시겠습니까?") == true)
    	{
			document.writeForm.type.value = type;
			document.writeForm.submit();
    		return true;
    	}
	}
    
	function readURL(input) {
		if (input.files && input.files[0]) {
			var reader = new FileReader();
			reader.onload = function(e) {
			document.getElementById('preview').src = e.target.result;
		};
		reader.readAsDataURL(input.files[0]);
		}else {
			document.getElementById('preview').src = "";
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
	       		<form action="writeOk.jsp" method="post" id="writeForm" name="writeForm" enctype="multipart/form-data">
		            <input type="hidden" name="type">
		            <input type="hidden" name="path" value="<%= path %>">
                    <table>
                         <tr>
                             <th align="right">제목&nbsp;</th>
                             <td><input type="text" name="title" id="titleId"></td>
                         </tr>
                         <%
                         if(type.equals("R")){
                       		 %>
                         <tr>
                             <th align="right">난이도&nbsp;</th>
                             <td align="left">
                                 <div class="star-rating" id="star">
                                     <input id="star5" name="star" type="radio" value="5"/><label for="star5">★</label>
                                     <input id="star4" name="star" type="radio" value="4"/><label for="star4">★</label>
                                     <input id="star3" name="star" type="radio" value="3"/><label for="star3">★</label>
                                     <input id="star2" name="star" type="radio" value="2"/><label for="star2">★</label>
                                     <input id="star1" name="star" type="radio" value="1"/><label for="star1">★</label>
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
                             	 <input type="radio" name="top_yn" value="Y" id="top_y"><label for="top_y">노출</label>
                             	 <input type="radio" name="top_yn" value="N" id="top_n" checked><label for="top_n">비노출</label>
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
                                 <div class="filebox">
                                     <input class="upload-name" value="첨부파일" placeholder="첨부파일" readonly>
                                     <label for="file">파일찾기</label>
                                     <input type="file" id="file" name="fname" onchange="readURL(this);">
                                 </div>
                                 <img id="preview" />
                             </td>
                         </tr>
                        	 <%
                         }
                         %>
                         <tr>
                             <th align="right">내용&nbsp;</th>
                             <td>
                                 <textarea name="content" id="mytextarea" rows="10" cols="50"></textarea>
                             </td>
                         </tr>
                         <tr>
                             <td colspan="2" style="text-align: center;">
                                 <span id="msg" style="color:green;">&nbsp;</span>
                             </td>
                         </tr>
                         <tr>
                             <td colspan="2" align="center">
                                 <button type="button" id="wBtn" onclick="DoWrite();">글쓰기</button>
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