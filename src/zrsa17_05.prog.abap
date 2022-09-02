*&---------------------------------------------------------------------*
*& Report ZRSA17_05
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa17_05.

*DATA gv_d1 TYPE d.
*DATA gv_d2 TYPE sy-datum.
*
*WRITE: gv_d1, gv_d2.

*DATA: gv_c1    TYPE c LENGTH 1,
*      gv_c2    TYPE c,
*      gv_c3(1) TYPE c,
*      gv_c4.
*위의 네 가지 모두 한 자리의 C 타입을 선언하는 방식 -> Incomplete predefined data type

*DATA: gv_n1 TYPE n,
*      gv_n2 TYPE n LENGTH 2,
*      gv_i  TYPE i.
*
*WRITE : gv_n1, gv_n2, gv_i.
**i는 complete predefined data type / n은 incomplete predefined data type

*DATA gv_p TYPE p DECIMALS 2.
*WRITE gv_p.

*TYPES t_name TYPE c LENGTH 10.
**t_name이라는 타입을 생성. 변수가 아님. -> Local Data types.(현재의 프로그램에서만 사용할 때만 이용)
*
*DATA gv_name TYPE t_name.
*DATA gv_cname TYPE t_name.

*Local data type은 아래 방식으로 대체할 수 있음.
*DATA : gv_name  TYPE c LENGTH 10,
*       gv_cname LIKE gv_name.

*DATA gv_ecode TYPE c LENGTH 4 VALUE 'SYNC'.
*
*WRITE gv_ecode.
**바뀌지 않을 값을 DATA로 선언하면 변수에 다른 값이 들어갈 수도 있음.
*
*CONSTANTS gc_ecode TYPE c LENGTH 4 VALUE 'SYNC'.
*WRITE gc_ecode.
**gc_ecode = 'TEST'. -> ERROR : CONSTANTS로 선언했기 때문에 값을 바꿀 수 없음.

*Text Symbols
WRITE TEXT-t01. "Last Name
WRITE TEXT-t01. "Last Name

NEW-LINE.

WRITE 'New Name'(t02). "이렇게도 Text Symbol을 선언할 수 있음.
WRITE TEXT-t02.
WRITE 'New Name'(t02).
