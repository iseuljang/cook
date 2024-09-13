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
	-- Ȱ��ȭ E
	-- ��Ȱ��ȭ D
	state char DEFAULT 'E' NOT NULL COMMENT 'Ȱ��ȭ E
��Ȱ��ȭ D',
	-- �����Խ��� F
	-- �����ǰԽ��� R
	type char DEFAULT 'F' NOT NULL COMMENT '�����Խ��� F
�����ǰԽ��� R',
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
	-- Ȱ��ȭ E
	-- ��Ȱ��ȭ D
	state char DEFAULT 'E' NOT NULL COMMENT 'Ȱ��ȭ E
��Ȱ��ȭ D',
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
	-- E Ȱ��ȭ����
	-- D ��Ȱ��ȭ����
	state char DEFAULT 'E' NOT NULL COMMENT 'E Ȱ��ȭ����
D ��Ȱ��ȭ����',
	-- Y ��ܳ���
	-- N ��ܳ���x
	top_yn char DEFAULT 'N' NOT NULL COMMENT 'Y ��ܳ���
N ��ܳ���x',
	uno int NOT NULL,
	PRIMARY KEY (nno)
);


CREATE TABLE RECOMMEND
(
	rno int NOT NULL AUTO_INCREMENT,
	-- Ȱ��ȭ E
	-- ��Ȱ��ȭ D
	-- 
	state char DEFAULT 'D' NOT NULL COMMENT 'Ȱ��ȭ E
��Ȱ��ȭ D
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
	-- ������ A
	-- �Ϲ�ȸ�� U
	uauthor char DEFAULT 'U' NOT NULL COMMENT '������ A
�Ϲ�ȸ�� U',
	-- Ȱ��ȭ E
	-- ��Ȱ��ȭ D
	state char DEFAULT 'E' NOT NULL COMMENT 'Ȱ��ȭ E
��Ȱ��ȭ D',
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



