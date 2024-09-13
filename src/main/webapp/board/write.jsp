<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp" %>
<!-- TinyMCE 스크립트 추가 -->
<script src="https://cdn.tiny.cloud/1/ckipu5rjvi2dbdbr9rwb27y8fhvxkxrafixcfw6irvyinjsl/tinymce/7/tinymce.min.js" referrerpolicy="origin"></script>
<script>
	window.onload = function(){
		$("title").focus();
	}

	/* TinyMCE 스크립트 */
	tinymce.init({
		selector: 'textarea',
		/* plugins: [
		  // Core editing features
		  'anchor', 'autolink', 'charmap', 'codesample', 'emoticons', 'image', 'link', 'lists', 'media', 'searchreplace', 'table', 'visualblocks', 'wordcount',
		  // Your account includes a free trial of TinyMCE premium features
		  // Try the most popular premium features until Sep 26, 2024:
		  'checklist', 'mediaembed', 'casechange', 'export', 'formatpainter', 'pageembed', 'a11ychecker', 'tinymcespellchecker', 'permanentpen', 'powerpaste', 'advtable', 'advcode', 'editimage', 'advtemplate', 'ai', 'mentions', 'tinycomments', 'tableofcontents', 'footnotes', 'mergetags', 'autocorrect', 'typography', 'inlinecss', 'markdown',
		],
		toolbar: 'undo redo | blocks fontfamily fontsize | bold italic underline strikethrough | link image media table mergetags | addcomment showcomments | spellcheckdialog a11ycheck typography | align lineheight | checklist numlist bullist indent outdent | emoticons charmap | removeformat',
		tinycomments_mode: 'embedded',
		tinycomments_author: 'Author name',
		mergetags_list: [
		  { value: 'First.Name', title: 'First Name' },
		  { value: 'Email', title: 'Email' },
		],
		ai_request: (request, respondWith) => respondWith.string(() => Promise.reject('See docs to implement AI Assistant')), */
		width: 600,
		height: 300,
		plugins: 'image',  // 이미지 플러그인 추가
		toolbar: 'image',  // 이미지 버튼 추가
		images_upload_url: 'upload_image.jsp',  // 이미지 업로드 처리 파일
		automatic_uploads: true,  // 이미지 자동 업로드 설정
		images_upload_handler: function (blobInfo, success, failure) {
			var xhr, formData;
			xhr = new XMLHttpRequest();
			xhr.open('POST', 'upload_image.jsp');  // 이미지 업로드 URL

			xhr.onload = function () {
				var json;
				if (xhr.status != 200) {
					failure('HTTP Error: ' + xhr.status);
					return;
				}
				json = JSON.parse(xhr.responseText);
				if (!json || typeof json.location != 'string') {
					failure('Invalid JSON: ' + xhr.responseText);
					return;
				}
				success(json.location);  // 이미지 경로를 TinyMCE에 전달
			};

			formData = new FormData();
			formData.append('file', blobInfo.blob(), blobInfo.filename());  // 이미지 파일을 FormData로 보내기
			xhr.send(formData);
		}
	});
	
	function DoWrite(){
		if($("#title").val() == ""){
			$("#title").html("제목을 입력해주세요.");
			$("#title").focus();
			return false;
		}
		
		if($("#star").val() == ""){
			$("#star").html("난이도를 선택해주세요.");
			return false;
		}
		
		
		if(confirm("게시글을 등록하시겠습니까?") == true)
    	{
    		$("#writeFn").submit();
    		return true;
    	}
	}
</script>
<div class="container">
<section>
	<!-- 메뉴 오른쪽 게시판 상세 내용 부분 -->
	<form action="writeOk.jsp" method="post" id="writeFn">
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
							<td><input type="text" name="title" style="width:100%;"></td>
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
						<tr>
							<th align="right">내용&nbsp;</th>
							<td>
								<!-- TinyMCE 적용될 textarea -->
						        <textarea name="content" id="mytextarea"></textarea>
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