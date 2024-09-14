<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp" %>
<script>
	let IsDuplicate = false;
	window.onload = function(){
		/* alert("js"); */
		/* document.getElementById("uid").focus(); */
		
		$("#uid").focus();
		
		
		$("#uid").keydown(function(){
			
			userid = $(this).val();
			
			$.ajax({
				url : "idCheck.jsp",
				type : "post",
				data : {uid : userid},
				dataType : "html",
				success : function(result)
				{
					result = result.trim();
					switch(result)
					{
					case "00" : 
						$("#msg").html("사용 가능한 아이디입니다.");
						break;
					case "01" : 
						$("#msg").html("중복된 아이디입니다.");
						IsDuplicate = true;
						break;
					}
				}
			});
		});
	}
	
	
	function DoJoin(){
		let id = document.getElementById("uid");
		let msg = document.getElementById("msg");
		//아이디 검사
		if(id.value == ""){
			msg.innerHTML = "아이디를 입력해주세요";
			id.focus();
            return false;
		}else if(id.value.length <4){
			msg.innerHTML = "아이디는 4글자 이상 입력해주세요";
			id.focus();
            return false;
        }else if(IsDuplicate == true){
        	msg.innerHTML = "중복된 아이디입니다";
			id.focus();
        	return false;
        }
		//비밀번호 검사
        let pass = document.getElementById("upw");
        if(pass.value == ""){
            msg.innerHTML = "비밀번호를 입력해주세요";
            pass.focus();
            return false;
        }else if(pass.value.length < 4){
            msg.innerHTML = "비밀번호는 4글자 이상 입력해주세요";
            pass.focus();
            return false;
        }
        //비밀번호 확인
        let pwCheck = document.getElementById("upwcheck");
        if(pwCheck.value == ""){
            msg.innerHTML = "비밀번호 확인을 입력해주세요";
            pwCheck.focus();
            return false;
        }else if(pwCheck.value != pass.value){
            msg.innerHTML = "비밀번호가 일치하지 않습니다";
            pwCheck.focus();
            return false;
        }
        
        //이름 2글자이상
        let userName = document.getElementById("uname");
        if(userName.value == ""){
            msg.innerHTML = "이름을 입력해주세요";
            userName.focus();
            return false;
        }else if(userName.value.length < 2){
            msg.innerHTML = "이름은 2글자 이상 입력해주세요";
            userName.focus();
            return false;
        }
        
        //닉네임 2글자이상
        let userNick = document.getElementById("unick");
        if(userNick.value == ""){
            msg.innerHTML = "닉네임을 입력해주세요";
            userNick.focus();
            return false;
        }else if(userNick.value.length < 2){
            msg.innerHTML = "닉네임은 2글자 이상 입력해주세요";
            userNick.focus();
            return false;
        }
    	//이메일 입력확인
        let mail = document.getElementById("uemail");
        if(mail.value == ""){
            msg.innerHTML = "이메일을 입력해주세요";
            mail.focus();
            return false;
        }
		
        if(confirm("회원가입을 완료하시겠습니까?") == true)
    	{
    		$("#joinFn").submit();
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
        <div class="article_inner">
            <h2>회원가입</h2>
            <div class="content_inner">
				<form action="joinOk.jsp" method="post" id="joinFn">
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
                         <td style="text-align: right;">비밀번호 확인&nbsp;</td>
                         <td>
                             <input type="password" name="upwcheck" id="upwcheck" onkeydown="DoReset();">
                         </td>
                     </tr>
                     <tr>
                         <td style="text-align: right;">이름&nbsp;</td>
                         <td>
                             <input type="text" name="uname" id="uname" onkeydown="DoReset();">
                         </td>
                     </tr>
                     <tr>
                         <td style="text-align: right;">닉네임&nbsp;</td>
                         <td>
                         	<input type="text" name="unick" id="unick" onkeydown="DoReset();">
                         </td>
                     </tr>
                     <tr>
                         <td style="text-align: right;">이메일&nbsp;</td>
                         <td><input type="email" name="uemail" id="uemail" onkeydown="DoReset();"></td>
                     </tr>
                     <tr>
                     	<td colspan="2" style="text-align: center;">
                         	<span id="msg" style="color:green;">&nbsp;</span>
                     	</td>
                     </tr>
                     <tr>
                         <td colspan="2" style="text-align: center;">
                             <button type="button" id="join" onclick="DoJoin();">가입하기</button>
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