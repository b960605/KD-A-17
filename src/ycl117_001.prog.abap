*&---------------------------------------------------------------------*
*& Report YCL117_001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ycl117_001 MESSAGE-ID zmcsa17.

INCLUDE ycl117_001_top. " 전역 변수 선언
INCLUDE ycl117_001_c01. " ALV 관련 변수
INCLUDE ycl117_001_s01. " Selection Screen
INCLUDE ycl117_001_o01. " PBO
INCLUDE ycl117_001_i01. " PAI
INCLUDE ycl117_001_f01. " Subroutines

INITIALIZATION.
  "프로그램 실행시 가장 처음에 1회만 수행되는 이벤트 구간.
  PERFORM set_text.

AT SELECTION-SCREEN OUTPUT.
  "검색화면에서 화면이 출력되기 직전에 수행되는 구간.
  "주용도는 검색화면에 대한 제어 ( 특정 필드 숨김 또는 읽기전용 )

AT SELECTION-SCREEN.
  "검색화면에서 사용자가 특정 이벤트를 발생시켰을 때 수행되는 구간
  "상단의 Fuction Key 이벤트, 특정필드의 클릭, 엔터 등의 이벤트에서
  "입력값에 대한 점검, 실행 권한 점검 등을 위한 용도
  PERFORM select_data.

START-OF-SELECTION.
  "검색화면에서 실행버튼을 눌렀을 떄 수행되는 구간
  "주용도는 데이터 조회

end-of-SELECTION.
  " Start-of-selection이 끝나고 실행되는 구간
  " 주용도는 데이터 출력.
  CALL SCREEN '0100'.
