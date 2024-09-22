<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp" %>
<script>
	let IsDuplicate = false;
	let NickDuplicate = false;
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
						IsDuplicate = false;
						break;
					case "01" : 
						$("#msg").html("중복된 아이디입니다.");
						IsDuplicate = true;
						break;
					}
				}
			});
		});
		
		$("#unick").keyup(function(){
			NickDuplicate = false;
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
						NickDuplicate = true;
						break;
					case "02" : 
						$("#msg").html("사용 가능한 닉네임입니다.");
						NickDuplicate = false;
						break;
					}
				}
			});
		});
		
		
		$(".deleteFile").css("display","none");
   		
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
        
        //이메일 입력확인
        let mail = document.getElementById("uemail");
        if(mail.value == ""){
            msg.innerHTML = "이메일을 입력해주세요";
            mail.focus();
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
        }else if(NickDuplicate == true){
        	msg.innerHTML = "이미 사용중인 닉네임입니다";
        	userNick.focus();
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
            <div class="join_title">
            <h2>회원가입</h2>
            </div>
            <div class="join_inner">
				<form action="joinOk.jsp" method="post" id="joinFn" enctype="multipart/form-data">
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
                            <div class="input-container">
                                <!-- <i class="fas fa-lock"></i> -->
                                <i class="fas fa-check"></i>
                           		<input type="password" name="upwcheck" id="upwcheck" placeholder="비밀번호확인" onkeydown="DoReset();">
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="input-container">
                                <i class="fas fa-envelope"></i>
		                        <input type="email" name="uemail" id="uemail" placeholder="이메일" onkeydown="DoReset();">
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="input-container">
                                <i class="fas fa-user"></i>
		                        <input type="text" name="unick" id="unick" placeholder="닉네임" onkeydown="DoReset();">
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="input-container">
	                    		 <i class="fas fa-camera"></i> 
	                             <img id="preview" class="circular-img" />
	                             <!-- 첨부파일 삭제 여부 체크박스 추가 -->
                                 <div class="deleteFile" style="margin-left:10px;">
		                          	 <input type="checkbox" name="deleteFile" value="Y" id="deleteFile">
		                          	 <label for="deleteFile"><i class="fas fa-solid fa-circle-xmark"></i></label>
	                             </div>
	                             <div class="profil" style="width:250px;">
	                                 <label for="file">
	                                	 <input class="upload-name" value="프로필이미지" placeholder="프로필이미지" readonly>
		                                 <input type="file" id="file" name="fname" onchange="readURL(this);">
	                                 </label>
	                             </div>
                            </div>
                        </td>
                    </tr>
                     <tr>
                     	<td style="text-align: center;">
                         	<span id="msg" style="color:green;"></span>
                     	</td>
                     </tr>
                     <tr>
                         <td style="text-align: center;">
                             <button type="button" class="join" onclick="DoJoin();">가입하기</button>
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