<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="include/header.jsp" %>
<%
Connection conn = null;			
PreparedStatement psmt = null;	
ResultSet rs = null;	

String pname = "";
String fname = "";
String bno = "";
String star = "";
String title = "";
String count = "";


int nowPage = 1;
String type = "R";

String sql = "";
String sqlFile = "";

PreparedStatement psmtFile = null;	
ResultSet rsFile = null;	
try{
	conn = DBConn.conn();
	sql = "select b.*,"
	+ " (select count(*) from recommend where bno = b.bno and state='E') as count "
	+ " from board b "
	+ " inner join user u "
	+ " on b.uno = u.uno "
	+ " where type='R' "
	+ " order by count desc limit 0,3 ";
	
	psmt = conn.prepareStatement(sql); //사용할 쿼리 등록
		
	rs = psmt.executeQuery();
%>
<!-- 메뉴 오른쪽 게시판 상세 내용 부분 -->
<section>
<article>
    <div class="article_inner">
        <h2>인기 레시피</h2>
        <div class="content_inner">
			<div id="indexDiv">
<%
	while(rs.next()){
		bno = rs.getString("bno");
		star = rs.getString("star");
		title = rs.getString("title");
		count = rs.getString("count");
		sqlFile = "select pname, fname from attach where bno=?";
		
		psmtFile = conn.prepareStatement(sqlFile); //사용할 쿼리 등록
		psmtFile.setString(1, bno);
		rsFile = psmtFile.executeQuery();
		
		if(rsFile.next()){
			pname = rsFile.getString("pname");
			fname = rsFile.getString("fname");
		}
		
		if(pname != null && !pname.isEmpty()) { 
        %>
	<div id="recoDiv" style="text-align: center;">
	    <a href="<%= request.getContextPath() %>/board/view.jsp?type=R&nowPage=1&no=<%= bno %>">
        <img id="preview" style="border:none; width:180px; max-height:180px; border-radius:5px;" 
        src="<%= request.getContextPath() %>/upload/<%= pname %>" alt="첨부된 이미지" style="max-width: 100%; height: auto;" />
        <div style="font-weight: bold; margin-top: 10px;">
        <%= title %>
        </div>
        <div class="rating" id="star_reco_<%= bno %>" style="margin-top: 5px;">
			<input id="star5_reco_<%= bno %>" name="star_reco_<%= bno %>" type="radio" value="5" <%= star.equals("5") ? "checked" : "" %> disabled />
			<label for="star5_reco_<%= bno %>">★</label>
			<input id="star4_reco_<%= bno %>" name="star_reco_<%= bno %>" type="radio" value="4" <%= star.equals("4") ? "checked" : "" %> disabled/>
			<label for="star4_reco_<%= bno %>">★</label>
			<input id="star3_reco_<%= bno %>" name="star_reco_<%= bno %>" type="radio" value="3" <%= star.equals("3") ? "checked" : "" %> disabled/>
			<label for="star3_reco_<%= bno %>">★</label>
			<input id="star2_reco_<%= bno %>" name="star_reco_<%= bno %>" type="radio" value="2" <%= star.equals("2") ? "checked" : "" %> disabled/>
			<label for="star2_reco_<%= bno %>">★</label>
			<input id="star1_reco_<%= bno %>" name="star_reco_<%= bno %>" type="radio" value="1" <%= star.equals("1") ? "checked" : "" %> disabled/>
			<label for="star1_reco_<%= bno %>">★</label>
        </div>
		</a>
	</div>
        <%
        }
	}
	
	
}catch(Exception e){
	e.printStackTrace();
	out.print(e.getMessage());
}finally{
	DBConn.close(rs, psmt, null);
	DBConn.close(rsFile, psmtFile, conn);
}
%>
				</div>
            </div>
        </div>
    </article>
</section>
<%@ include file="../include/footer.jsp" %>