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
