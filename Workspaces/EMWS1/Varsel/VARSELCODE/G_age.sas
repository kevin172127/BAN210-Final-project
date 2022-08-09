*;
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
