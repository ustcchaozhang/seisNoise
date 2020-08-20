function []=plot_trace(A,sample_frequancy,color)
% the code plot traces in a 2D array
% input is [array with the trace included, sample frequency]
% output is a image of the traces

maxA=max(max(A));
deltat=1/sample_frequancy;
[nstep,trace]=size(A);
for i=1:trace
    plot(deltat:deltat:nstep*deltat,A(:,i)+maxA*2*i,color);
    hold on;
    set(gca,'ytick',[]);
    %set(gca,'xtick',[]);
    %set(gca,'box','off');
end
end