TABLES: sscrfields.


TYPES:
 BEGIN OF gty_report,
    type    TYPE char20,
    path    TYPE string,
    message TYPE char50,
  END OF gty_report.

DATA: gtd_report TYPE STANDARD TABLE OF gty_report,
      gwa_report TYPE gty_report.

DATA: gs_opc    TYPE i VALUE 1,
      gs_file   TYPE localfile,
      gc_ruta   TYPE dxfields-longpath VALUE '/tmp', "/usr/sap/dsm/dvebmgs00/work'.
      gs_filter TYPE dxfields-filemask VALUE '*.txt'. " '(*.txt)|*.txt*'. " '*.txt'.

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

DATA: gwa_dyntxt TYPE smp_dyntxt,
      gs_message TYPE string.

DATA: gtd_fieldcat TYPE slis_t_fieldcat_alv,
      gwa_fieldcat TYPE slis_fieldcat_alv.

CONSTANTS: lc_p TYPE c VALUE 'P',
           lc_a TYPE dxfields-location VALUE 'A'.