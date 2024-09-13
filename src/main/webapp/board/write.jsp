<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp" %>
<%
String type = request.getParameter("type");
String path = "";
switch(type) {
    case "N": path = "notice_board_list.jsp?type="; break;
    case "F": path = "free_board_list.jsp?type="; break;
    case "R": path = "r_board_list.jsp?type="; break;
}
%>
<script>
    window.onload = function() {
    	$("#titleId").focus();
   		
/*     	$("#file").on('change', function(){
   		  var fileName = $("#file").val();
   		  $(".upload-name").val(fileName);
   		}); */
    }
    
    function DoWrite(){
		if($("#titleId").val() == ""){
			$("#msg").html("제목을 입력해주세요.");
			$("#titleId").focus();
			return false;
		}
		
		if($('input:radio[name=star]').is(':checked') != true){
			$("#msg").html("난이도를 선택해주세요.");
			return false;
		}
		
		
		if(confirm("게시글을 등록하시겠습니까?") == true)
    	{
    		$("#writeForm").submit();
    		return true;
    	}
	}
</script>

<div class="container">
    <section>
        <form action="writeOk.jsp" method="post" id="writeForm">
            <input type="hidden" name="type" value="<%= type %>">
            <input type="hidden" name="path" value="<%= path %>">
            <table id="inTable">
                <tr>
                    <td>
                        <h2>&nbsp;&nbsp;레시피게시판</h2>
                    </td>
                </tr>
                <tr>
                    <td>
                        <table width="100%" id="writeTable">
                            <tr>
                                <th width="90px" align="right">제목&nbsp;</th>
                                <td><input type="text" name="title" id="titleId" style="width:100%;"></td>
                            </tr>
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
                            <!-- <tr>
                                <th align="right">첨부파일&nbsp;</th>
                                <td align="left">
                                    <div class="filebox">
                                        <input class="upload-name" value="첨부파일" placeholder="첨부파일" readonly>
                                        <label for="file">파일찾기</label>
                                        <input type="file" id="file" name="file">
                                    </div>
                                </td>
                            </tr> -->
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
                    </td>
                </tr>
            </table>
        </form>
    </section>
</div>
<%@ include file="../include/footer.jsp" %>