*&---------------------------------------------------------------------*
*&  Include           ZES_PROGRAM_MAI
*&---------------------------------------------------------------------*

START-OF-SELECTION.

  CLEAR: gs_file.

  IF p_fxls IS NOT INITIAL.
    gs_file = p_fxls.
    PERFORM read_file_xls.
    PERFORM display_data.
  ENDIF.

END-OF-SELECTION.
