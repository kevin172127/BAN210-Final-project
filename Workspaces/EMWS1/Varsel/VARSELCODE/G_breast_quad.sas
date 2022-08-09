*;
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
