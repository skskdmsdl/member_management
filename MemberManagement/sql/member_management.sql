--=============================================
--memberManagement
--=============================================
--관리자 계정으로 mem계정 생성
create user mem
identified by mem
default tablespace users;

grant connect, resource to mem;

--mem계정으로 member테이블 생성
show user;

create table member (
    member_id varchar2(15),
    password varchar2(300) not null,
    member_role char(1) default 'U' not null,
    email varchar2(100),
    enroll_date date default sysdate,
    constraint pk_member_id primary key(member_id),
    constraint ck_member_role check(member_role in ('U', 'A'))
);

--회원 추가
insert into member
values (
    'honggd', '1234', 'U', 'honggd@naver.com', default);

insert into member
values (
    'qwerty', '1234', 'U', 'qwerty@naver.com', default);

insert into member
values (
    'admin', '1234', 'A', 'admin@naver.com', default);

select * from member;
commit;


--평문으로 된 password 암호화 처리
update member
set password = '1ARVn2Auq2/WAqx2gNrL+q3RNjAzXpUfCXrzkA6d4Xa22yhRLy4AC50E+6UTPoscbo31nbOoq51gvkuXzJ6B2w==';
commit;



--게시판 테이블 생성
CREATE TABLE "MEM"."BOARD" 
   (	"BOARD_NO" NUMBER, 
	"BOARD_TITLE" VARCHAR2(50 BYTE) NOT NULL ENABLE, 
	"BOARD_WRITER" VARCHAR2(15 BYTE), 
	"BOARD_CONTENT" VARCHAR2(2000 BYTE) NOT NULL ENABLE, 
	"BOARD_ORIGINAL_FILENAME" VARCHAR2(100 BYTE), 
	"BOARD_RENAMED_FILENAME" VARCHAR2(100 BYTE), 
	"BOARD_DATE" DATE DEFAULT SYSDATE, 
	"BOARD_READCOUNT" NUMBER DEFAULT 0, 
	 CONSTRAINT "PK_BOARD_NO" PRIMARY KEY ("BOARD_NO")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE, 
	 CONSTRAINT "FK_BOARD_WRITER" FOREIGN KEY ("BOARD_WRITER")
	  REFERENCES "MEM"."MEMBER" ("MEMBER_ID") ON DELETE SET NULL ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;

COMMENT ON COLUMN "MEM"."BOARD"."BOARD_NO" IS '게시글번호';
COMMENT ON COLUMN "MEM"."BOARD"."BOARD_TITLE" IS '게시글제목';
COMMENT ON COLUMN "MEM"."BOARD"."BOARD_WRITER" IS '게시글작성자 아이디';
COMMENT ON COLUMN "MEM"."BOARD"."BOARD_CONTENT" IS '게시글내용';
COMMENT ON COLUMN "MEM"."BOARD"."BOARD_ORIGINAL_FILENAME" IS '첨부파일원래이름';
COMMENT ON COLUMN "MEM"."BOARD"."BOARD_RENAMED_FILENAME" IS '첨부파일변경이름';
COMMENT ON COLUMN "MEM"."BOARD"."BOARD_DATE" IS '게시글올린날짜';
COMMENT ON COLUMN "MEM"."BOARD"."BOARD_READCOUNT" IS '조회수';

--시퀀스 생성
CREATE SEQUENCE  "MEM"."SEQ_BOARD_NO"  MINVALUE 1 MAXVALUE 9999999999 INCREMENT BY 1 START WITH 196 NOCACHE  NOORDER  NOCYCLE ;

select * 
from board;

-- 댓글 구현
create table board_comment (
    board_comment_no number,
    board_comment_level number default 1, --댓글(1)/대댓글(2) 여부 판단
    board_comment_writer varchar2(15),
    board_comment_content varchar2(2000),
    board_ref number,                    --게시글 참조 번호
    board_comment_ref number,           -- 대댓글인 경우, 댓글 번호 | 댓글인 경우, null
    board_comment_date date default sysdate,
    constraints pk_board_comment primary key(board_comment_no),
    constraints fk_board_comment_writer foreign key (board_comment_writer) 
                                     references member(member_id)
                                     on delete set null,
    constraints fk_board_ref foreign key(board_ref)
                          references board(board_no)
                          on delete cascade,
    constraints fk_board_comment_ref foreign key(board_comment_ref)
                                   references board_comment(board_comment_no)
                                   on delete cascade
);

--시퀀스 생성
create sequence seq_board_comment;

commit;


