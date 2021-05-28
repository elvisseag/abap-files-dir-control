*&---------------------------------------------------------------------*
*&  Include           ZES_PROGRAM_SEL
*&---------------------------------------------------------------------*

" Para selección del archivo local
DATA: ltd_file TYPE filetable,
      li_rc    TYPE i,
      lw_file  TYPE file_table.

" Para selección del archivo de servidor
DATA: ltd_host        TYPE STANDARD TABLE OF msxxlist,
      lw_host         TYPE msxxlist,
      lc_path         TYPE dxfields-longpath,
      lc_ubicacion(1) TYPE c,
      lc_abend        TYPE c.

CONSTANTS: lc_p TYPE c VALUE 'P',
           lc_a TYPE dxfields-location VALUE 'A'.

* Sección de selección
SELECTION-SCREEN BEGIN OF BLOCK b_1 WITH FRAME. "TITLE text-002.

PARAMETERS: p_floca TYPE localfile DEFAULT ''."Subir
PARAMETERS: p_fserv TYPE localfile DEFAULT ''."Descargar

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


AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_fserv.


  CALL FUNCTION '/SAPDMC/LSM_F4_SERVER_FILE'
    EXPORTING
      directory        = gc_ruta
      filemask         = gs_filter
    IMPORTING
      serverfile       = p_fserv
    EXCEPTIONS
      canceled_by_user = 1
      OTHERS           = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here

  ENDIF.
