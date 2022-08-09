***********************************;
*** Begin Scoring Code for Neural;
***********************************;
DROP _DM_BAD _EPS _NOCL_ _MAX_ _MAXP_ _SUM_ _NTRIALS;
 _DM_BAD = 0;
 _NOCL_ = .;
 _MAX_ = .;
 _MAXP_ = .;
 _SUM_ = .;
 _NTRIALS = .;
 _EPS =                1E-10;
LENGTH _WARN_ $4 
      F_class  $ 20
      I_class  $ 20
      U_class  $ 20
;
      label S_REP_deg_malig = 'Standard: REP_deg_malig' ;

      label G_age0 = 'Dummy: G_age=0' ;

      label G_age1 = 'Dummy: G_age=1' ;

      label G_age2 = 'Dummy: G_age=2' ;

      label G_breast_quad0 = 'Dummy: G_breast_quad=0' ;

      label G_breast_quad1 = 'Dummy: G_breast_quad=1' ;

      label G_breast_quad2 = 'Dummy: G_breast_quad=2' ;

      label G_inv_nodes0 = 'Dummy: G_inv_nodes=0' ;

      label G_inv_nodes1 = 'Dummy: G_inv_nodes=1' ;

      label G_tumor_size0 = 'Dummy: G_tumor_size=0' ;

      label G_tumor_size1 = 'Dummy: G_tumor_size=1' ;

      label G_tumor_size2 = 'Dummy: G_tumor_size=2' ;

      label G_tumor_size3 = 'Dummy: G_tumor_size=3' ;

      label irradiatno = 'Dummy: irradiat=no' ;

      label H11 = 'Hidden: H1=1' ;

      label H12 = 'Hidden: H1=2' ;

      label H13 = 'Hidden: H1=3' ;

      label I_class = 'Into: class' ;

      label F_class = 'From: class' ;

      label U_class = 'Unnormalized Into: class' ;

      label P_classrecurrence_events = 'Predicted: class=recurrence-events' ;

      label R_classrecurrence_events = 'Residual: class=recurrence-events' ;

      label P_classno_recurrence_events = 
'Predicted: class=no-recurrence-events' ;

      label R_classno_recurrence_events = 
'Residual: class=no-recurrence-events' ;

      label  _WARN_ = "Warnings"; 

*** Generate dummy variables for G_age ;
drop G_age0 G_age1 G_age2 ;
if missing( G_age ) then do;
   G_age0 = .;
   G_age1 = .;
   G_age2 = .;
   substr(_warn_,1,1) = 'M';
   _DM_BAD = 1;
end;
else do;
   length _dm12 $ 12; drop _dm12 ;
   _dm12 = put( G_age , BEST12. );
   %DMNORMIP( _dm12 )
   if _dm12 = '2'  then do;
      G_age0 = 0;
      G_age1 = 0;
      G_age2 = 1;
   end;
   else if _dm12 = '1'  then do;
      G_age0 = 0;
      G_age1 = 1;
      G_age2 = 0;
   end;
   else if _dm12 = '3'  then do;
      G_age0 = -1;
      G_age1 = -1;
      G_age2 = -1;
   end;
   else if _dm12 = '0'  then do;
      G_age0 = 1;
      G_age1 = 0;
      G_age2 = 0;
   end;
   else do;
      G_age0 = .;
      G_age1 = .;
      G_age2 = .;
      substr(_warn_,2,1) = 'U';
      _DM_BAD = 1;
   end;
end;

*** Generate dummy variables for G_breast_quad ;
drop G_breast_quad0 G_breast_quad1 G_breast_quad2 ;
if missing( G_breast_quad ) then do;
   G_breast_quad0 = .;
   G_breast_quad1 = .;
   G_breast_quad2 = .;
   substr(_warn_,1,1) = 'M';
   _DM_BAD = 1;
end;
else do;
   length _dm12 $ 12; drop _dm12 ;
   _dm12 = put( G_breast_quad , BEST12. );
   %DMNORMIP( _dm12 )
   if _dm12 = '0'  then do;
      G_breast_quad0 = 1;
      G_breast_quad1 = 0;
      G_breast_quad2 = 0;
   end;
   else if _dm12 = '1'  then do;
      G_breast_quad0 = 0;
      G_breast_quad1 = 1;
      G_breast_quad2 = 0;
   end;
   else if _dm12 = '2'  then do;
      G_breast_quad0 = 0;
      G_breast_quad1 = 0;
      G_breast_quad2 = 1;
   end;
   else if _dm12 = '3'  then do;
      G_breast_quad0 = -1;
      G_breast_quad1 = -1;
      G_breast_quad2 = -1;
   end;
   else do;
      G_breast_quad0 = .;
      G_breast_quad1 = .;
      G_breast_quad2 = .;
      substr(_warn_,2,1) = 'U';
      _DM_BAD = 1;
   end;
end;

*** Generate dummy variables for G_inv_nodes ;
drop G_inv_nodes0 G_inv_nodes1 ;
if missing( G_inv_nodes ) then do;
   G_inv_nodes0 = .;
   G_inv_nodes1 = .;
   substr(_warn_,1,1) = 'M';
   _DM_BAD = 1;
end;
else do;
   length _dm12 $ 12; drop _dm12 ;
   _dm12 = put( G_inv_nodes , BEST12. );
   %DMNORMIP( _dm12 )
   if _dm12 = '0'  then do;
      G_inv_nodes0 = 1;
      G_inv_nodes1 = 0;
   end;
   else if _dm12 = '1'  then do;
      G_inv_nodes0 = 0;
      G_inv_nodes1 = 1;
   end;
   else if _dm12 = '2'  then do;
      G_inv_nodes0 = -1;
      G_inv_nodes1 = -1;
   end;
   else do;
      G_inv_nodes0 = .;
      G_inv_nodes1 = .;
      substr(_warn_,2,1) = 'U';
      _DM_BAD = 1;
   end;
end;

*** Generate dummy variables for G_tumor_size ;
drop G_tumor_size0 G_tumor_size1 G_tumor_size2 G_tumor_size3 ;
*** encoding is sparse, initialize to zero;
G_tumor_size0 = 0;
G_tumor_size1 = 0;
G_tumor_size2 = 0;
G_tumor_size3 = 0;
if missing( G_tumor_size ) then do;
   G_tumor_size0 = .;
   G_tumor_size1 = .;
   G_tumor_size2 = .;
   G_tumor_size3 = .;
   substr(_warn_,1,1) = 'M';
   _DM_BAD = 1;
end;
else do;
   length _dm12 $ 12; drop _dm12 ;
   _dm12 = put( G_tumor_size , BEST12. );
   %DMNORMIP( _dm12 )
   _dm_find = 0; drop _dm_find;
   if _dm12 <= '2'  then do;
      if _dm12 <= '1'  then do;
         if _dm12 = '0'  then do;
            G_tumor_size0 = 1;
            _dm_find = 1;
         end;
         else do;
            if _dm12 = '1'  then do;
               G_tumor_size1 = 1;
               _dm_find = 1;
            end;
         end;
      end;
      else do;
         if _dm12 = '2'  then do;
            G_tumor_size2 = 1;
            _dm_find = 1;
         end;
      end;
   end;
   else do;
      if _dm12 = '3'  then do;
         G_tumor_size3 = 1;
         _dm_find = 1;
      end;
      else do;
         if _dm12 = '4'  then do;
            G_tumor_size0 = -1;
            G_tumor_size1 = -1;
            G_tumor_size2 = -1;
            G_tumor_size3 = -1;
            _dm_find = 1;
         end;
      end;
   end;
   if not _dm_find then do;
      G_tumor_size0 = .;
      G_tumor_size1 = .;
      G_tumor_size2 = .;
      G_tumor_size3 = .;
      substr(_warn_,2,1) = 'U';
      _DM_BAD = 1;
   end;
end;

*** Generate dummy variables for irradiat ;
drop irradiatno ;
if missing( irradiat ) then do;
   irradiatno = .;
   substr(_warn_,1,1) = 'M';
   _DM_BAD = 1;
end;
else do;
   length _dm3 $ 3; drop _dm3 ;
   _dm3 = put( irradiat , $3. );
   %DMNORMIP( _dm3 )
   if _dm3 = 'NO'  then do;
      irradiatno = 1;
   end;
   else if _dm3 = 'YES'  then do;
      irradiatno = -1;
   end;
   else do;
      irradiatno = .;
      substr(_warn_,2,1) = 'U';
      _DM_BAD = 1;
   end;
end;

*** *************************;
*** Checking missing input Interval
*** *************************;

IF NMISS(
   REP_deg_malig   ) THEN DO;
   SUBSTR(_WARN_, 1, 1) = 'M';

   _DM_BAD = 1;
END;
*** *************************;
*** Writing the Node intvl ;
*** *************************;
IF _DM_BAD EQ 0 THEN DO;
   S_REP_deg_malig  =    -2.78253429049127 +     1.35716746031314 * 
        REP_deg_malig ;
END;
ELSE DO;
   IF MISSING( REP_deg_malig ) THEN S_REP_deg_malig  = . ;
   ELSE S_REP_deg_malig  =    -2.78253429049127 +     1.35716746031314 * 
        REP_deg_malig ;
END;
*** *************************;
*** Writing the Node nom ;
*** *************************;
*** *************************;
*** Writing the Node H1 ;
*** *************************;
IF _DM_BAD EQ 0 THEN DO;
   H11  =    -0.83930176470528 * S_REP_deg_malig ;
   H12  =    -0.06629291498954 * S_REP_deg_malig ;
   H13  =     0.86650083439136 * S_REP_deg_malig ;
   H11  = H11  +    -0.52575552091022 * G_age0  +    -0.02452272577375 * 
        G_age1  +    -0.59459844636028 * G_age2  +     0.46958511522765 * 
        G_breast_quad0  +    -0.82566780020246 * G_breast_quad1
          +    -0.98644603735078 * G_breast_quad2  +    -0.01252434754666 * 
        G_inv_nodes0  +    -0.72926694626072 * G_inv_nodes1
          +    -1.25787140315568 * G_tumor_size0  +    -0.18033239984222 * 
        G_tumor_size1  +     0.46363850845309 * G_tumor_size2
          +     1.20269753959191 * G_tumor_size3  +    -1.09214961530351 * 
        irradiatno ;
   H12  = H12  +     -0.1981692188932 * G_age0  +     0.67759980709922 * 
        G_age1  +     0.48274044435058 * G_age2  +    -1.02718031870729 * 
        G_breast_quad0  +     1.77649126784718 * G_breast_quad1
          +    -0.48974919382025 * G_breast_quad2  +    -0.03624758417098 * 
        G_inv_nodes0  +    -0.07266712102552 * G_inv_nodes1
          +    -1.60494725258818 * G_tumor_size0  +    -0.01977100118694 * 
        G_tumor_size1  +    -0.56438121580537 * G_tumor_size2
          +    -1.14834909127965 * G_tumor_size3  +     1.41435531346343 * 
        irradiatno ;
   H13  = H13  +    -0.55188459206899 * G_age0  +    -0.18823223344893 * 
        G_age1  +     0.40627160142665 * G_age2  +    -0.60334697509908 * 
        G_breast_quad0  +    -0.71080085203945 * G_breast_quad1
          +     -0.1341761497556 * G_breast_quad2  +    -1.10354676934115 * 
        G_inv_nodes0  +     -0.3469636466685 * G_inv_nodes1
          +    -0.69262936767089 * G_tumor_size0  +     0.35938238796518 * 
        G_tumor_size1  +     0.24019729603027 * G_tumor_size2
          +     0.14397568240947 * G_tumor_size3  +    -0.11771226502995 * 
        irradiatno ;
   H11  =    -0.17155944104582 + H11 ;
   H12  =     0.85968816060862 + H12 ;
   H13  =     0.12939151758083 + H13 ;
   H11  = TANH(H11 );
   H12  = TANH(H12 );
   H13  = TANH(H13 );
END;
ELSE DO;
   H11  = .;
   H12  = .;
   H13  = .;
END;
*** *************************;
*** Writing the Node class ;
*** *************************;

*** Generate dummy variables for class ;
drop classrecurrence_events classno_recurrence_events ;
label F_class = 'From: class' ;
length F_class $ 20;
F_class = put( class , $20. );
%DMNORMIP( F_class )
if missing( class ) then do;
   classrecurrence_events = .;
   classno_recurrence_events = .;
end;
else do;
   if F_class = 'NO-RECURRENCE-EVENTS'  then do;
      classrecurrence_events = 0;
      classno_recurrence_events = 1;
   end;
   else if F_class = 'RECURRENCE-EVENTS'  then do;
      classrecurrence_events = 1;
      classno_recurrence_events = 0;
   end;
   else do;
      classrecurrence_events = .;
      classno_recurrence_events = .;
   end;
end;
IF _DM_BAD EQ 0 THEN DO;
   P_classrecurrence_events  =     2.72345384145319 * H11
          +     3.10897909812313 * H12  +     3.41198629847837 * H13 ;
   P_classrecurrence_events  =    -0.09770061547311 + P_classrecurrence_events
         ;
   P_classno_recurrence_events  = 0; 
   _MAX_ = MAX (P_classrecurrence_events , P_classno_recurrence_events );
   _SUM_ = 0.; 
   P_classrecurrence_events  = EXP(P_classrecurrence_events  - _MAX_);
   _SUM_ = _SUM_ + P_classrecurrence_events ;
   P_classno_recurrence_events  = EXP(P_classno_recurrence_events  - _MAX_);
   _SUM_ = _SUM_ + P_classno_recurrence_events ;
   P_classrecurrence_events  = P_classrecurrence_events  / _SUM_;
   P_classno_recurrence_events  = P_classno_recurrence_events  / _SUM_;
END;
ELSE DO;
   P_classrecurrence_events  = .;
   P_classno_recurrence_events  = .;
END;
IF _DM_BAD EQ 1 THEN DO;
   P_classrecurrence_events  =      0.2964824120603;
   P_classno_recurrence_events  =     0.70351758793969;
END;
*** *****************************;
*** Writing the Residuals  of the Node class ;
*** ******************************;
IF MISSING( classrecurrence_events ) THEN R_classrecurrence_events  = . ;
ELSE R_classrecurrence_events  = classrecurrence_events  - 
        P_classrecurrence_events ;
IF MISSING( classno_recurrence_events ) THEN R_classno_recurrence_events
          = . ;
ELSE R_classno_recurrence_events  = classno_recurrence_events  - 
        P_classno_recurrence_events ;
*** *************************;
*** Writing the I_class  AND U_class ;
*** *************************;
_MAXP_ = P_classrecurrence_events ;
I_class  = "RECURRENCE-EVENTS   " ;
U_class  = "recurrence-events   " ;
IF( _MAXP_ LT P_classno_recurrence_events  ) THEN DO; 
   _MAXP_ = P_classno_recurrence_events ;
   I_class  = "NO-RECURRENCE-EVENTS" ;
   U_class  = "no-recurrence-events" ;
END;
********************************;
*** End Scoring Code for Neural;
********************************;
