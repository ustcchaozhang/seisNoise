function []=plot_su(filename,amplitude_factor)

[a,b,c]=ReadSu(filename);
[nstep,trace]=size(a);
for i=1:trace
    plot(0.001:0.001:nstep*0.001,a(:,i)*amplitude_factor+b(i).GroupX/1000,'k');
    hold on;
end

end