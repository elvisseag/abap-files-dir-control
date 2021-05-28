REPORT zes_program.

* load a plain text file into a program

TYPES:
  BEGIN OF gty_data,
    campo TYPE char512,
  END OF gty_data.

DATA: gtd_data    TYPE STANDARD TABLE OF gty_data,
      gwa_data    TYPE gty_data,
      gs_filename TYPE rlgrap-filename.

DATA: ltd_file TYPE filetable,
      li_rc    TYPE i,
      lw_file  TYPE file_table.

PARAMETERS: p_floca TYPE localfile DEFAULT ''.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_floca.

  CLEAR: gs_filename.

  CALL METHOD cl_gui_frontend_services=>file_open_dialog
    EXPORTING
      window_title = 'Seleccionar archivo'
*     file_filter  = '(*.xls,*.xlsx)|*.xls*'
    CHANGING
      file_table   = ltd_file
      rc           = li_rc.
  IF sy-subrc EQ 0.
    READ TABLE ltd_file INTO lw_file INDEX 1.
    p_floca = lw_file-filename.
  ENDIF.

  gs_filename = p_floca.

  CALL FUNCTION 'WS_UPLOAD'
    EXPORTING
*   CODEPAGE                = ' '
      filename                = gs_filename
      filetype                = 'ASC' "'DAT'
*   HEADLEN                 = ' '
*   LINE_EXIT               = ' '
*   TRUNCLEN                = ' '
*   USER_FORM               = ' '
*   USER_PROG               = ' '
*   DAT_D_FORMAT            = ' '
* IMPORTING
*   FILELENGTH              =
    TABLES
      data_tab                = gtd_data
    EXCEPTIONS
      conversion_error        = 1
      file_open_error         = 2
      file_read_error         = 3
      invalid_type            = 4
      no_batch                = 5
      unknown_error           = 6
      invalid_table_width     = 7
      gui_refuse_filetransfer = 8
      customer_error          = 9
      no_authority            = 10
      OTHERS                  = 11.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

START-OF-SELECTION.

  LOOP AT gtd_data INTO gwa_data.
    WRITE: gwa_data-campo.
  ENDLOOP.

END-OF-SELECTION.