
SELECTION-SCREEN: FUNCTION KEY 1. "Muestra botón en parte superior

SELECTION-SCREEN BEGIN OF BLOCK b_1 WITH FRAME. "TITLE text-002.

PARAMETERS: p_floca TYPE localfile DEFAULT ''.
PARAMETERS: p_fserv TYPE localfile DEFAULT ''.
PARAMETERS: p_dloca TYPE localfile DEFAULT ''.
PARAMETERS: p_dserv TYPE rlgrap-filename DEFAULT ''.

SELECTION-SCREEN END OF BLOCK b_1.


AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_floca.
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
  "

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_fserv.
  CALL FUNCTION 'RFC_GET_LOCAL_SERVERS'
    TABLES
      hosts         = ltd_host
    EXCEPTIONS
      not_available = 1
      OTHERS        = 2.

  IF sy-subrc = 0.
*-Nombre del servidor a la estructura
    CLEAR lw_host.
    READ TABLE ltd_host INTO lw_host INDEX 1.
*-Obtengo el path
    CALL FUNCTION 'F4_DXFILENAME_TOPRECURSION'
      EXPORTING
        i_location_flag = lc_a
        i_server        = lw_host-name
        i_path          = gc_ruta
        filemask        = gs_filter  "'*.txt'
      IMPORTING
        o_location_flag = lc_ubicacion
        o_path          = lc_path
        abend_flag      = lc_abend
      EXCEPTIONS
        rfc_error       = 1
        error_with_gui  = 2
        OTHERS          = 3.
*-Si se obtiene un path
    IF sy-subrc    IS INITIAL AND
       NOT lc_path IS INITIAL AND
       lc_abend    IS INITIAL.
      "Devuelvo ruta al parametro de selección
      p_fserv = lc_path.
    ENDIF.

  ENDIF.


AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_dloca.
  CALL FUNCTION 'TMP_GUI_BROWSE_FOR_FOLDER'
    EXPORTING
      window_title    = 'Elija un directorio'
*     INITIAL_FOLDER  =
    IMPORTING
      selected_folder = p_dloca
    EXCEPTIONS
      cntl_error      = 1
      OTHERS          = 2.
  IF sy-subrc EQ 0.
  ENDIF.


AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_dserv.
* Se obtiene el directorio del servidor
  CALL FUNCTION '/SAPDMC/LSM_F4_SERVER_FILE'
    EXPORTING
      directory        = '/'
*     filemask         = 'Directorio'
    IMPORTING
      serverfile       = p_dserv
    EXCEPTIONS
      canceled_by_user = 1
      OTHERS           = 2.

  IF sy-subrc <> 0.
    MESSAGE 'Ocurrió un problema al seleccionar el directorio del servidor' TYPE 'S' DISPLAY LIKE 'E'.
  ENDIF.
