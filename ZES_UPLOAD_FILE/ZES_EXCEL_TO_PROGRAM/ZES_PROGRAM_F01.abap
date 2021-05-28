
*&---------------------------------------------------------------------*
*&      Form  READ_FILE_XLS
*&---------------------------------------------------------------------*
FORM read_file_xls .

  DATA: li_bcol TYPE i VALUE 1, "leer desde columna x
        li_brow TYPE i VALUE 2, "leer desde fila x
        li_ecol TYPE i VALUE 3, "leer hasta columna x
        li_erow TYPE i VALUE 1000. "leer x filas

  CALL FUNCTION 'ALSM_EXCEL_TO_INTERNAL_TABLE'
    EXPORTING
      filename                = gs_file
      i_begin_col             = li_bcol
      i_begin_row             = li_brow
      i_end_col               = li_ecol
      i_end_row               = li_erow
    TABLES
      intern                  = gtd_excel
    EXCEPTIONS
      inconsistent_parameters = 1
      upload_ole              = 2
      OTHERS                  = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ELSE.
    PERFORM format_data_excel TABLES gtd_excel.
  ENDIF.

ENDFORM.


FORM format_data_excel  TABLES p_gtd_excel STRUCTURE alsmex_tabline.

  DATA: li_id TYPE i.

  FIELD-SYMBOLS: <fs_excel> LIKE LINE OF gtd_excel,
                 <fs_data>  LIKE LINE OF gtd_data.
*Cargamos los datos
  DO.
    ADD 1 TO li_id.
    APPEND INITIAL LINE TO gtd_data ASSIGNING <fs_data>.
    LOOP AT gtd_excel ASSIGNING <fs_excel> WHERE row = li_id.
      CONDENSE <fs_excel>-value.
      CASE <fs_excel>-col.
        WHEN '0001'.
          <fs_data>-codigo = <fs_excel>-value.
          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = <fs_data>-codigo
            IMPORTING
              output = <fs_data>-codigo.
        WHEN '0002'. <fs_data>-centro = <fs_excel>-value.
        WHEN '0003'. <fs_data>-correo = <fs_excel>-value.
      ENDCASE.
    ENDLOOP.
    IF sy-subrc <> 0.
      EXIT.
    ENDIF.
  ENDDO.

  DELETE gtd_data WHERE codigo = space.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  PROCESS_DATA
*&---------------------------------------------------------------------*
FORM display_data .

  FIELD-SYMBOLS: <fs_data> LIKE LINE OF gtd_data.

  LOOP AT gtd_data ASSIGNING <fs_data>.

    WRITE: / <fs_data>-codigo, space,
             <fs_data>-centro, space,
             <fs_data>-correo.

  ENDLOOP.
*
ENDFORM.