*&---------------------------------------------------------------------*
*&  Include           ZES_PROGRAM_F01
*&---------------------------------------------------------------------*


FORM process_cg3z.

  DATA: ls_mode          TYPE ctu_params-dismode VALUE 'N', "'N', "'A'.
        ls_cupdate       TYPE ctu_params-updmode VALUE 'S', "'L'.
        ltd_messtab      TYPE TABLE OF bdcmsgcoll,
        lwa_messtab      TYPE bdcmsgcoll,
        lst_messtab      TYPE string,
        lst_ruta         TYPE string,
        lst_filenamesrv  TYPE string,
        lst_file         TYPE string,
        ls_full_name     TYPE char200,
        ls_stripped_name TYPE char200.

  CLEAR: gtd_bdcdata.

  ls_full_name = p_floca.

  CALL FUNCTION 'TRINT_SPLIT_FILE_AND_PATH'
    EXPORTING
      full_name     = ls_full_name
    IMPORTING
      stripped_name = ls_stripped_name
*     FILE_PATH     =
*     EXCEPTIONS
*     X_ERROR       = 1
*     OTHERS        = 2
    .
  IF sy-subrc IS INITIAL.
    lst_filenamesrv = ls_stripped_name.
  ELSE.
    lst_filenamesrv = 'Subida_1.txt'.
  ENDIF.

  lst_ruta        = '/tmp/'.

  CONCATENATE lst_ruta lst_filenamesrv INTO lst_file.


  PERFORM bdc_dynpro      USING 'SAPLC13Z' '1020'.
  PERFORM bdc_field       USING 'BDC_CURSOR'
                                'RCGFILETR-FTFTYPE'.
  PERFORM bdc_field       USING 'BDC_OKCODE'
                                '=EIMP'.
  PERFORM bdc_field       USING 'RCGFILETR-FTFRONT'
                                p_floca.
  PERFORM bdc_field       USING 'RCGFILETR-FTAPPL'
*                                'E:\usr\sap\DSM\DVEBMGS00\work\TEST_001.txt'.
                                lst_file.
  PERFORM bdc_field       USING 'RCGFILETR-FTFTYPE'
                                'BIN'.
  PERFORM bdc_field       USING 'RCGFILETR-IEFOW'
                                'X'.
  PERFORM bdc_dynpro      USING 'SAPLC13Z' '1020'.
  PERFORM bdc_field       USING 'BDC_OKCODE'
                                '/EECAN'.

  CALL TRANSACTION 'CG3Z' USING gtd_bdcdata
                          MODE   ls_mode
                          UPDATE ls_cupdate
                          MESSAGES INTO ltd_messtab.

  IF ltd_messtab[] IS NOT INITIAL.
*    MESSAGE 'Uploaded successfully.' TYPE 'S'.
    LOOP AT  ltd_messtab INTO lwa_messtab.
      CALL FUNCTION 'FORMAT_MESSAGE'
        EXPORTING
          id        = lwa_messtab-msgid
          lang      = 'S'
          no        = lwa_messtab-msgnr
          v1        = lwa_messtab-msgv1
          v2        = lwa_messtab-msgv2
          v3        = lwa_messtab-msgv3
          v4        = lwa_messtab-msgv4
        IMPORTING
          msg       = lst_messtab "msg_text
        EXCEPTIONS
          not_found = 1
          OTHERS    = 2.
      IF sy-subrc = 0.
        MESSAGE lst_messtab TYPE 'S'.
      ENDIF.
    ENDLOOP.

  ENDIF.

ENDFORM.                    "process_cg3z

*&---------------------------------------------------------------------*
*&  Include           ZES_PROGRAM_F01
*&---------------------------------------------------------------------*

FORM process_cg3y.

  DATA: ls_mode     TYPE ctu_params-dismode VALUE 'N', "'N', "'A'.
        ls_cupdate  TYPE ctu_params-updmode VALUE 'S', "'L'.
        ltd_messtab TYPE TABLE OF bdcmsgcoll,
        lwa_messtab TYPE bdcmsgcoll,
        lst_messtab TYPE string.

  CLEAR: gtd_bdcdata.

  PERFORM bdc_dynpro      USING 'SAPLC13Z'          '1010'.
  PERFORM bdc_field       USING 'BDC_CURSOR'        'RCGFILETR-IEFOW'.
  PERFORM bdc_field       USING 'BDC_OKCODE'        '=EEXO'.
  PERFORM bdc_field       USING 'RCGFILETR-FTAPPL'  p_fserv.
  PERFORM bdc_field       USING 'RCGFILETR-FTFRONT' 'C:\Users\elvis\Downloads\SAP\descarga.txt'.
  PERFORM bdc_field       USING 'RCGFILETR-FTFTYPE' 'BIN'.
  PERFORM bdc_field       USING 'RCGFILETR-IEFOW'   'X'.

  CALL TRANSACTION 'CG3Y' USING gtd_bdcdata
    MODE   ls_mode
    UPDATE ls_cupdate
    MESSAGES INTO ltd_messtab.

  IF ltd_messtab[] IS NOT INITIAL."Colocar debug para visualizar tabla de resultados
*    message 'Downloaded successfully.' type 'S'.

    LOOP AT  ltd_messtab INTO lwa_messtab.
      CALL FUNCTION 'FORMAT_MESSAGE'
        EXPORTING
          id        = lwa_messtab-msgid
          lang      = 'S'
          no        = lwa_messtab-msgnr
          v1        = lwa_messtab-msgv1
          v2        = lwa_messtab-msgv2
          v3        = lwa_messtab-msgv3
          v4        = lwa_messtab-msgv4
        IMPORTING
          msg       = lst_messtab "msg_text
        EXCEPTIONS
          not_found = 1
          OTHERS    = 2.
      IF sy-subrc = 0.
        MESSAGE lst_messtab TYPE 'S'.
      ENDIF.
    ENDLOOP.

  ENDIF.

ENDFORM.                    "process_cg3y

*&---------------------------------------------------------------------*
*&      Form  BDC_DYNPRO
*&---------------------------------------------------------------------*
FORM bdc_dynpro  USING  program dynpro.

  CLEAR gw_bdcdata.
  gw_bdcdata-program  = program.
  gw_bdcdata-dynpro   = dynpro.
  gw_bdcdata-dynbegin = 'X'.
  APPEND gw_bdcdata TO gtd_bdcdata.

ENDFORM.                    "bdc_dynpro
*&---------------------------------------------------------------------*
*&      Form  BDC_FIELD
*&---------------------------------------------------------------------*
FORM bdc_field  USING fnam fval.

  IF fval IS NOT INITIAL.
    CLEAR gw_bdcdata.
    gw_bdcdata-fnam = fnam.
    gw_bdcdata-fval = fval.
    APPEND gw_bdcdata TO gtd_bdcdata.
  ENDIF.

ENDFORM.                    "bdc_field