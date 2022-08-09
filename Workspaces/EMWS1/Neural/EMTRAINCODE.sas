*------------------------------------------------------------*;
* Neural: Create decision matrix;
*------------------------------------------------------------*;
data WORK.class;
  length   class                            $  32
           COUNT                                8
           DATAPRIOR                            8
           TRAINPRIOR                           8
           DECPRIOR                             8
           DECISION1                            8
           DECISION2                            8
           ;

  label    COUNT="Level Counts"
           DATAPRIOR="Data Proportions"
           TRAINPRIOR="Training Proportions"
           DECPRIOR="Decision Priors"
           DECISION1="RECURRENCE-EVENTS"
           DECISION2="NO-RECURRENCE-EVENTS"
           ;
  format   COUNT 10.
           ;
class="RECURRENCE-EVENTS"; COUNT=59; DATAPRIOR=0.29203539823008; TRAINPRIOR=0.2964824120603; DECPRIOR=.; DECISION1=1; DECISION2=0;
output;
class="NO-RECURRENCE-EVENTS"; COUNT=140; DATAPRIOR=0.70796460176991; TRAINPRIOR=0.70351758793969; DECPRIOR=.; DECISION1=0; DECISION2=1;
output;
;
run;
proc datasets lib=work nolist;
modify class(type=PROFIT label=class);
label DECISION1= 'RECURRENCE-EVENTS';
label DECISION2= 'NO-RECURRENCE-EVENTS';
run;
quit;
data EM_Neural;
set EMWS1.Varsel_TRAIN(keep=
G_age G_breast_quad G_inv_nodes G_tumor_size REP_deg_malig class irradiat );
run;
*------------------------------------------------------------* ;
* Neural: DMDBClass Macro ;
*------------------------------------------------------------* ;
%macro DMDBClass;
    G_age(ASC) G_breast_quad(ASC) G_inv_nodes(ASC) G_tumor_size(ASC) class(DESC)
   irradiat(ASC)
%mend DMDBClass;
*------------------------------------------------------------* ;
* Neural: DMDBVar Macro ;
*------------------------------------------------------------* ;
%macro DMDBVar;
    REP_deg_malig
%mend DMDBVar;
*------------------------------------------------------------*;
* Neural: Create DMDB;
*------------------------------------------------------------*;
proc dmdb batch data=WORK.EM_Neural
dmdbcat=WORK.Neural_DMDB
maxlevel = 513
;
class %DMDBClass;
var %DMDBVar;
target
class
;
run;
quit;
*------------------------------------------------------------* ;
* Neural: Interval Input Variables Macro ;
*------------------------------------------------------------* ;
%macro INTINPUTS;
    REP_deg_malig
%mend INTINPUTS;
*------------------------------------------------------------* ;
* Neural: Binary Inputs Macro ;
*------------------------------------------------------------* ;
%macro BININPUTS;

%mend BININPUTS;
*------------------------------------------------------------* ;
* Neural: Nominal Inputs Macro ;
*------------------------------------------------------------* ;
%macro NOMINPUTS;
    G_age G_breast_quad G_inv_nodes G_tumor_size irradiat
%mend NOMINPUTS;
*------------------------------------------------------------* ;
* Neural: Ordinal Inputs Macro ;
*------------------------------------------------------------* ;
%macro ORDINPUTS;

%mend ORDINPUTS;
*------------------------------------------------------------*;
* Neural Network Training;
;
*------------------------------------------------------------*;
proc neural data=EM_Neural dmdbcat=WORK.Neural_DMDB
validdata = EMWS1.Varsel_VALIDATE
random=12345
;
nloptions
;
performance alldetails noutilfile;
netopts
decay=0;
input %INTINPUTS / level=interval id=intvl
;
input %NOMINPUTS / level=nominal id=nom
;
target class / level=NOMINAL id=class
bias
;
arch MLP
Hidden=3
;
Prelim 5 preiter=10
pretime=3600
Outest=EMWS1.Neural_PRELIM_OUTEST
;
save network=EMWS1.Neural_NETWORK.dm_neural;
train Maxiter=50
maxtime=14400
Outest=EMWS1.Neural_outest estiter=1
Outfit=EMWS1.Neural_OUTFIT
;
run;
quit;
proc sort data=EMWS1.Neural_OUTFIT(where=(_iter_ ne . and _NAME_="OVERALL")) out=fit_Neural;
by _VAVERR_;
run;
%GLOBAL ITER;
data _null_;
set fit_Neural(obs=1);
call symput('ITER',put(_ITER_, 6.));
run;
data EMWS1.Neural_INITIAL;
set EMWS1.Neural_outest(where=(_ITER_ eq &ITER and _OBJ_ ne .));
run;
*------------------------------------------------------------*;
* Neural Network Model Selection;
;
*------------------------------------------------------------*;
proc neural data=EM_Neural dmdbcat=WORK.Neural_DMDB
validdata = EMWS1.Varsel_VALIDATE
network = EMWS1.Neural_NETWORK.dm_neural
random=12345
;
nloptions noprint;
performance alldetails noutilfile;
initial inest=EMWS1.Neural_INITIAL;
train tech=NONE;
code file="C:\Users\brahm\OneDrive\Desktop\BAN210_Project\Workspaces\EMWS1\Neural\SCORECODE.sas"
group=Neural
;
;
code file="C:\Users\brahm\OneDrive\Desktop\BAN210_Project\Workspaces\EMWS1\Neural\RESIDUALSCORECODE.sas"
group=Neural
residual
;
;
score data=EMWS1.Varsel_TRAIN out=_NULL_
outfit=WORK.FIT1
role=TRAIN
outkey=EMWS1.Neural_OUTKEY;
score data=EMWS1.Varsel_VALIDATE out=_NULL_
outfit=WORK.FIT2
role=VALID
outkey=EMWS1.Neural_OUTKEY;
run;
quit;
data EMWS1.Neural_OUTFIT;
merge WORK.FIT1 WORK.FIT2;
run;
data EMWS1.Neural_EMESTIMATE;
set EMWS1.Neural_outest;
if _type_ ^in('HESSIAN' 'GRAD');
run;
proc datasets lib=work nolist;
delete EM_Neural;
run;
quit;
