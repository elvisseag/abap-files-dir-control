*&---------------------------------------------------------------------*
*&  Include           ZES_PROGRAM_MAI
*&---------------------------------------------------------------------*

START-OF-SELECTION.

  IF p_floca IS NOT INITIAL.
    PERFORM process_cg3z.
  ENDIF.

  IF p_fserv IS NOT INITIAL.
    PERFORM process_cg3y.
  ENDIF.

END-OF-SELECTION.
