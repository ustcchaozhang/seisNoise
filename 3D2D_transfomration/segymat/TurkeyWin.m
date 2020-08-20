function OutputTrace=TurkeyWin(TotalN,StartN,EndN,TurkeyPercent);
% parameter is 1 total point number 2 when window start
% 3 when window end 4 percentage of turkey
OneStart=StartN+(EndN-StartN)*TurkeyPercent/2;
OneEnd=EndN-(EndN-StartN)*TurkeyPercent/2;
OutputTrace(1:TotalN)=0;
for i=1:TotalN
    if i<= StartN
        OutputTrace(i)=0;
    elseif i>StartN && i<=OneStart
        OutputTrace(i)=cos((i-StartN)*pi/(OneStart-StartN)-pi)*0.5+0.5;
    elseif i>OneStart && i<=OneEnd
        OutputTrace(i)=1;
    elseif i>OneEnd && i<=EndN
        OutputTrace(i)=cos((i-OneEnd)*pi/(EndN-OneEnd))*0.5+0.5;
    else
        i=0;
    end
end