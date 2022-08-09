*;
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
