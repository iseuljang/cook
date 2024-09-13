SET SESSION FOREIGN_KEY_CHECKS=0;

/* Drop Tables */

DROP TABLE IF EXISTS COMMENT;
DROP TABLE IF EXISTS RECOMMEND;
DROP TABLE IF EXISTS BOARD;
DROP TABLE IF EXISTS NOTICE_BOARD;
DROP TABLE IF EXISTS USER;




/* Create Tables */

CREATE TABLE BOARD
(
	bno int NOT NULL AUTO_INCREMENT,
	title varchar(100) NOT NULL,
	content text NOT NULL,
	rdate timestamp DEFAULT now() NOT NULL,
	hit int DEFAULT 0 NOT NULL,
	-- 활성화 E
	-- 비활성화 D
	state char DEFAULT 'E' NOT NULL COMMENT '활성화 E
비활성화 D',
	-- 자유게시판 F
	-- 레시피게시판 R
	type char DEFAULT 'F' NOT NULL COMMENT '자유게시판 F
레시피게시판 R',
	star int,
	filename text,
	uno int NOT NULL,
	PRIMARY KEY (bno)
);


CREATE TABLE COMMENT
(
	cno int NOT NULL AUTO_INCREMENT,
	content text NOT NULL,
	rdate timestamp DEFAULT now() NOT NULL,
	-- 활성화 E
	-- 비활성화 D
	state char DEFAULT 'E' NOT NULL COMMENT '활성화 E
비활성화 D',
	bno int NOT NULL,
	PRIMARY KEY (cno)
);


CREATE TABLE NOTICE_BOARD
(
	nno int NOT NULL AUTO_INCREMENT,
	title varchar(200) NOT NULL,
	content text NOT NULL,
	rdate timestamp DEFAULT now() NOT NULL,
	hit int DEFAULT 0 NOT NULL,
	-- E 활성화상태
	-- D 비활성화상태
	state char DEFAULT 'E' NOT NULL COMMENT 'E 활성화상태
D 비활성화상태',
	-- Y 상단노출
	-- N 상단노출x
	top_yn char DEFAULT 'N' NOT NULL COMMENT 'Y 상단노출
N 상단노출x',
	uno int NOT NULL,
	PRIMARY KEY (nno)
);


CREATE TABLE RECOMMEND
(
	rno int NOT NULL AUTO_INCREMENT,
	-- 활성화 E
	-- 비활성화 D
	-- 
	state char DEFAULT 'D' NOT NULL COMMENT '활성화 E
비활성화 D
',
	uno int NOT NULL,
	bno int NOT NULL,
	PRIMARY KEY (rno)
);


CREATE TABLE USER
(
	uno int NOT NULL AUTO_INCREMENT,
	uid varchar(100) NOT NULL,
	upw varchar(255) NOT NULL,
	uname varchar(30) NOT NULL,
	uemail varchar(40) NOT NULL,
	unick varchar(50) NOT NULL,
	rdate timestamp DEFAULT now() NOT NULL,
	-- 관리자 A
	-- 일반회원 U
	uauthor char DEFAULT 'U' NOT NULL COMMENT '관리자 A
일반회원 U',
	-- 활성화 E
	-- 비활성화 D
	state char DEFAULT 'E' NOT NULL COMMENT '활성화 E
비활성화 D',
	PRIMARY KEY (uno),
	UNIQUE (uid)
);



/* Create Foreign Keys */

ALTER TABLE COMMENT
	ADD FOREIGN KEY (bno)
	REFERENCES BOARD (bno)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE RECOMMEND
	ADD FOREIGN KEY (bno)
	REFERENCES BOARD (bno)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE BOARD
	ADD FOREIGN KEY (uno)
	REFERENCES USER (uno)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE NOTICE_BOARD
	ADD FOREIGN KEY (uno)
	REFERENCES USER (uno)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;


ALTER TABLE RECOMMEND
	ADD FOREIGN KEY (uno)
	REFERENCES USER (uno)
	ON UPDATE RESTRICT
	ON DELETE RESTRICT
;



