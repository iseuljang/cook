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
	/* function showPreview(){
	    oEditors.getById["editorTxt0"].exec("UPDATE_CONTENTS_FIELD", []);
	    var content = document.getElementById("editorTxt0").value;
	    console.log("미리보기 내용:", content);
	} */

    window.onload = function() {
    	$("#titleId").focus();
    	type = '<%= type %>';
    	$(".deleteFile").css("display","none");
    	console.log(type);
   		
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
    			$("#file").val("");
    			$(".deleteFile").css("display","none");
    			$("#preview").css("display","none");
    	        document.getElementById('preview').src = "";
    	    }
    	});
    	
    	
    	//스마트에디터 적용
        smartEditor(); 
    }
    
    let oEditors = [];
	
    smartEditor = function() {
        nhn.husky.EZCreator.createInIFrame({
            oAppRef: oEditors,
            elPlaceHolder: "editorTxt0", //textarea에 부여한 아이디와 동일해야한다.
            sSkinURI: "<%= request.getContextPath() %>/static/SmartEditor2Skin.html", //자신의 프로젝트에 맞게 경로 수
            fCreator: "createSEditor2"
        })
    }
    
    
    /* function DoWrite(){
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
	} */
    
	function DoWrite() {
	    oEditors.getById["editorTxt0"].exec("UPDATE_CONTENTS_FIELD", []); // 스마트에디터 업데이트
	    let content = document.getElementById("editorTxt0").value;
	    let star = 0;

	    // 내용이 비어 있는지 확인
	    if (content == '<p>&nbsp;</p>') {
	        alert("내용을 입력해주세요.");
	        oEditors.getById["editorTxt0"].exec("FOCUS");
	        return false;
	    } else {
	        if ($("#titleId").val() == "") {
	            $("#msg").html("제목을 입력해주세요.");
	            $("#titleId").focus();
	            return false;
	        }
	        
	        // 레시피 게시판일 경우 난이도 체크
	        if(type == "R") {
	            if(!$('input:radio[name=star]').is(':checked')) {
	                $("#msg").html("난이도를 선택해주세요.");
	                return false;
	            }else {
	                star = $('input:radio[name=star]:checked').val();
	            }
	        }

	        // star 값이 0보다 클 경우에만 writeForm에 값 추가
	        if(star > 0) {
	            $("<input>").attr({
	                type: "hidden",
	                name: "star",
	                value: star
	            }).appendTo("#writeForm");
	        }

	        // 확인 후 폼 제출
	        if (confirm("게시글을 등록하시겠습니까?")) {
	            $("#writeForm").submit(); // form 제출
	        }
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
		            <input type="hidden" name="type" value="<%= type %>">
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
                                 <img id="preview" style="max-width:150px; max-height:150px; border-radius:5px;" />
                             </td>
                         </tr>
                        	 <%
                         }
                         %>
                         <tr>
                             <th align="right">내용&nbsp;</th>
                             <td>
                                 <!-- <textarea name="content" id="mytextarea" rows="10" cols="50"></textarea> -->
                                 <div id="smarteditor">
								   <textarea name="editorTxt" id="editorTxt0"
								             rows="20" cols="20"
								             style="max-width: 600px"
								   ></textarea>
								  </div>
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