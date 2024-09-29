<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp" %>
<%
request.setCharacterEncoding("UTF-8");
String searchType = request.getParameter("searchType");
String searchValue = request.getParameter("searchValue");

if(searchType == null || searchType.equals("null")){
	searchType = "";
}

if(searchValue == null || searchValue.equals("null")){
	searchValue = "";
}

//게시판 종류 :: N 공지게시판, F 자유게시판, R 레시피 게시판
String type = request.getParameter("type");
if(type == null || type.equals("")){
	type = "F";
}


int nowPage = 1;

if(request.getParameter("nowPage") != null){
	//하단에 다른 페이지 번호 클릭시
	nowPage = Integer.parseInt(request.getParameter("nowPage"));
}

Connection conn = null;			
PreparedStatement psmt = null;	
ResultSet rs = null;	

PreparedStatement psmtTotal = null;	//SQL 등록 및 실행. 보안이 더 좋음!
ResultSet rsTotal = null;
//try 영역
try{
	//DB 연결후 sql 실행 후 처리 작성 영역
	conn = DBConn.conn();
	
	//페이징에 필요한 게시글 전체 갯수 쿼리 영역
	String sqlTotal = "";
	if(type.equals("N")){
		sqlTotal = "select count(*) as total from notice_board b  ";
	}else {
		sqlTotal = "select count(*) as total from board b ";
	}
	sqlTotal += "inner join user u ";
	sqlTotal += "on b.uno = u.uno ";
	if(session.getAttribute("loginUserLevel") != null && session.getAttribute("loginUserLevel").equals("A")){
		sqlTotal += " where (b.state='E' or b.state='D') ";
	}else{
		sqlTotal += " where b.state='E' ";
	}
	if(!searchType.equals("")){
		if(searchType.equals("title")){
			sqlTotal += "and title like concat('%',?,'%') ";
		}else if(searchType.equals("nick")){
			sqlTotal += "and unick like concat('%',?,'%') ";
		}else{
			sqlTotal += "and content like concat('%',?,'%') ";
		}
	}
	
	if(type.equals("F")){
		sqlTotal += " and type='F' ";
	}else if(type.equals("R")){
		sqlTotal += " and type='R' ";
	}
	
	psmtTotal = conn.prepareStatement(sqlTotal);
	if(!searchType.equals("")){
		psmtTotal.setString(1, searchValue.replace("\"","&quot;"));
	}
	rsTotal = psmtTotal.executeQuery();
	
	int total = 0;
	if(rsTotal.next()){
		total = rsTotal.getInt("total");
	}
	
	PagingUtil paging = new PagingUtil(nowPage,total,5);
	
	//데이터 출력에 필요한 게시글 데이터 조회 쿼리 영역
	String sql = "";
	if(type.equals("N")){
		sql = "select nno,title,unick,b.state, " 
				+ " date_format(b.rdate,'%Y.%m.%d') as rdate,hit,top_yn "
				+ " from notice_board b "
				+ " inner join user u " 
				+ " on b.uno = u.uno ";
	}else {
		sql = "select bno,title,unick,star,b.state, " 
			+ " (select count(*) from comment where bno = b.bno and state='E') as cnt, "
			+ " (select count(*) from recommend where bno = b.bno and state='E') as rCount, "
			+ " (select count(*) from complaint where bno = b.bno and state='E') as cpTotal, "
			+ " date_format(b.rdate,'%Y.%m.%d') as rdate,hit "
			+ " from board b "
			+ " inner join user u " 
			+ " on b.uno = u.uno ";
	}
	
	if(session.getAttribute("loginUserLevel") != null && session.getAttribute("loginUserLevel").equals("A")){
		sql += " where (b.state='E' or b.state='D') ";
	}else{
		sql += " where b.state='E' ";
	}
	
	if(!searchType.equals("")){
		if(searchType.equals("title")){
			sql += "and title like concat('%',?,'%') ";
		}else if(searchType.equals("nick")){
			sql += "and unick like concat('%',?,'%') ";
		}else{
			sql += "and content like concat('%',?,'%') ";
		}
	}
	if(type.equals("F")){
		sql += " and type='F' ";
	}else if(type.equals("R")){
		sql += " and type='R' ";
	}
	
	if(type.equals("N")){
		sql	+= "order by top_yn desc, nno desc ";
	}else{
		sql	+= "order by bno desc ";
	}
	
	sql += "limit ?,?";
	psmt = conn.prepareStatement(sql);
	if(!searchType.equals("")){
		psmt.setString(1, searchValue.replace("\"","&quot;"));
		psmt.setInt(2, paging.getStart());
		psmt.setInt(3, paging.getPerPage());
	}else{
		psmt.setInt(1, paging.getStart());
		psmt.setInt(2, paging.getPerPage());
	}
	
	rs = psmt.executeQuery();
%>
<script>
window.onload = function(){
	$("#search").keyup(function(event){
		if(event.keyCode == 13)	{	
			//Enter문자가 눌려짐. keyCode 아스키코드. 13이 enter 
			document.searchFn.submit();
		}
	});
	
	
	$("#search").on('keyup',function(){
		if($(this).val().length > 0){
			$("#clearBtn").css("display","inline");
		}else{
			$("#clearBtn").css("display","none");
		}
	});
	
	$("#clearBtn").on('click',function(){
	    $("#search").val('');  // 올바른 코드
	    $(this).css("display","none");
	});
	
	
	$(".list_tr").mouseover(function(event){
		/* $(this).css('background-color','#EEE'); */
		$(this).css('background-color','#FFFBEC');
	})
	.mouseout(function(event){
		$(this).css('background-color','white');
	});
}


</script>
<section>
    <article>
        <div class="board_inner">
        	<div class="search_title">
       	<%
		if(type.equals("N")){
			%><h2>공지게시판</h2><%
		}else if(type.equals("F")){
			%><h2>자유게시판</h2><%
		}else{
			%><h2>레시피게시판</h2><%
		}
		%>
        	</div>
            <div class="search_inner">
                <form action="board_list.jsp" method="get" name="searchFn" style="padding-bottom:30px;">
                    <input type="hidden" name="type" value="<%= type%>">
                    <div class="search-wrapper">
	                    <select name="searchType" id="sType">
							<option value="title" selected <%= searchType.equals("title") ? "selected" : "" %>>제목</option>
							<option value="content" <%= searchType.equals("content") ? "selected" : "" %>>내용</option>
							<option value="nick" <%= searchType.equals("nick") ? "selected" : "" %>>작성자</option>
						</select>
						<div class="input-container" id="seach-container"
						style="box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
					    background-color: white;
					    border-radius: 40px;
					    width:60%;
					    ">
	                        <i class="fas fa-search" id="searchIcon"></i>
		                    <input type="text" name="searchValue" id="search" placeholder="검색" value="<%= searchValue %>">
		                    <i class="fas fa-times" id="clearBtn"></i>
	                    </div>
						<%
						if(session.getAttribute("loginUserNo") != null){
							if(!type.equals("N")){
								%>
								<a href="write.jsp?type=<%= type %>" style="margin-left:110px;">
								<button type="button" id="wBtn">글쓰기</button>
								</a>
								<br>
								<%
							}else if(session.getAttribute("loginUserLevel").equals("A")){
								%>
								<a href="write.jsp?type=<%= type %>" style="margin-left:110px;">
								<button type="button" id="wBtn">글쓰기</button>
								</a>
								<br>
								<%
							}
						}
						%>
					</div>
                </form>
				<table style="text-align:center;">
                    <thead>
						<tr>
							<th width="40px">번호</th>
							<th width="<%= type.equals("R") ? "250px" : "490px" %>">제목</th>
							<%
							if(type.equals("R")){
							%>
							<th width="190px">난이도</th>
							<%
							}
							%>
							<th width="150px">작성자</th>
							<th width="150px">작성일</th>
							<%
							if(!type.equals("N")){
							%>
							<th width="50px">추천</th>
							<th width="50px">댓글</th>
							<%
							}
							%>
							<th width="60px">조회수</th>
						</tr>
					</thead>
					<tbody>
					<%
					int seqNo = total -((nowPage-1)*paging.getPerPage());
					while(rs.next()){
						int cpTotal = 0;
						String boardNo = "";
						int cnt = 0;
						if(type.equals("N")){
							boardNo = rs.getString("nno");
						}else{
							boardNo = rs.getString("bno");
							cpTotal = rs.getInt("cpTotal");
							cnt = rs.getInt("cnt");
						}
						%>
						<tr class="list_tr">
						<%
						if(type.equals("N") && rs.getString("top_yn").equals("Y")){
							%>
							<!-- <th>공지</th> -->
							<th>★</th>
							<%
							seqNo--;
						}else{
							%>
							<td><%= seqNo-- %></td>
							<%
						}
						 %>
							<td>
								<a style="color: <%= rs.getString("state").equals("D") ? "red" : "#5D4037" %>;
								text-decoration: <%= rs.getString("state").equals("D") ?  "line-through" : "none"%>;" 
								href="view.jsp?type=<%= type %>&no=<%= boardNo %>&nowPage=<%= nowPage %>&searchType=<%= searchType %>&searchValue=<%= searchValue %>">
								<%= rs.getString("title") %>
								<%
								if(cpTotal > 0){
									%><span style="color:red; font-size:16px;">[ 신고 <%= cpTotal %> ]</span><%
								}
								%>
								</a>
							</td>
							<%
							if(type.equals("R")){
								String starNum = rs.getString("star");
								/* out.println("Star value: " + starNum);  */
								%>
							<td>
							<div class="rating" id="star<%= boardNo %>">
								<input id="star5_<%= boardNo %>" name="star<%= boardNo %>" type="radio" value="5" <%= starNum.equals("5") ? "checked" : "" %> disabled /><label for="star5_<%= boardNo %>">★</label>
								<input id="star4_<%= boardNo %>" name="star<%= boardNo %>" type="radio" value="4" <%= starNum.equals("4") ? "checked" : "" %> disabled/><label for="star4_<%= boardNo %>">★</label>
								<input id="star3_<%= boardNo %>" name="star<%= boardNo %>" type="radio" value="3" <%= starNum.equals("3") ? "checked" : "" %> disabled/><label for="star3_<%= boardNo %>">★</label>
								<input id="star2_<%= boardNo %>" name="star<%= boardNo %>" type="radio" value="2" <%= starNum.equals("2") ? "checked" : "" %> disabled/><label for="star2_<%= boardNo %>">★</label>
								<input id="star1_<%= boardNo %>" name="star<%= boardNo %>" type="radio" value="1" <%= starNum.equals("1") ? "checked" : "" %> disabled/><label for="star1_<%= boardNo %>">★</label>
					        </div>
							</td>
								<%
							}
							%>
							<td><%= rs.getString("unick") %></td>
							<td><%= rs.getString("rdate") %></td>
							<%
							if(!type.equals("N")){
							%>
							<td><%= rs.getString("rCount") %></td>
							<td><%= rs.getString("cnt") %></td>
							<%
							}
							%>
							<td><%= rs.getString("hit") %></td>
						</tr>
						<%
					}
					%>
					</tbody>
				</table>
			</div>
			<!-- 페이징 영역 -->
            <div class="paging_inner">
           	<%
			if(paging.getStartPage() > 1){
				//시작페이지가 1보다 큰 경우 이전 페이지 존재
				%>
				<!-- 시작 페이지 번호 이전 페이지로 이동 13->10 -->
				<a href="board_list.jsp?type=<%= type %>&nowPage=<%= paging.getStartPage()-1 %>&searchType=<%= searchType %>&searchValue=<%= searchValue %>">
					<img style="width:25px; " src="https://img.icons8.com/?size=100&id=LeIi2nYOolQt&format=png&color=5D4037">
				</a>
				<%
			}
			
			for(int i = paging.getStartPage(); i <= paging.getEndPage(); i++){
				if(nowPage == i){
					%>
					<a style="color:red; font-weight:bold;"><%= i %></a>
					<%
				}else{
					%>
					<a href="board_list.jsp?type=<%= type %>&nowPage=<%= i %>&searchType=<%= searchType %>&searchValue=<%= searchValue %>"><%= i %></a>
					<%
				}
			}
			
			if(paging.getLastPage() > paging.getEndPage()){
				//전체 페이지번호 보다 현재 종료 페이지 번호가 더 작은 경우
				%>
				<!-- 시작 페이지 번호 이후 페이지로 이동 13->21 -->
				<a href="board_list.jsp?type=<%= type %>&nowPage=<%= paging.getEndPage()+1 %>&searchType=<%= searchType %>&searchValue=<%= searchValue %>">
					<img style="width:25px; " src="https://img.icons8.com/?size=100&id=4r5HpCBBbNn8&format=png&color=5D4037">
				</a>
				<%
			}
			%>
            </div>
        </div>
    </article>
</section>
<%
}catch(Exception e){
	e.printStackTrace();
	out.print(e.getMessage());
}finally{
	DBConn.close(rsTotal, psmtTotal, null);
	DBConn.close(rs, psmt, conn);
}
%>
<%@ include file="../include/footer.jsp" %>