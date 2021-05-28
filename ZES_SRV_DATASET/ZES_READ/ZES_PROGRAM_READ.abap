REPORT zes_program.


TABLES: spfli.

TYPES:

  BEGIN OF gty_spfli,
    carrid    TYPE spfli-carrid,
    connid    TYPE spfli-connid,
    countryfr TYPE spfli-countryfr,
    cityfrom  TYPE spfli-cityfrom,
    airpfrom  TYPE spfli-airpfrom,
    countryto TYPE spfli-countryto,
    cityto    TYPE spfli-cityto,
    airpto    TYPE spfli-airpto,
  END OF gty_spfli.

DATA: gtd_spfli      TYPE STANDARD TABLE OF gty_spfli,
      gwa_spfli      TYPE gty_spfli,
      gs_line(90)      TYPE c,
      gtd_line         LIKE STANDARD TABLE OF gs_line,
      gst_rutasrv      TYPE string,
      gst_namefilesrv  TYPE string,
      gst_filesrv(100) TYPE c.


PARAMETERS: p_dserv TYPE rlgrap-filename DEFAULT ''.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_dserv.
* Se obtiene el directorio del servidor
  CALL FUNCTION '/SAPDMC/LSM_F4_SERVER_FILE'
    EXPORTING
      directory        = '/tmp'
*     filemask         = 'Directorio'
    IMPORTING
      serverfile       = p_dserv
    EXCEPTIONS
      canceled_by_user = 1
      OTHERS           = 2.

  IF sy-subrc <> 0.
    MESSAGE 'Ocurrió un problema al seleccionar el directorio del servidor' TYPE 'S' DISPLAY LIKE 'E'.
  ENDIF.


START-OF-SELECTION.

  IF p_dserv IS NOT INITIAL.
    PERFORM process.
  ELSE.
    MESSAGE 'Elija una ruta en el servidor.'  TYPE 'S' DISPLAY LIKE 'W'.
  ENDIF.

END-OF-SELECTION.


FORM process.

  gst_filesrv = p_dserv.

*Leer desde servidor
  OPEN DATASET gst_filesrv FOR INPUT
                           IN TEXT MODE
                           ENCODING DEFAULT.

  DO.
    READ DATASET gst_filesrv INTO gs_line.
    IF sy-subrc <> 0.
      EXIT.
    ENDIF.
    APPEND  gs_line TO gtd_line.
  ENDDO.

  CLOSE DATASET gst_filesrv.

  LOOP AT gtd_line INTO gs_line.

    SPLIT gs_line AT ',' INTO spfli-carrid
                              spfli-connid
                              spfli-countryfr
                              spfli-cityfrom
                              spfli-airpfrom
                              spfli-countryto
                              spfli-cityto
                              spfli-airpto.

    APPEND gwa_spfli TO gtd_spfli.

    WRITE: /1 sy-vline,
             3(8)    spfli-carrid,    12(1)  sy-vline,
             14(40)  spfli-connid,    55(1)  sy-vline,
             57(20)  spfli-countryfr, 78(1)  sy-vline,
             80(20)  spfli-cityfrom,  101(1) sy-vline,
             103(20) spfli-airpfrom,  124(1) sy-vline,
             126(20) spfli-countryto, 147(1) sy-vline,
             149(30) spfli-cityto,    180(1) sy-vline,
             182(30) spfli-airpto,    213(1) sy-vline.

  ENDLOOP.

ENDFORM.                    "process