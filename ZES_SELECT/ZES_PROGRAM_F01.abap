
*&---------------------------------------------------------------------*
*&      Form  VALIDATE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM validate .

  CLEAR: gs_message.

  IF p_floca IS NOT INITIAL.
    PERFORM validate_local_file.
  ENDIF.

  IF p_fserv IS NOT INITIAL.
    PERFORM validate_server_file.
  ENDIF.

  IF p_dloca IS NOT INITIAL.
    PERFORM validate_local_dir.
  ENDIF.

  IF p_dserv IS NOT INITIAL.
    PERFORM validate_server_dir.
  ENDIF.

*    CONCATENATE 'Botón presionado. ' 'TEST' INTO gs_message.
*    MESSAGE gs_message TYPE 'S'.

ENDFORM.                    " VALIDATE


*&---------------------------------------------------------------------*
*&      Form  VALIDATE_LOCAL_FILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM validate_local_file .


*Validar si existe fichero local
  DATA: ls_file   TYPE string,
        ls_existe TYPE c.

  ls_file = p_floca.

  CALL METHOD cl_gui_frontend_services=>file_exist
    EXPORTING
      file                 = ls_file                " File to Check
    RECEIVING
      result               = ls_existe                " Result
    EXCEPTIONS
      cntl_error           = 1                " Control error
      error_no_gui         = 2                " Error: No GUI
      wrong_parameter      = 3                " Incorrect parameter
      not_supported_by_gui = 4                " GUI does not support this
      OTHERS               = 5.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  CLEAR: gwa_report.
  gwa_report-type    = 'Local File'.
  gwa_report-path    = p_floca.


  IF ls_existe IS INITIAL.
    gwa_report-message = 'Ruta no existe'.
  ELSE.
    gwa_report-message = 'Ruta válida'.
  ENDIF.

  APPEND gwa_report TO gtd_report.

ENDFORM.                    " VALIDATE_LOCAL_FILE
*&---------------------------------------------------------------------*
*&      Form  VALIDATE_SERVER_FILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM validate_server_file .

ENDFORM.                    " VALIDATE_SERVER_FILE
*&---------------------------------------------------------------------*
*&      Form  VALIDATE_LOCAL_DIR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM validate_local_dir .

*Validar si existe directorio local

  DATA: ls_directory TYPE string,
        ls_existe    TYPE c.

  ls_directory = p_dloca.

  CALL METHOD cl_gui_frontend_services=>directory_exist
    EXPORTING
      directory            = ls_directory " Directory name
    RECEIVING
      result               = ls_existe    " Result
    EXCEPTIONS
      cntl_error           = 1
      error_no_gui         = 2
      wrong_parameter      = 3
      not_supported_by_gui = 4
      OTHERS               = 5.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.


  CLEAR: gwa_report.
  gwa_report-type    = 'Local Dir.'.
  gwa_report-path    = p_dloca.

  IF ls_existe IS INITIAL.
    gwa_report-message = 'Ruta no existe'.
  ELSE.
    gwa_report-message = 'Ruta válida'.
  ENDIF.

  APPEND gwa_report TO gtd_report.

ENDFORM.                    " VALIDATE_LOCAL_DIR
*&---------------------------------------------------------------------*
*&      Form  VALIDATE_SERVER_DIR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM validate_server_dir .

ENDFORM.                    " VALIDATE_SERVER_DIR
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM display_alv .

  PERFORM add_fieldcat_grid:
   TABLES gtd_fieldcat USING 'GTD_REPORT' 'TYPE'    'Tipo'    'Tipo'    'Tipo'    '10',
   TABLES gtd_fieldcat USING 'GTD_REPORT' 'PATH'    'Ruta'    'Ruta'    'Ruta'    '60',
   TABLES gtd_fieldcat USING 'GTD_REPORT' 'MESSAGE' 'Mensaje' 'Mensaje' 'Mensaje' '40'.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      it_fieldcat   = gtd_fieldcat[]
      i_grid_title  = 'Results'
    TABLES
      t_outtab      = gtd_report[]
    EXCEPTIONS
      program_error = 1
      OTHERS        = 2.

ENDFORM.                    " DISPLAY_ALV

*&---------------------------------------------------------------------*
*&      Form  add_fieldcat
*&---------------------------------------------------------------------*
FORM add_fieldcat_grid TABLES gtd_fieldcat STRUCTURE gwa_fieldcat
                       USING  p_tabname
                              p_fieldname
                              p_seltext_l
                              p_seltext_m
                              p_seltext_s
                              p_outputlen.

  FIELD-SYMBOLS <lwa_fieldcat> LIKE LINE OF gtd_fieldcat.

  APPEND INITIAL LINE TO gtd_fieldcat ASSIGNING <lwa_fieldcat>.
  <lwa_fieldcat>-tabname   = p_tabname.
  <lwa_fieldcat>-fieldname = p_fieldname.
  <lwa_fieldcat>-seltext_l = p_seltext_l.
  <lwa_fieldcat>-seltext_m = p_seltext_m.
  <lwa_fieldcat>-seltext_s = p_seltext_s.
  <lwa_fieldcat>-outputlen = p_outputlen.

ENDFORM.                    " ADD_FIELDCAT