<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp" %>
<div class="container">
	<!-- 메뉴 오른쪽 게시판 상세 내용 부분 -->
<section>
		<table id="inTable">
			<tr>
				<td>
					<h2>&nbsp;&nbsp;레시피게시판
					<a href="r_board_list.jsp">
						<button type="button" id="listBtn">글목록</button>
					</a>
					</h2>
				</td>
			</tr>
			<tr>
				<td>
					<table width="100%" id="listTable">
						<tr>
							<th width="90px" align="right">제목&nbsp;</th>
							<td id="viewTd">브라우니 만들기</td>
						</tr>
						<tr>
							<th align="right">난이도&nbsp;</th>
							<td id="viewTd">☆☆☆☆☆</td>
						</tr>
						<tr>
							<th align="right">작성자&nbsp;</th>
							<td id="viewTd">디저트매니아</td>
						</tr>
						<tr>
							<th align="right">작성일&nbsp;</th>
							<td id="viewTd">2024-09-11 15:12:00</td>
						</tr>
						<tr>
							<th align="right">내용&nbsp;</th>
							<td id="viewTd">
							재료 : 물, 브라우니 믹스, ~~~~~
							방법 : 물이랑 브라우니 믹스 섞어서 전자레인지~~~~
							</td>
						</tr>
						<tr>
							<td colspan="2" align="center">
								<button type="button" id="likeBtn">&#129505;</button>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td>
					<table>
						<tr>
							<td>작성자이름</td>
							<td><input type="text" name="comment" style="width:100%;"></td>
							<td><button type="button" id="cBtn">등록</button></td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
</section>
</div>
<%@ include file="../include/footer.jsp" %>