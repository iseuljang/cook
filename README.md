📖요리레시피게시판
-
다양한 요리 레시피를 쉽게 공유하고, 복잡한 과정없이 레시피를 검색하고 따라할 수 있도록 기획하였습니다.

<br>

## 목차
  - [개발기간](#개발기간)
  - [개발환경](#개발환경)
  - [페이지 설명](#페이지-설명)
<!--
  - [트러블 슈팅](#트러블-슈팅)
  - [개선할 부분](#개선할-부분)

-->

<br>

🗓️개발기간 
-
  + 2024.09.11 ~ 2024.10.02

    
<br>


🛠개발환경
-
  + HTML5, CSS3, JavaScript, Jquery-3.7.1, Apache Tomcat v9.0, MySQL v8.0.38
  + JDK 13.0.2, ERMaster


<br>

🖥페이지 설명
-
 - **ERD**
 ![ERD](https://github.com/iseuljang/cook/blob/main/%EC%B5%9C%EC%A2%85.jpg)

 - **메인 페이지**
   - 레시피 게시판에서 추천수가 많은 게시글 3개를 보여준다
 ![index](https://github.com/iseuljang/cook/blob/main/screen/index.jpg)

 - **회원가입**
   - 회원가입할 때 프로필 사진은 등록해도 되고, 등록하지 않아도 상관없다   
 ![join](https://github.com/iseuljang/cook/blob/main/screen/join.jpg)
   - 이미 사용중인 아이디는 사용할 수 없다
 ![join_idCheck](https://github.com/iseuljang/cook/blob/main/screen/join_idCheck.jpg)
   - 이미 사용중인 닉네임은 사용할 수 없다
 ![join_nickCheck](https://github.com/iseuljang/cook/blob/main/screen/join_nickCheck.jpg)

 - **로그인**
 ![login](https://github.com/iseuljang/cook/blob/main/screen/login.jpg)

 - **공지게시판**
 ![notice_board_list](https://github.com/iseuljang/cook/blob/main/screen/notice_board.jpg)

 - **공지게시판 글쓰기**
   - 공지게시판은 관리자만 등록할 수 있고 첨부파일을 등록할 수 없다
 ![notice_board_write](https://github.com/iseuljang/cook/blob/main/screen/notice_board_write.jpg)

 - **공지게시판 상세조회**
   - 댓글을 달 수 없다
   - 추천할 수 없다
 ![notice_board_view](https://github.com/iseuljang/cook/blob/main/screen/notice_board_view_noreco.jpg)

 - **자유게시판**
 ![free_board_list](https://github.com/iseuljang/cook/blob/main/screen/free_board_list.jpg)

 - **자유게시판(관리자)**
 ![free_board_list_admin](https://github.com/iseuljang/cook/blob/main/screen/free_board_admin.jpg)

 - **자유게시판 글쓰기**
   - 자유게시판과 레시피 게시판은 첨부파일을 등록할 수도 있고, 등록하지 않을 수도 있다  
 ![free_board_write](https://github.com/iseuljang/cook/blob/main/screen/free_board_write.jpg)

 - **자유게시판 상세조회(작성자)**
 ![free_board_view_user](https://github.com/iseuljang/cook/blob/main/screen/free_board_comment.jpg)

 - **자유게시판 상세조회(작성자 아닌경우)**
 ![free_board_view_other_user](https://github.com/iseuljang/cook/blob/main/screen/free_board_comment_other.jpg)

 - **자유게시판 상세조회(관리자)**
   - 관리자는 본인이 작성한 글이 아니더라도 삭제할 수 있다
 ![free_board_view_admin](https://github.com/iseuljang/cook/blob/main/screen/admin_free_board_view.jpg)
 
 - **레시피게시판**
 ![recipe_board_list](https://github.com/iseuljang/cook/blob/main/screen/recipe_board.jpg)
 
 - **레시피게시판 글쓰기**
 ![recipe_board_write](https://github.com/iseuljang/cook/blob/main/screen/recipe_board_write.jpg)

 - **레시피게시판 상세조회**
 ![recipe_board_view](https://github.com/iseuljang/cook/blob/main/screen/recipe_board_view_comment.jpg)

 - **댓글**
 ![comment_modify_delete_button](https://github.com/iseuljang/cook/blob/main/screen/comment_button_first.jpg)

 - **댓글 수정**
   - 댓글 수정시 기존 댓글 내용이 출력되는 span 태그를 textarea로 바꾸며 수정과 삭제버튼을 완료와 취소 버튼으로 변경한다
   - 기존 댓글내용과 수정, 삭제버튼을 저장하여 취소 버튼 클릭시 기존 모습으로 되돌아간다
 ![comment_modify](https://github.com/iseuljang/cook/blob/main/screen/comment_button_second.jpg)

 - **회원 프로필링크**
   - 로그인 후 프로필 사진 클릭시 메뉴바가 나타나 회원가입 때 기입한 정보를 확인하는 내정보보기 페이지로 이동하거나 로그아웃을 할 수 있다
 ![header_profil](https://github.com/iseuljang/cook/blob/main/screen/header_profil.jpg)
 
 - **관리자 프로필링크**
![header_profil](https://github.com/iseuljang/cook/blob/main/screen/myinfo_admin_add.jpg)

 - **내정보보기(회원)**
 ![myinfo_user](https://github.com/iseuljang/cook/blob/main/screen/myinfo_user.jpg)

 - **내정보보기(관리자)**
 ![myinfo_admin](https://github.com/iseuljang/cook/blob/main/screen/myinfo_admin.jpg)

- **신고게시판**
 ![complain_list](https://github.com/iseuljang/cook/blob/main/screen/complain_list.jpg)


<!--

<br>

💡트러블 슈팅
-
1️⃣ 
  - 문제 배경
    - &nbsp;
  - 해결 방법
    - &nbsp;
  - 코드 비교
    - &nbsp;
      - 수정전
      ```
      ```
      - 수정후
      ```
      ``` 
  - 해당 경험을 통해 알게 된 점
    - &nbsp;


<br>


📝개선할 부분
-
  - 
  - 
  - 
  - 
 
<br>

-->
     
<div align="right">
  
[목차로](#목차)

</div>

