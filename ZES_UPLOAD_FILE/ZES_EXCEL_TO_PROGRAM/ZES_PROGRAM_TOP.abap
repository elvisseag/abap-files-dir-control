*&---------------------------------------------------------------------*
*&  Include           ZES_PROGRAM_TOP
*&---------------------------------------------------------------------*

TYPES:
  BEGIN OF gty_report,
    codigo  TYPE n LENGTH 8,
    centro  TYPE c LENGTH 20,
    correo  TYPE c LENGTH 50,
    mensaje TYPE c LENGTH 200,
  END OF gty_report.

DATA: gtd_data  TYPE STANDARD TABLE OF gty_report,
      gtd_excel TYPE STANDARD TABLE OF alsmex_tabline,
      gwa_excel LIKE LINE OF gtd_excel,
      gs_file   TYPE localfile.
