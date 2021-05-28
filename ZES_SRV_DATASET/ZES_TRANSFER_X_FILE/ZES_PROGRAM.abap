REPORT zes_program.



TYPES: BEGIN OF lty_pdf,
         linea TYPE solisti1-line,
       END OF lty_pdf,

       BEGIN OF lty_split,
         row(50),
       END OF lty_split.

CONSTANTS: c_numchar TYPE numc3  VALUE 255,
           c_pdf     TYPE char03 VALUE 'PDF'.

DATA: ltd_objbin    TYPE STANDARD TABLE OF solisti1,
      ltd_objpack   TYPE STANDARD TABLE OF sopcklsti1,
      ltd_pdf       TYPE STANDARD TABLE OF lty_pdf,
      ltd_split     TYPE STANDARD TABLE OF lty_split,
      ltd_objtxt    TYPE STANDARD TABLE OF solisti1,
      ltd_reclist   TYPE STANDARD TABLE OF somlreci1,
      ltd_objhead   TYPE STANDARD TABLE OF solisti1,
      ltd_objhex    TYPE STANDARD TABLE OF solix,
      lw_objhex     LIKE LINE OF ltd_objhex,
      lw_objpack    LIKE LINE OF ltd_objpack,
      lw_objhead    LIKE LINE OF ltd_objhead,
      lw_reclist    LIKE LINE OF ltd_reclist,
      lw_objtxt     LIKE LINE OF ltd_objtxt,
      lw_split      LIKE LINE OF ltd_split,
      ltd_filetable TYPE filetable,
      lw_objbin     LIKE LINE OF ltd_objbin,
      lw_pdf        TYPE lty_pdf,
      lw_indx1      TYPE indx,
      lw_indx2      TYPE indx,
      ls_filename   TYPE string,
      ls_lines      TYPE sy-tabix,
      li_count      TYPE i,
      li_len        TYPE i,
      li_index      LIKE sy-index,
      ls_doc_type   TYPE so_obj_tp,
      w_doc_chng    TYPE sodocchgi1,
      v_lines_txt   TYPE numc10,
      li_body_num   TYPE i.

" Para selección del archivo local
DATA: ltd_file TYPE filetable,
      li_rc    TYPE i,
      lw_file  TYPE file_table,
      gs_message TYPE string.

FIELD-SYMBOLS: <fs_packing>   LIKE LINE OF ltd_objpack,
               <fs_filetable> LIKE LINE OF ltd_filetable,
               <fs_split>     LIKE LINE OF ltd_split.

PARAMETERS: p_floca TYPE localfile DEFAULT ''.

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

START-OF-SELECTION.

IF p_floca IS NOT INITIAL.
  PERFORM process.
ELSE.
  MESSAGE 'Seleccionar un archivo a cargar' TYPE 'S' DISPLAY LIKE 'W'.
ENDIF.



END-OF-SELECTION.


FORM process.

  DATA: ls_full_name     TYPE string,
        ls_stripped_name TYPE string.
  DATA: ls_filename_aux(100),
        ls_rutasrv TYPE string.

*  CALL METHOD cl_gui_frontend_services=>file_open_dialog
*  EXPORTING
*  window_title            = 'Seleccionar archivo'
**     default_extension       = '.PDF'
**     file_filter             = 'Portable Document Format (*.PDF;*.pdf)|*.PDF;*.pdf|'
*  multiselection          = ' '
*  CHANGING
*  file_table              = ltd_filetable
*  rc                      = li_count
*  EXCEPTIONS
*  file_open_dialog_failed = 1
*  cntl_error              = 2
*  error_no_gui            = 3
*  not_supported_by_gui    = 4
*  OTHERS                  = 5.
*
*  READ TABLE ltd_filetable ASSIGNING <fs_filetable> INDEX 1.
*  IF sy-subrc EQ 0.

  ls_filename = p_floca.

  CALL METHOD cl_gui_frontend_services=>gui_upload
  EXPORTING
    filename                = ls_filename
    filetype                = 'BIN'
*        importing
*       filelength              =
  CHANGING
    data_tab                = ltd_pdf
  EXCEPTIONS
    file_open_error         = 1
    file_read_error         = 2
    no_batch                = 3
    gui_refuse_filetransfer = 4
    invalid_type            = 5
    no_authority            = 6
    unknown_error           = 7
    bad_data_format         = 8
    header_not_allowed      = 9
    separator_not_allowed   = 10
    header_too_long         = 11
    unknown_dp_error        = 12
    access_denied           = 13
    dp_out_of_memory        = 14
    disk_full               = 15
    dp_timeout              = 16
    not_supported_by_gui    = 17
    error_no_gui            = 18
    OTHERS                  = 19.

  li_len      = strlen( ls_filename ) - 3.
  ls_doc_type = ls_filename+li_len(3).
  TRANSLATE ls_doc_type TO UPPER CASE.

***    SPLIT ls_filename AT '\' INTO TABLE ltd_split .
***    DESCRIBE TABLE ltd_split LINES li_index .
***
***    READ TABLE ltd_split ASSIGNING <fs_split> INDEX li_index .
***    IF sy-subrc EQ 0.
***      ls_filename = <fs_split>-row .
***    ENDIF.

  ls_full_name = ls_filename.

  CALL FUNCTION 'TRINT_SPLIT_FILE_AND_PATH'
  EXPORTING
    full_name     = ls_full_name
  IMPORTING
    stripped_name = ls_stripped_name
*       FILE_PATH     =
  EXCEPTIONS
    x_error       = 1
    OTHERS        = 2.
  IF sy-subrc EQ 0.
  ls_filename_aux = ls_stripped_name.
  ELSE.
  ls_filename_aux = 'DEMO'.
  ENDIF.

  CLEAR: lw_pdf, lw_objbin, ltd_objbin[], lw_objpack, ltd_objpack[].

  LOOP AT ltd_pdf INTO lw_pdf.
  MOVE lw_pdf-linea TO lw_objbin-line.
  APPEND lw_objbin TO ltd_objbin.
  ENDLOOP.

*  ENDIF.

*Obtener nombre de archivo
  ls_rutasrv = '/tmp'.
*  MOVE 'E:\usr\sap\DSM\DVEBMGS00\work\prueba005.txt' TO ls_filename_aux.
*  MOVE '.\HES_PRUEBAS.PDF' TO ls_filename_aux.

  CONCATENATE ls_rutasrv '/' ls_filename_aux INTO ls_filename_aux.


* Subida a servidor
  OPEN DATASET ls_filename_aux FOR OUTPUT IN BINARY MODE.
  IF sy-subrc NE 0.
  EXIT.
  ENDIF.

  DATA: lt_content TYPE STANDARD TABLE OF lty_pdf,
    lw_content LIKE LINE OF lt_content,
    alen       TYPE i.

  lt_content[] = ltd_pdf[].

  LOOP AT lt_content INTO lw_content.
  TRANSFER lw_content-linea TO ls_filename_aux.
  ENDLOOP.
  CLOSE DATASET ls_filename_aux.

  CONCATENATE 'Proceso completado. (' ls_filename_aux ')' INTO gs_message.
  MESSAGE gs_message TYPE 'S'.

ENDFORM.