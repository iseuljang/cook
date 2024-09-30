<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp" %>
<%
request.setCharacterEncoding("UTF-8");

if(session.getAttribute("loginUserNo") == null || session.getAttribute("loginUserNo").equals("")){
	response.sendRedirect(request.getContextPath()+"/index.jsp");
	return;
}
String uno = (String)session.getAttribute("loginUserNo");

String searchType = request.getParameter("searchType");
String searchValue = request.getParameter("searchValue");

if(searchType == null || searchType.equals("null")){
	searchType = "";
}

if(searchValue == null || searchValue.equals("null")){
	searchValue = "";
}

String type = request.getParameter("type");
if(type == null || type.equals("")){
	type = "R";
}

String kind = request.getParameter("kind");
if(kind == null || kind.equals("")){
	kind = "M";
}


String board_type = "";

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
	sqlTotal = " select count(*) as total from recommend r "
			+ " inner join board b "
			+ " on b.bno = r.bno "
			+ " inner join user u "
			+ " on b.uno = u.uno "
			+ " where r.uno = ? and r.state='E'  ";
	
	
	if(!searchType.equals("")){
		if(searchType.equals("title")){
			sqlTotal += " and b.title like concat('%',?,'%') ";
		}else if(searchType.equals("nick")){
			sqlTotal += " and u.unick like concat('%',?,'%') ";
		}else{
			sqlTotal += " and b.content like concat('%',?,'%') ";
		}
	}
	
	psmtTotal = conn.prepareStatement(sqlTotal);
	psmtTotal.setString(1,uno);
	if(!searchType.equals("")){
		psmtTotal.setString(2, searchValue.replace("\"","&quot;"));
	}
	rsTotal = psmtTotal.executeQuery();
	
	int total = 0;
	if(rsTotal.next()){
		total = rsTotal.getInt("total");
	}
	
	PagingUtil paging = new PagingUtil(nowPage,total,5);
	
	//데이터 출력에 필요한 게시글 데이터 조회 쿼리 영역
	String sql = "";
	sql = "select bno,title,unick,star,b.state,type, " 
		+ " (select count(*) from comment where bno = b.bno and state='E') as cnt, "
		+ " (select count(*) from recommend where bno = b.bno and state='E') as rCount, "
		+ " (select count(*) from complaint where bno = b.bno and state='E') as cpTotal, "
		+ " date_format(b.rdate,'%Y.%m.%d') as rdate,hit "
		+ " from board b "
		+ " inner join user u " 
		+ " on b.uno = u.uno "
		+ " where bno in (select bno from recommend where uno = ? and state='E' ) ";
	
	if(!searchType.equals("")){
		if(searchType.equals("title")){
			sql += " and title like concat('%',?,'%') ";
		}else if(searchType.equals("nick")){
			sql += " and unick like concat('%',?,'%') ";
		}else{
			sql += " and content like concat('%',?,'%') ";
		}
	}
	
	sql	+= "order by bno desc ";
	
	sql += "limit ?,?";
	psmt = conn.prepareStatement(sql);
	psmt.setString(1,uno);
	if(!searchType.equals("")){
		psmt.setString(2, searchValue.replace("\"","&quot;"));
		psmt.setInt(3, paging.getStart());
		psmt.setInt(4, paging.getPerPage());
	}else{
		psmt.setInt(2, paging.getStart());
		psmt.setInt(3, paging.getPerPage());
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
			<h2>추천 목록</h2>
        	</div>
            <div class="search_inner">
                <form action="reco_list.jsp" method="get" name="searchFn" style="padding-bottom:30px;">
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
					</div>
                </form>
				<table style="text-align:center;">
                    <thead>
						<tr>
							<th width="40px">번호</th>
							<th width="490px">제목</th>
							<th width="150px">작성자</th>
							<th width="150px">작성일</th>
							<th width="50px">추천</th>
							<th width="50px">댓글</th>
							<th width="60px">조회수</th>
						</tr>
					</thead>
					<tbody>
					<%
					int seqNo = total -((nowPage-1)*paging.getPerPage());
					while(rs.next()){
						board_type = rs.getString("type");
						String boardNo = rs.getString("bno");
						%>
						<tr class="list_tr">
							<td><%= seqNo-- %></td>
							<td>
								<a style="color: <%= rs.getString("state").equals("D") ? "red" : "#5D4037" %>;
								text-decoration: <%= rs.getString("state").equals("D") ?  "line-through" : "none"%>;" 
								href="<%= request.getContextPath() %>/board/view.jsp?kind=<%= kind %>&type=<%= board_type %>&no=<%= boardNo %>&nowPage=<%= nowPage %>&searchType=<%= searchType %>&searchValue=<%= searchValue %>">
								<%= rs.getString("title") %>
								<%
								if(board_type.equals("R")){
									String starNum = rs.getString("star");
									/* out.println("Star value: " + starNum);  */
								%>
								<div class="rating" id="star<%= boardNo %>">
									<input id="star5_<%= boardNo %>" name="star<%= boardNo %>" type="radio" value="5" <%= starNum.equals("5") ? "checked" : "" %> disabled /><label for="star5_<%= boardNo %>">★</label>
									<input id="star4_<%= boardNo %>" name="star<%= boardNo %>" type="radio" value="4" <%= starNum.equals("4") ? "checked" : "" %> disabled/><label for="star4_<%= boardNo %>">★</label>
									<input id="star3_<%= boardNo %>" name="star<%= boardNo %>" type="radio" value="3" <%= starNum.equals("3") ? "checked" : "" %> disabled/><label for="star3_<%= boardNo %>">★</label>
									<input id="star2_<%= boardNo %>" name="star<%= boardNo %>" type="radio" value="2" <%= starNum.equals("2") ? "checked" : "" %> disabled/><label for="star2_<%= boardNo %>">★</label>
									<input id="star1_<%= boardNo %>" name="star<%= boardNo %>" type="radio" value="1" <%= starNum.equals("1") ? "checked" : "" %> disabled/><label for="star1_<%= boardNo %>">★</label>
						        </div>
								<%
								}
								%>
								</a>
							</td>
							<td><%= rs.getString("unick") %></td>
							<td><%= rs.getString("rdate") %></td>
							<td><%= rs.getString("rCount") %></td>
							<td><%= rs.getString("cnt") %></td>
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
				<a href="complain_list.jsp?type=<%= type %>&nowPage=<%= paging.getStartPage()-1 %>&searchType=<%= searchType %>&searchValue=<%= searchValue %>">&lt;</a>
				<%
			}
			
			for(int i = paging.getStartPage(); i <= paging.getEndPage(); i++){
				if(nowPage == i){
					%>
					<a style="color:red; font-weight:bold;"><%= i %></a>
					<%
				}else{
					%>
						<a href="complain_list.jsp?type=<%= type %>&nowPage=<%= i %>&searchType=<%= searchType %>&searchValue=<%= searchValue %>"><%= i %></a>
					<%
				}
			}
			
			if(paging.getLastPage() > paging.getEndPage()){
				//전체 페이지번호 보다 현재 종료 페이지 번호가 더 작은 경우
				%>
				<!-- 시작 페이지 번호 이후 페이지로 이동 13->21 -->
				<a href="complain_list.jsp?type=<%= type %>&nowPage=<%= paging.getEndPage()+1 %>&searchType=<%= searchType %>&searchValue=<%= searchValue %>">&gt;</a>
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