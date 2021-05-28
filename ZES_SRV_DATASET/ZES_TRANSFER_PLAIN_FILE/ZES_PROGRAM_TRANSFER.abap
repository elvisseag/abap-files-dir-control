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

DATA: gtd_spfli       TYPE STANDARD TABLE OF gty_spfli,
      gwa_spfli       TYPE gty_spfli,
      gs_line(90)      TYPE c,
      gtd_line         LIKE STANDARD TABLE OF gs_line,
      gst_rutapc       TYPE string,
      gst_rutasrv      TYPE string,
      gst_namefilepc   TYPE string,
      gst_namefilesrv  TYPE string,
      gst_filepc       TYPE string,
      gst_filesrv(100) TYPE c,
      gs_message       TYPE string.


PARAMETERS: p_fname TYPE c LENGTH 70 DEFAULT ''.

START-OF-SELECTION.

IF p_fname IS NOT INITIAL.
  PERFORM process.
ELSE.
  MESSAGE 'Indicar un nombre de archivo' TYPE 'S' DISPLAY LIKE 'W'.
ENDIF.



END-OF-SELECTION.

FORM process.

  gst_rutasrv      = '/tmp'.
  gst_namefilesrv  = p_fname.

*  CONCATENATE gst_rutapc gst_namefilepc INTO gst_filepc.
  CONCATENATE gst_rutasrv '/' gst_namefilesrv INTO gst_filesrv.


  SELECT carrid connid countryfr cityfrom airpfrom countryto cityto airpto
    UP TO 10 ROWS
    FROM spfli
    INTO TABLE gtd_spfli.

*Grabar en servidor
  OPEN DATASET gst_filesrv FOR OUTPUT
                          IN TEXT MODE
                          ENCODING DEFAULT.

  LOOP AT gtd_spfli INTO gwa_spfli.

    CONCATENATE gwa_spfli-carrid
                gwa_spfli-connid
                gwa_spfli-countryfr
                gwa_spfli-cityfrom
                gwa_spfli-airpfrom
                gwa_spfli-countryto
                gwa_spfli-cityto
                gwa_spfli-airpto
          INTO gs_line SEPARATED BY ','.

    TRANSFER gs_line TO gst_filesrv.

  ENDLOOP.

  CLOSE DATASET gst_filesrv.

  CONCATENATE 'Proceso completado. (' gst_filesrv ')' INTO gs_message.
  MESSAGE gs_message TYPE 'S'.

ENDFORM.