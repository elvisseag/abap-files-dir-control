*&---------------------------------------------------------------------*
*&  Include           ZES_PROGRAM_TOP
*&---------------------------------------------------------------------*

DATA: gtd_bdcdata TYPE STANDARD TABLE OF bdcdata,
      gw_bdcdata  LIKE LINE OF gtd_bdcdata.

DATA: gs_opc    TYPE i VALUE 1,
      gs_file   TYPE localfile,
      gc_ruta   TYPE dxfields-longpath VALUE '/tmp', " 'E:\usr\sap\DSM\DVEBMGS00', "/usr/sap/dsm/dvebmgs00/work'.
      gs_filter TYPE dxfields-filemask VALUE '*.txt*'. " '(*.txt)|*.txt*'. " '*.txt'.