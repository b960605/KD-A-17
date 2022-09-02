*&---------------------------------------------------------------------*
*& Report ZRSA17_15
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa17_15.

DATA: BEGIN OF gs_std,
        stdno    TYPE n LENGTH 8,
        sname    TYPE c LENGTH 40,
        gender   TYPE c LENGTH 1,
        gender_t TYPE c LENGTH 10,
      END OF gs_std.

DATA gt_std LIKE TABLE OF gs_std. "Internal Table의 initial value는 아무것도 없는 상태.

gs_std-stdno = '20220001'.
gs_std-sname = 'Kang'.
gs_std-gender = 'M'.
APPEND gs_std TO gt_std.
CLEAR gs_std.

gs_std-stdno = '20220002'.
gs_std-gender = 'F'.
gs_std-sname = 'HAN'.
APPEND gs_std TO gt_std.
CLEAR gs_std.

LOOP AT gt_std INTO gs_std.
*  gs_std-gender_t = 'Male'(t01).
  CASE gs_std-gender.
    WHEN 'M'.
      gs_std-gender_t = 'Male'.
    WHEN 'F'.
      gs_std-gender_t = 'Female'.
    WHEN OTHERS.
  ENDCASE.
  MODIFY gt_std FROM gs_std."뒤에 index sy-tabix 가 생략된 형태라고 볼 수 있음.
  CLEAR gs_std.
ENDLOOP.

*LOOP AT gt_std INTO gs_std. "테이블에 있는 것들을 하나씩 반복해서 gs_std에 넣는다.
*  WRITE: sy-tabix, gs_std-stdno, gs_std-sname, gs_std-gender.
*  NEW-LINE.
*  CLEAR gs_std.
*ENDLOOP.
*WRITE:/ sy-tabix, gs_std-stdno, gs_std-sname, gs_std-gender.  "sy-tabix는 반복될 때마다 1씩 증가하는 시스템 변수.

cl_demo_output=>display_data( gt_std ). "Class=>Static Method(  ).

*gs_std-stdno = '20220002'. " 기존 값을 지우고 올라가게 됨. 스트럭쳐 변수이기 때문에 하나만 들어감

CLEAR gs_std.
*READ TABLE gt_std INDEX 1 INTO gs_std.
READ TABLE gt_std WITH KEY stdno = '20220001' "read table은 structure variable에 담기 떄문에 딱 한 건만 뽑아올 수 있음.
*                           gender = 'M' "추가적으로 옵션을 더 붙일 수 있음. 공백으로 연결하지만 무조건 두 조건은 and로 이어짐.
INTO gs_std.
