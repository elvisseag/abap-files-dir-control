
AT SELECTION-SCREEN.

REFRESH gtd_report.

PERFORM validate.

IF gtd_report[] IS NOT INITIAL.
  PERFORM display_alv.
ENDIF.

END-OF-SELECTION.
