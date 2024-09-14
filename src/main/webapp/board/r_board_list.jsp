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
		sqlTotal = "select count(*) as total from board b  ";
	}
	sqlTotal += "inner join user u ";
	sqlTotal += "on b.uno = u.uno ";
	sqlTotal += " where b.state='E' ";
	if(!searchType.equals("")){
		if(searchType.equals("title")){
			sqlTotal += "and title like concat('%',?,'%') ";
		}else if(searchType.equals("nick")){
			sqlTotal += "and unick like concat('%',?,'%') ";
		}else{
			sqlTotal += "and content like concat('%',?,'%') ";
		}
	}
	psmtTotal = conn.prepareStatement(sqlTotal);
	if(!searchType.equals("")){
		psmtTotal.setString(1, searchValue);
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
		sql = "select nno,title,unick, " 
				+ " date_format(n.rdate,'%Y-%m-%d') as rdate,hit,top_yn "
				+ " from notice_board n "
				+ " inner join user u " 
				+ " on n.uno = u.uno "
				+ " where n.state='E' ";
	}else {
		sql = "select bno,title,unick,star, " 
			+ " (select count(*) from comment where bno = b.bno and state='E') as cnt, "
			+ " date_format(b.rdate,'%Y-%m-%d') as rdate,hit "
			+ " from board b "
			+ " inner join user u " 
			+ " on b.uno = u.uno "
			+ " where b.state='E' ";
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
	if(type.equals("N")){
		sql	+= "order by nno desc ";
	}else{
		sql	+= "order by bno desc ";
	}
	
	sql += "limit ?,?";
	psmt = conn.prepareStatement(sql);
	if(!searchType.equals("")){
		psmt.setString(1, searchValue);
		psmt.setInt(2, paging.getStart());
		psmt.setInt(3, paging.getPerPage());
	}else{
		psmt.setInt(1, paging.getStart());
		psmt.setInt(2, paging.getPerPage());
	}
	
	rs = psmt.executeQuery();
%>
<section>
    <article>
        <div class="article_inner">
            <h2>레시피게시판</h2>
            <div class="content_inner">
                <form action="r_board_list.jsp" method="get" style="padding-bottom:30px;">
                    <select name="searchType" id="sType">
						<option value="title" <%= searchType.equals("title") ? "selected" : "" %>>제목</option>
						<option value="content" <%= searchType.equals("content") ? "selected" : "" %>>내용</option>
						<option value="nick" <%= searchType.equals("nick") ? "selected" : "" %>>작성자</option>
					</select>
                    <input type="text" name="searchValue" id="search" value="<%= searchValue %>">
					<button type="button" id="sBtn">검색하기</button>
					<%
					if(session.getAttribute("loginUserNo") != null){
						%>
						<a href="write.jsp?type=<%= type %>" style="margin-left:110px;">
						<button type="button" id="wBtn">글쓰기</button>
						</a>
						<br>
						<%
					}
					%>
                </form>
				<table style="text-align:center;">
                    <thead>
						<tr>
							<th width="40px">번호</th>
							<th width="300px">제목</th>
							<th width="190px">난이도</th>
							<th width="150px">작성자</th>
							<th width="150px">작성일</th>
							<th width="60px">조회수</th>
						</tr>
					</thead>
					<tbody>
					<%
					int seqNo = total -((nowPage-1)*paging.getPerPage());
					while(rs.next()){
						String boardNo = "";
						if(type.equals("N")){
							boardNo = rs.getString("nno");
						}else{
							boardNo = rs.getString("bno");
						}
						%>
						<tr>
							<td><%= seqNo--%></td>
							<td><a href="view.jsp?type=<%= type %>&no=<%= boardNo %>&nowPage=<%= nowPage %>&searchType=<%= searchType %>&searchValue=<%= searchValue %>"><%= rs.getString("title") %></a></td>
							<%
							if(type.equals("R")){
								String starNum = rs.getString("star");
								%>
							<td>
							<div class="rating" id="star">
								<input id="star5" name="star" type="radio" value="5" onclick="return false;" <%= starNum.equals("5") ? "checked" : "" %>/><label for="star5">★</label>
								<input id="star4" name="star" type="radio" value="4" onclick="return false;" <%= starNum.equals("4") ? "checked" : "" %>/><label for="star4">★</label>
								<input id="star3" name="star" type="radio" value="3" onclick="return false;" <%= starNum.equals("3") ? "checked" : "" %>/><label for="star3">★</label>
								<input id="star2" name="star" type="radio" value="2" onclick="return false;" <%= starNum.equals("2") ? "checked" : "" %>/><label for="star2">★</label>
								<input id="star1" name="star" type="radio" value="1" onclick="return false;" <%= starNum.equals("1") ? "checked" : "" %>/><label for="star1">★</label>
					        </div>
							</td>
								<%
							}
							%>
							<td><%= rs.getString("unick") %></td>
							<td><%= rs.getString("rdate") %></td>
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
				<a href="list.jsp?nowPage=<%= paging.getStartPage()-1 %>&searchType=<%= searchType %>&searchValue=<%= searchValue %>">&lt;</a>
				<%
			}
			
			for(int i = paging.getStartPage(); i <= paging.getEndPage(); i++){
				if(nowPage == i){
					%>
					<a style="color:red; font-weight:bold;"><%= i %></a>
					<%
				}else{
					%>
						<a href="r_board_list.jsp?type=<%= type %>&nowPage=<%= i %>&searchType=<%= searchType %>&searchValue=<%= searchValue %>"><%= i %></a>
					<%
				}
			}
			
			if(paging.getLastPage() > paging.getEndPage()){
				//전체 페이지번호 보다 현재 종료 페이지 번호가 더 작은 경우
				%>
				<!-- 시작 페이지 번호 이후 페이지로 이동 13->21 -->
				<a href="r_board_list.jsp?type=<%= type %>&nowPage=<%= paging.getEndPage()+1 %>&searchType=<%= searchType %>&searchValue=<%= searchValue %>">&gt;</a>
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