function []=cmp_su_band(filename1,amlitude_factor1,filename2,amlitude_factor2,lowlimit,highlimit,deltat)
% parameters:
% filename1,amlitude_factor1,filename2,amlitude_factor2,lowlimit,highlimit,deltat

[a,b,~]=ReadSu(filename1);
[ao,bo,~]=ReadSu(filename2);
[nstep,trace]=size(a);
for i=1:trace
    temp1=bandpass(a(:,i),lowlimit,highlimit,deltat);
    temp2=bandpass(ao(:,i),lowlimit,highlimit,deltat);
    plot(deltat:deltat:nstep*deltat,temp1*amlitude_factor1+b(i).GroupX/1000,'k','LineWidth',1.2);
    hold on;
    if max(a(:,i))~=0
        plot(deltat:deltat:nstep*deltat,temp2*amlitude_factor2+bo(i).GroupX/1000,'r','LineWidth',1.2);
    end
end
xlabel('time/s');
ylabel('distance/km');
ylim([0 600]);
title([num2str(lowlimit),'s - ',num2str(highlimit),'s']);

end