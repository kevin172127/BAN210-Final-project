data WORK._VARSELDUMMY / view=WORK._VARSELDUMMY;
set EMWS1.Trans_TRAIN;
drop class;
length _NORMVAR $%dmnorlen;
drop _NORMVAR;
length _TARFORMAT $200;
drop _TARFORMAT;
_TARFORMAT = put(class, $20.);
%DMNORMCP(_TARFORMAT, _NORMVAR);
if _NORMVAR eq "NO-RECURRENCE-EVENTS" then _DUMMY_TARGET_ = 1;
else _DUMMY_TARGET_ = 0;
run;
*------------------------------------------------------------* ;
* EM: DMDBClass Macro ;
*------------------------------------------------------------* ;
%macro DMDBClass;
    age(ASC) breast(ASC) breast_quad(ASC) _DUMMY_TARGET_(DESC) inv_nodes(ASC)
   irradiat(ASC) menopause(ASC) node_caps(ASC) tumor_size(ASC)
%mend DMDBClass;
*------------------------------------------------------------* ;
* EM: DMDBVar Macro ;
*------------------------------------------------------------* ;
%macro DMDBVar;
    REP_deg_malig
%mend DMDBVar;
*------------------------------------------------------------*;
* EM: Create DMDB;
*------------------------------------------------------------*;
libname _spdslib SPDE "C:\Users\brahm\AppData\Local\Temp\SAS Temporary Files\_TD32884_DESKTOP-VQ3H6HR_\Prc2";
proc dmdb batch data=WORK._VARSELDUMMY
dmdbcat=WORK.EM_DMDB
maxlevel = 101
out=_spdslib.EM_DMDB
;
class %DMDBClass;
var %DMDBVar;
target
_DUMMY_TARGET_
;
run;
quit;
*------------------------------------------------------------* ;
* Varsel: Input Variables Macro ;
*------------------------------------------------------------* ;
%macro INPUTS;
               REP_DEG_MALIG AGE BREAST BREAST_QUAD INV_NODES IRRADIAT MENOPAUSE NODE_CAPS
   tumor_size
%mend INPUTS;
proc dmine data=_spdslib.EM_DMDB dmdbcat=WORK.EM_DMDB
minr2=0.005 maxrows=3000 stopr2=0.0005 NOAOV16 NOINTER USEGROUPS OUTGROUP=EMWS1.Varsel_OUTGROUP outest=EMWS1.Varsel_OUTESTDMINE outeffect=EMWS1.Varsel_OUTEFFECT outrsquare =EMWS1.Varsel_OUTRSQUARE
NOMONITOR
PSHORT
;
var %INPUTS;
target _DUMMY_TARGET_;
code file="C:\Users\brahm\OneDrive\Desktop\BAN210_Project\Workspaces\EMWS1\Varsel\EMFLOWSCORE.sas";
code file="C:\Users\brahm\OneDrive\Desktop\BAN210_Project\Workspaces\EMWS1\Varsel\EMPUBLISHSCORE.sas";
run;
quit;
/*      proc print data =EMWS1.Varsel_OUTEFFECT;      proc print data =EMWS1.Varsel_OUTRSQUARE;      */
run;
