****************************************************************;
******             DECISION TREE SCORING CODE             ******;
****************************************************************;

******         LENGTHS OF NEW CHARACTER VARIABLES         ******;
LENGTH F_class  $   20; 
LENGTH I_class  $   20; 
LENGTH U_class  $   20; 
LENGTH _WARN_  $    4; 

******              LABELS FOR NEW VARIABLES              ******;
label _NODE_ = 'Node' ;
label _LEAF_ = 'Leaf' ;
label P_classno_recurrence_events = 'Predicted: class=no-recurrence-events' ;
label P_classrecurrence_events = 'Predicted: class=recurrence-events' ;
label Q_classno_recurrence_events = 
'Unadjusted P: class=no-recurrence-events' ;
label Q_classrecurrence_events = 'Unadjusted P: class=recurrence-events' ;
label V_classno_recurrence_events = 'Validated: class=no-recurrence-events' ;
label V_classrecurrence_events = 'Validated: class=recurrence-events' ;
label R_classno_recurrence_events = 'Residual: class=no-recurrence-events' ;
label R_classrecurrence_events = 'Residual: class=recurrence-events' ;
label F_class = 'From: class' ;
label I_class = 'Into: class' ;
label U_class = 'Unnormalized Into: class' ;
label _WARN_ = 'Warnings' ;


******      TEMPORARY VARIABLES FOR FORMATTED VALUES      ******;
LENGTH _ARBFMT_20 $     20; DROP _ARBFMT_20; 
_ARBFMT_20 = ' '; /* Initialize to avoid warning. */
LENGTH _ARBFMT_5 $      5; DROP _ARBFMT_5; 
_ARBFMT_5 = ' '; /* Initialize to avoid warning. */


_ARBFMT_20 = PUT( class , $20.);
 %DMNORMCP( _ARBFMT_20, F_class );

******             ASSIGN OBSERVATION TO NODE             ******;
IF  NOT MISSING(REP_deg_malig ) AND 
                   2.5 <= REP_deg_malig  THEN DO;
  _ARBFMT_5 = PUT( inv_nodes , $5.);
   %DMNORMIP( _ARBFMT_5);
  IF _ARBFMT_5 IN ('0-2' ,'15-17' ) THEN DO;
    _NODE_  =                    4;
    _LEAF_  =                    2;
    P_classno_recurrence_events  =     0.54545454545454;
    P_classrecurrence_events  =     0.45454545454545;
    Q_classno_recurrence_events  =     0.54545454545454;
    Q_classrecurrence_events  =     0.45454545454545;
    V_classno_recurrence_events  =     0.88888888888888;
    V_classrecurrence_events  =     0.11111111111111;
    I_class  = 'NO-RECURRENCE-EVENTS' ;
    U_class  = 'no-recurrence-events' ;
    END;
  ELSE DO;
    _NODE_  =                    5;
    _LEAF_  =                    3;
    P_classno_recurrence_events  =     0.13333333333333;
    P_classrecurrence_events  =     0.86666666666666;
    Q_classno_recurrence_events  =     0.13333333333333;
    Q_classrecurrence_events  =     0.86666666666666;
    V_classno_recurrence_events  =     0.35294117647058;
    V_classrecurrence_events  =     0.64705882352941;
    I_class  = 'RECURRENCE-EVENTS' ;
    U_class  = 'recurrence-events' ;
    END;
  END;
ELSE DO;
  _NODE_  =                    2;
  _LEAF_  =                    1;
  P_classno_recurrence_events  =     0.81428571428571;
  P_classrecurrence_events  =     0.18571428571428;
  Q_classno_recurrence_events  =     0.81428571428571;
  Q_classrecurrence_events  =     0.18571428571428;
  V_classno_recurrence_events  =     0.77049180327868;
  V_classrecurrence_events  =     0.22950819672131;
  I_class  = 'NO-RECURRENCE-EVENTS' ;
  U_class  = 'no-recurrence-events' ;
  END;

*****  RESIDUALS R_ *************;
IF  F_class  NE 'NO-RECURRENCE-EVENTS' 
AND F_class  NE 'RECURRENCE-EVENTS'  THEN DO; 
        R_classno_recurrence_events  = .;
        R_classrecurrence_events  = .;
 END;
 ELSE DO;
       R_classno_recurrence_events  =  -P_classno_recurrence_events ;
       R_classrecurrence_events  =  -P_classrecurrence_events ;
       SELECT( F_class  );
          WHEN( 'NO-RECURRENCE-EVENTS'  ) R_classno_recurrence_events  = 
        R_classno_recurrence_events  +1;
          WHEN( 'RECURRENCE-EVENTS'  ) R_classrecurrence_events  = 
        R_classrecurrence_events  +1;
       END;
 END;

****************************************************************;
******          END OF DECISION TREE SCORING CODE         ******;
****************************************************************;

