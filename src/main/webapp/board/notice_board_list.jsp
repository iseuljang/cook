<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp" %>
<section>
<!-- 메뉴 오른쪽 게시판 상세 내용 부분 -->
<table id="inTable">
	<tr>
		<td>
			<h2>&nbsp;&nbsp;공지게시판</h2>
			<select name="sType" id="sType">
				<option value="T">제목</option>
				<option value="C">내용</option>
				<option value="U">작성자</option>
			</select>
			<input type="text" name="search" id="search">
			<button type="button" id="sBtn">검색하기</button>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<button type="button" id="wBtn">글쓰기</button>
			<br>
		</td>
	</tr>
	<tr>
		<td>
			<table width="100%" id="listTable">
				<tr>
					<th width="40px">번호</th>
					<th width="450px">제목</th>
					<th width="150px">작성일</th>
					<th width="60px">조회수</th>
				</tr>
				<tr>
					<td>1</td>
					<td><a href="view.jsp">제목~~!~~~!</a></td>
					<td>2024-09-11</td>
					<td>0</td>
				</tr>
				<tr>
					<td>2</td>
					<td><a href="view.jsp">제목~~!~~~!</a></td>
					<td>2024-09-11</td>
					<td>0</td>
				</tr>
				<tr>
					<td>3</td>
					<td><a href="view.jsp">제목~~!~~~!</a></td>
					<td>2024-09-11</td>
					<td>0</td>
				</tr>
				<tr>
					<td>4</td>
					<td><a href="view.jsp">제목~~!~~~!</a></td>
					<td>2024-09-11</td>
					<td>0</td>
				</tr>
				<tr>
					<td>5</td>
					<td><a href="view.jsp">제목~~!~~~!</a></td>
					<td>2024-09-11</td>
					<td>0</td>
				</tr>
				<tr>
					<td>6</td>
					<td><a href="view.jsp">제목~~!~~~!</a></td>
					<td>2024-09-11</td>
					<td>0</td>
				</tr>
				<tr>
					<td>7</td>
					<td><a href="view.jsp">제목~~!~~~!</a></td>
					<td>2024-09-11</td>
					<td>0</td>
				</tr>
				<tr>
					<td>8</td>
					<td><a href="view.jsp">제목~~!~~~!</a></td>
					<td>2024-09-11</td>
					<td>0</td>
				</tr>
				<tr>
					<td>9</td>
					<td><a href="view.jsp">제목~~!~~~!</a></td>
					<td>2024-09-11</td>
					<td>0</td>
				</tr>
				<tr>
					<td>10</td>
					<td><a href="view.jsp">제목~~!~~~!</a></td>
					<td>2024-09-11</td>
					<td>0</td>
				</tr>
			</table>
		</td>
	</tr>
	<!-- 페이징 영역 -->
	<tr>
		<td align="center">1 2 3 4 5 &gt;</td>
	</tr>
</table>
</section>
<%@ include file="../include/footer.jsp" %>