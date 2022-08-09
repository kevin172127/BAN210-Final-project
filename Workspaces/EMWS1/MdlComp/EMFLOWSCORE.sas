drop _temp_;
if (P_classrecurrence_events ge 0.86666666666666) then do;
b_class = 1;
end;
else
if (P_classrecurrence_events ge 0.45454545454545) then do;
_temp_ = dmran(1234);
b_class = floor(2 + 4*_temp_);
end;
else
do;
_temp_ = dmran(1234);
b_class = floor(6 + 15*_temp_);
end;
