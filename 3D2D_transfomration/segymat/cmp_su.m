function []=cmp_su(filename1,amlitude_factor1,filename2,amlitude_factor2,deltat)

[a,b,~]=ReadSu(filename1);
[ao,bo,~]=ReadSu(filename2);
[nstep,trace]=size(a);
for i=1:trace
    plot(deltat:deltat:nstep*deltat,a(:,i)*amlitude_factor1+b(i).GroupX/1000,'k','LineWidth',1.2);
    hold on;
    plot(deltat:deltat:nstep*deltat,ao(:,i)*amlitude_factor2+bo(i).GroupX/1000,'r','LineWidth',1.2);
end

end