function []=plot_lt(A,B);
maxA=max(max(A));
[nstep,trace]=size(A);
dt=0.001;
for i=1:trace
    plot(dt:dt:nstep*dt,A(:,i)+maxA*2*i,'k','LineWidth',1);
    hold on;
    plot(dt:dt:nstep*dt,B(:,i)+maxA*2*i,'r','LineWidth',1);
    hold on;
    set(gca,'ytick',[]);
    %set(gca,'xtick',[]);
    %set(gca,'box','off');
end
end