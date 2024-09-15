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
            <div class="login_title">
            <h2>로그인</h2>
            </div>
            <div class="login_inner">
                <form action="loginOk.jsp" method="post" id="loginFn">
                    <table>
                        <tr>
                            <td>
                                <div class="input-container">
                                    <i class="fas fa-user"></i>
                                    <input type="text" name="uid" id="uid" placeholder="아이디" onkeydown="DoReset();">
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="input-container">
                                    <i class="fas fa-lock"></i>
                                    <input type="password" name="upw" id="upw" placeholder="비밀번호" onkeydown="DoReset();">
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <span id="msg" style="color:green;">&nbsp;</span>
                            </td>
                        </tr>
                        <tr>
                            <td>
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