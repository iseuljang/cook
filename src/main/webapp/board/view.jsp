<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp" %>
<%
request.setCharacterEncoding("UTF-8");

String no = request.getParameter("no");
String type = request.getParameter("type");
String nowPage = request.getParameter("nowPage");
String searchType  = request.getParameter("searchType");
String searchValue  = request.getParameter("searchValue");

if(nowPage == null){
	nowPage = "1";
}

if(no == null || no.equals("")){
	%>
	<script>
		alert("잘못된 접근입니다");
		location.href = "<%= request.getContextPath() %>/list.jsp";
	</script>
	<%
}

if(type == null || type.equals("")){
	type = "F";
}

String boardName = "";
String path = "";

if(type.equals("N")){
	boardName = "공지게시판";
	path = "board_list.jsp?type=N";
}else if(type.equals("F")){
	boardName = "자유게시판";
	path = "board_list.jsp?type=F";
}else{
	boardName = "레시피게시판";
	path = "board_list.jsp?type=R";
}


Connection conn = null;			
PreparedStatement psmt = null;	
ResultSet rs = null;	

PreparedStatement psmtFile = null;
ResultSet rsFile = null;

PreparedStatement psmtHit = null;

PreparedStatement psmtComment = null;
ResultSet rsComment = null;

int uno = 0;
String nick = "";
String title = "";
String content = "";
String rdate = "";
int hit = 0;
String recoTotal = "";
String star = "";
String state = "";
String topYn = "";

String userPname = "";
String pname = "";
String fname = "";

String sqlBoard = ""; // 게시판 조회용 SQL
String sqlFile = "";  // 첨부파일 조회용 SQL
String sqlHit = "";   // 조회수 증가용 SQL
String sqlComment = ""; // 댓글 조회용 SQL

String recoState = "D";

List<Comment> commentList = new ArrayList<>();

try{
	conn = DBConn.conn();
	if(type.equals("N")){
		sqlBoard = "select b.*,unick,pname from notice_board b "
				+ "inner join user u "
				+ "on b.uno = u.uno "
				+ "where nno=?";
	}else{
		sqlBoard = "select b.*,unick,pname, "
		+ "(select count(*) from recommend where bno = b.bno and state='E') as rCount "
		+ " from board b "
		+ " inner join user u "
		+ " on b.uno = u.uno "
		+ " where bno=?";
	}
	
	psmt = conn.prepareStatement(sqlBoard); //사용할 쿼리 등록
	psmt.setInt(1, Integer.parseInt(no));
		
	rs = psmt.executeQuery();
	
	if(rs.next()){
		if(type.equals("N")){
			topYn = rs.getString("top_yn");
		}else{
			star = rs.getString("star");
			recoTotal = rs.getString("rCount");
		}
		userPname = rs.getString("pname");
		nick = rs.getString("unick");
		uno = rs.getInt("uno");
		title = rs.getString("title");
		content = rs.getString("content");
		rdate = rs.getString("rdate");
		hit = rs.getInt("hit");
		state = rs.getString("state");
	}
	/* 첨부파일 확인 */
	if(!type.equals("N")){
		sqlFile = "select pname, fname from attach where bno=?";
		
		psmtFile = conn.prepareStatement(sqlFile); //사용할 쿼리 등록
		psmtFile.setInt(1, Integer.parseInt(no));
		rsFile = psmtFile.executeQuery();
		
		if(rsFile.next()){
			pname = rsFile.getString("pname");
			fname = rsFile.getString("fname");
		}
	}
	
	/* 조회수증가 */
	if(type.equals("N"))
	{
		sqlHit  = "update notice_board set hit = hit + 1 "
		 		+ " where nno = ?";
	}else if(type.equals("F")){
		sqlHit  = "update board set hit = hit + 1 "
				+ " where bno = ? and type='F' ";
	}else{
		sqlHit  = "update board set hit = hit + 1 "
				+ " where bno = ? and type='R' ";
	}
	hit++;
	psmtHit = conn.prepareStatement(sqlHit);
	psmtHit.setInt(1, Integer.parseInt(no));
	psmtHit.executeUpdate();
	
	
	
}catch(Exception e){
	e.printStackTrace();
	out.print(e.getMessage());
}finally{
	DBConn.close(psmtHit, null);
	DBConn.close(rsFile, psmtFile, null);
	DBConn.close(rs, psmt, conn);
}
%>
<script>
window.onload = function(){
	/* 댓글 리스트 */
	loadComment();
	/* 추천 부분 */
	loadReco();
}

function loadComment() {
    $.ajax({
        url: "loadComment.jsp",
        type: "get",
        data: { no: "<%= no %>" },
        success: function(data) 
        {
            $(".commentDiv").html(data);
        },
        error: function() {
            alert("댓글 로딩 중 오류가 발생했습니다.");
        }
    });
}

/* 댓글작성버튼 */
function commentAdd(){
	if ($("#comment").val() == "") {
        alert("댓글 내용을 입력하세요.");
        return;
    }	
	
	$.ajax({
		type : "post",
		url  : "commentAdd.jsp",
		data: $("#commentForm").serialize(),
		datatype : "html",
		success : function(result)
		{
			if(result.trim() === "OK") {
                alert("댓글이 작성되었습니다.");
                loadComment(); // 댓글 작성 후 댓글 리스트 갱신
            }
		}
	});
}

/* 댓글삭제버튼 */
function commentDel(cno){
	if(confirm("댓글을 삭제하시겠습니까?") == false )	{
		return;
	}
	$.ajax({
		type : "post",
		url  : "commentDel.jsp",
		data : 
		{
			cno     : cno
		},
		datatype : "html",
		success : function(result){
			alert("댓글이 삭제되었습니다.");
			loadComment();
		}
	});
}

var originalHTML = "";   // 댓글 내용의 HTML을 저장
var originalBtn  = "";   // 댓글 수정/삭제 버튼의 HTML을 저장

// 댓글 수정 함수
function commentUpdate(cno, no) {
    if (!confirm("댓글을 수정하시겠습니까?")) {
        return;
    }

    var rnote = $("#comment" + cno + " td:nth-child(2)").text().trim();  // 댓글 내용 추출 (두 번째 <td>)
    originalHTML = $("#comment" + cno + " td:nth-child(2)").html();      // 댓글 내용을 저장
    originalBtn = $("#comment" + cno + " td:nth-child(4)").html();       // 수정/삭제 버튼 영역 저장
    
    // 댓글을 textarea로 변경
    $("#comment" + cno + " td:nth-child(2)").html(
        "<textarea id='commentEdit" + cno + "' style='width:740px; height:80px; resize:none;'>" + rnote + "</textarea>"
    );
    
    // 버튼을 "완료" 및 "취소"로 변경
    $("#comment" + cno + " td:nth-child(4)").html(
        `<span class='reply_btn' onclick='commentUpdateSave(${cno}, ${no})' id='btnEdit'>완료</span> 
        <input type="reset" id="comment_reset" value="취소" onclick='commentCancel(${cno})'>`
    );
}

// 댓글 수정 취소 함수
function commentCancel(cno) {
    $("#comment" + cno + " td:nth-child(2)").html(originalHTML);   // 원래 댓글 내용 복구
    $("#comment" + cno + " td:nth-child(4)").html(originalBtn);    // 원래 버튼 복구
}

// 댓글 저장 함수
function commentUpdateSave(cno, no) {
    var rnote = $("#commentEdit" + cno).val();  // 수정된 댓글 내용 가져오기
    
    if(rnote == "") {
        alert("댓글 내용을 입력해주세요.");
        $("#commentEdit" + cno).focus();
        return;
    }
    
    $.ajax({
        type: "post",
        url: "commentModifyok.jsp",
        data: {
            no: no,      // 게시물 번호
            comment: rnote,   // 수정된 댓글 내용
            cno: cno     // 댓글 번호
        },
        datatype: "html",
        success: function(result) {
            alert("댓글이 수정되었습니다.");
            $("#comment" + cno + " td:nth-child(2)").html('<span>' + rnote + '</span>');  // 수정된 댓글 내용 표시
            $("#comment" + cno + " td:nth-child(4)").html(originalBtn);  // 수정 후 버튼 복구
        }
    });
}

/* 추천 테이블 */
function loadReco() 
{
    $.ajax({
        url: "loadReco.jsp",
        type: "get",
        data: { no: "<%= no %>" },
        success: function(data) 
        {
        	console.log(data);
            $(".reco").html(data);
        }
    });
}
function recoAdd(no, state) {
    $.ajax({
        url: "recoAdd.jsp",
        type: "post",
        data: { no: no, state: state },
        success: function() {
            loadReco();  // 추천 상태를 다시 로드
        }
    });
}

</script>
<section>
    <article>
        <div class="article_inner">
            <h2><%= boardName %>
			<a href="<%= path %>&nowPage=<%= nowPage %>&searchType=<%= searchType %>&searchValue=<%= searchValue %>">
				<button type="button" id="listBtn">글목록</button>
			</a>
            </h2>
            <div class="view_inner">
           		<%
			    if(!fname.equals("")) {
			        // 이미지 파일 확장자 체크
			        String[] imageExtensions = { "jpg", "jpeg", "png", "gif", "bmp" };
			        String fileExtension = fname.substring(fname.lastIndexOf(".") + 1).toLowerCase();
			        boolean isImage = false;
			
			        // 파일 확장자가 이미지인지 체크
			        for (String ext : imageExtensions) {
			            if (fileExtension.equals(ext)) {
			                isImage = true;
			                break;
			            }
			        }
			
			        // 이미지 파일일 경우 미리보기 제공
			        if(isImage){
		            %>
	            <div class="view_img">
		            <img id="preview" src="<%= request.getContextPath() %>/upload/<%= pname %>" alt="첨부된 이미지" style="max-width: 100%; height: auto;" />
            	</div>
		            <%
			        }
			    }
			    %>
            	<div class="view_content" style="width: <%= fname.equals("") ? "100%" : "50%" %>;">
            		<div class="icon-container">
						<div class="reco" style="width:30px; cursor:pointer;">
						</div>
						<%
						if(pname != null && !pname.equals("")){
							%>
						<a href="down.jsp?no=<%= no %>">
						<img style="width:30px;" src="https://img.icons8.com/?size=100&id=gElSR9wTv6aF&format=png&color=5D4037">
						</a>
							<%
						}
						%>
					</div>
            		<p style="font-size:26px; margin:10px 0;"><%= title %></p>
            		<%
					if(type.equals("R")){
					%>
					<div class="rating" id="starview">
						<input id="star5_view" name="starview" type="radio" value="5" <%= star.equals("5") ? "checked" : "" %> disabled /><label for="star5_view">★</label>
						<input id="star4_view" name="starview" type="radio" value="4" <%= star.equals("4") ? "checked" : "" %> disabled/><label for="star4_view">★</label>
						<input id="star3_view" name="starview" type="radio" value="3" <%= star.equals("3") ? "checked" : "" %> disabled/><label for="star3_view">★</label>
						<input id="star2_view" name="starview" type="radio" value="2" <%= star.equals("2") ? "checked" : "" %> disabled/><label for="star2_view">★</label>
						<input id="star1_view" name="starview" type="radio" value="1" <%= star.equals("1") ? "checked" : "" %> disabled/><label for="star1_view">★</label>
			        </div>
					<%
					}
					%>
					<div style="font-size:16px; margin-top:5px;">
						<div class="view_profil">
					    <% 
					    if(userPname != null && !userPname.isEmpty()) { 
					    %>
					        <!-- 프로필 이미지가 있을 경우 -->
					        <img id="previewProfil" class="circular-img" 
					             style="border:none; width:50px; height:50px;" 
					             src="<%= request.getContextPath() %>/upload/<%= userPname %>" alt="프로필 이미지" />
					    <% 
					    }else {
				    	%>
					        <!-- 기본 프로필 이미지 -->
					        <img id="previewProfil" class="circular-img" 
					             style="border:none; width:50px; height:50px;" 
					             src="https://img.icons8.com/?size=100&id=115346&format=png&color=000000" alt="기본 프로필 이미지">
					    <% 
					    } 
					    %>
						    <span><%= nick %></span>
						</div>
					&nbsp;
					<%= rdate %>&nbsp;
					<%
					if(!type.equals("N")){
					%>
					추천수&nbsp;<%= recoTotal %>&nbsp;
					<%
					}
					%>
					조회수&nbsp;<%= hit %>
					</div>
					<br>
					<%= content.replace("\n", "<br>") %>
					<!-- 댓글위치 -->
					<%
					if(!type.equals("N")){
					%>
					<div class="comment_inner">
						<form name="commentForm" method="post">
						<table>
							<tr>
								<td colspan="3">
									<input type="hidden" name="no" value="<%= no %>">
									<input type="hidden" name="nowPage" value="<%= nowPage%>">
									<input type="hidden" name="searchType" value="<%= searchType%>">
									<input type="hidden" name="searchValue" value="<%= searchValue%>">
									<input type="hidden" name="cno">
									<input type="text" name="comment" size="50">
								</td>
								<td>
									<button type="button" id="cBtn" onclick="submitComment();">저장</button>
								</td>
							</tr>
						</table>
						<!-- 댓글목록 출력 -->
						<div class="commentDiv"></div>	
						</form> 
					</div>
					<%
					}
					%>
            	</div>
				</div>
        </div>
    </article>
</section>
<%@ include file="../include/footer.jsp" %>