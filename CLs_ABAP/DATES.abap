" 1. CL_ABAP_TSTMP=>TD_SUBTRACT to get the number of seconds between two date/time pairs.
DATA(today_date) = CONV d( '20190704' ).
DATA(today_time) = CONV t( '000010' ).
DATA(yesterday_date) = CONV d( '20190703' ).
DATA(yesterday_time) = CONV t( '235950' ).

cl_abap_tstmp=>td_subtract(
  EXPORTING
    date1    = today_date
    time1    = today_time
    date2    = yesterday_date
    time2    = yesterday_time
  IMPORTING
    res_secs = DATA(diff) ).

ASSERT diff = 20. " verify expectation or short dump


" 2. CL_ABAP_TSTMP=>SUBTRACT, by passing two timestamps which must be of the type TIMESTAMPL 
" so that to contain milliseconds, and the difference between the 2 timestamps will be returned in number of seconds, 
" including the milliseconds
DATA: lv_tstmp1 TYPE timestampl,
      lv_tstmp2 TYPE timestampl,
      lv_diff   TYPE tzntstmpl.

lv_tstmp1 = '20190704000010.999'. " July 4th, 00:00:10 and 999 ms
lv_tstmp2 = '20190703235950.001'. " July 3rd, 23:59:50 and 001 ms

CALL METHOD cl_abap_tstmp=>subtract
    EXPORTING
      tstmp1 = lv_tstmp1
      tstmp2 = lv_tstmp2
    RECEIVING
      r_secs = lv_diff.

ASSERT lv_diff = '20.998'. " expectation verified or run time error