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


