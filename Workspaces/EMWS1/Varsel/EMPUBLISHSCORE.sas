******************************************;
*** Begin Scoring Code from PROC DMINE ***;
******************************************;

length _WARN_ $ 4;
label _WARN_ = "Warnings";


/*----G_tumor_size begin----*/
length _NORM5 $ 5;
%DMNORMCP( tumor_size , _NORM5 )
drop _NORM5;
select(_NORM5);
  when('0-4' ) G_tumor_size = 1;
  when('15-19' ) G_tumor_size = 1;
  when('20-24' ) G_tumor_size = 3;
  when('25-29' ) G_tumor_size = 2;
  when('30-34' ) G_tumor_size = 4;
  when('35-39' ) G_tumor_size = 2;
  when('40-44' ) G_tumor_size = 1;
  when('44690' ) G_tumor_size = 0;
  when('44848' ) G_tumor_size = 0;
  when('45-49' ) G_tumor_size = 4;
  when('50-54' ) G_tumor_size = 2;
  otherwise substr(_WARN_, 2, 1) = 'U'; 
end;
label G_tumor_size="Grouped Levels for  tumor_size";
/*----tumor_size end----*/

/*----G_inv_nodes begin----*/
length _NORM5 $ 5;
_NORM5 = put( inv_nodes , $5. );
%DMNORMIP( _NORM5 )
drop _NORM5;
select(_NORM5);
  when('0-2' ) G_inv_nodes = 0;
  when('15-17' ) G_inv_nodes = 1;
  when('24-26' ) G_inv_nodes = 2;
  when('44625' ) G_inv_nodes = 1;
  when('44720' ) G_inv_nodes = 1;
  when('44815' ) G_inv_nodes = 1;
  when('44909' ) G_inv_nodes = 2;
  otherwise substr(_WARN_, 2, 1) = 'U'; 
end;
label G_inv_nodes="Grouped Levels for  inv_nodes";
/*----inv_nodes end----*/

/*----G_age begin----*/
length _NORM5 $ 5;
_NORM5 = put( age , $5. );
%DMNORMIP( _NORM5 )
drop _NORM5;
select(_NORM5);
  when('20-29' ) G_age = 0;
  when('30-39' ) G_age = 3;
  when('40-49' ) G_age = 2;
  when('50-59' ) G_age = 1;
  when('60-69' ) G_age = 2;
  when('70-79' ) G_age = 0;
  otherwise substr(_WARN_, 2, 1) = 'U'; 
end;
label G_age="Grouped Levels for  age";
/*----age end----*/

/*----G_breast_quad begin----*/
length _NORM9 $ 9;
%DMNORMCP( breast_quad , _NORM9 )
drop _NORM9;
select(_NORM9);
  when('?' ) G_breast_quad = 3;
  when('CENTRAL' ) G_breast_quad = 0;
  when('LEFT_LOW' ) G_breast_quad = 1;
  when('LEFT_UP' ) G_breast_quad = 0;
  when('RIGHT_LOW' ) G_breast_quad = 1;
  when('RIGHT_UP' ) G_breast_quad = 2;
  otherwise substr(_WARN_, 2, 1) = 'U'; 
end;
label G_breast_quad="Grouped Levels for  breast_quad";
/*----breast_quad end----*/


****************************************;
*** End Scoring Code from PROC DMINE ***;
****************************************;
