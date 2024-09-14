<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp" %>
<script>
	window.onload = function(){
		$("#uid").focus();	
		
		$("#uid,#upw").keyup(function(event){
			if(event.keyCode == 13)
			{	//Enter문자가 눌려짐. keyCode 아스키코드. 13이 enter 
				DoLogin();
			}
		});
	}
	
	function DoReset(){
		let msg = document.getElementById("msg");
        msg.innerHTML = "";
	}	
	
	function DoLogin(){
		if($("#uid").val() == ""){
			$("#msg").html("아이디를 입력해주세요.");
			$("#uid").focus();
			return false;
		}
		
		if($("#upw").val() == ""){
			$("#msg").html("비밀번호를 입력해주세요.");
			$("#upw").focus();
			return false;
		}
		
		if(confirm("로그인하시겠습니까?") == true){
			$("#loginFn").submit();
    		return true;
		}
	}
</script>
<section>
    <article>
        <div class="article_inner">
            <h2>로그인</h2>
            <div class="content_inner">
				<form action="loginOk.jsp" method="post" id="loginFn">
				<table style="border: none; align:left;" width="100%">
              	    <tr>
                        <td style="text-align: right;">아이디&nbsp;</td>
                        <td>
                            <input type="text" name="uid" id="uid" onkeydown="DoReset();">
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right;">비밀번호&nbsp;</td>
                        <td>
                            <input type="password" name="upw" id="upw" onkeydown="DoReset();">
                        </td>
                    </tr>
                    <tr>
	                   	<td colspan="2" style="text-align: center;">
	                       	<span id="msg" style="color:green;">&nbsp;</span>
	                   	</td>
                    </tr>
                    <tr>
                        <td colspan="2" style="text-align: center;">
                            <button type="button" onclick="DoLogin();" id="login">로그인하기</button>
                            <br>
                            <a href="<%= request.getContextPath() %>/index.jsp">
                            <button type="button" id="nomalBtn">비회원으로 이용하기</button>
                            </a>
                        </td>
                    </tr>
                </table>
                </form>
			</div>
        </div>
    </article>
</section>		
<%@ include file="../include/footer.jsp" %>