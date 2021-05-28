REPORT zes_program.

* TOP *************************************************************

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
      gst_rutapc     TYPE string,
      gst_namefilepc TYPE string,
      gst_filepc     TYPE string,
      gst_mensaje    TYPE string.

* SEL **************************************************************
PARAMETERS: p_dloca TYPE localfile DEFAULT ''.

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


* MAI *************************************************************

START-OF-SELECTION.

  IF p_dloca IS NOT INITIAL.
    PERFORM get_data.
    PERFORM process.
  ELSE.
    MESSAGE 'Elegir un directorio para la descarga.' TYPE 'S' DISPLAY LIKE 'W'.
  ENDIF.

END-OF-SELECTION.



* F01 *************************************************************

FORM get_data.

  SELECT carrid connid countryfr cityfrom airpfrom countryto cityto airpto
    UP TO 20 ROWS
    FROM spfli
    INTO TABLE gtd_spfli.

ENDFORM.

FORM process.

  gst_rutapc       = p_dloca.
  gst_namefilepc   = '\PRUEBA_000.txt'.

  CONCATENATE gst_rutapc gst_namefilepc INTO gst_filepc.

  "Descargar en PC
  CALL FUNCTION 'GUI_DOWNLOAD'
    EXPORTING
      filename                = gst_filepc
      filetype                = 'ASC'
      write_field_separator   = 'X'
    TABLES
      data_tab                = gtd_spfli
    EXCEPTIONS
      file_write_error        = 1
      no_batch                = 2
      gui_refuse_filetransfer = 3
      invalid_type            = 4
      no_authority            = 5
      unknown_error           = 6
      header_not_allowed      = 7
      separator_not_allowed   = 8
      filesize_not_allowed    = 9
      header_too_long         = 10
      dp_error_create         = 11
      dp_error_send           = 12
      dp_error_write          = 13
      unknown_dp_error        = 14
      access_denied           = 15
      dp_out_of_memory        = 16
      disk_full               = 17
      dp_timeout              = 18
      file_not_found          = 19
      dataprovider_exception  = 20
      control_flush_error     = 21
      OTHERS                  = 22.
  IF sy-subrc EQ 0.
    CONCATENATE 'Guardado en' gst_rutapc INTO gst_mensaje.
    MESSAGE gst_mensaje TYPE 'S'.
  ELSE.
    MESSAGE 'Error' TYPE 'S' DISPLAY LIKE 'W'.
  ENDIF.

ENDFORM.