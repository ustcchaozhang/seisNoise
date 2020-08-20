clc
clear all
close all
vs=load('mod0.txt');
x=0:0.03:18;
z=0:0.03:1.8;
lenz=length(z);
lenx=length(x);
k=0;

for i=1:lenz % z axis
    for j=1:lenx % x axis
        k=k+1;
        model(k,1)= x(j);    % x
        model(k,2)= z(i);    % z (from z=0 km)
        model(k,3)= 0;       % vp
        model(k,4)= vs(i,j); % vs
        model(k,5)= 0;       % rho  
        % For vp and rho, we use empirical function
        model(k,3) = 0.9409 + 2.0947*model(k,4) - 0.8206*model(k,4)^2+ 0.2683*model(k,4)^3 - 0.0251*model(k,4)^4;     
        model(k,5) = 1.6612*model(k,3) - 0.4721*model(k,3)^2 + 0.0671*model(k,3)^3 - 0.0043*model(k,3)^4 + 0.000106*model(k,3)^5;                         
        model(k,6) = 9.999;
        model(k,7) = 9.999;     
    end
end
model=model*1000;

% save as tomo_file.xyz in specfem2d
fileID=fopen(['../DATA/tomo_file.xyz'],'w');
fprintf(fileID,'%f %f %f %f\n', min(model(:,1)),min(model(:,2)),max(model(:,1)), max(model(:,2)));
fprintf(fileID,'%f %f \n', max(model(:,1))/(lenx-1), max(model(:,2))/(lenz-1));
fprintf(fileID,'%d %d \n', lenx,lenz);
fprintf(fileID,'%f %f %f %f %f %f %f %f %f %f\n', min(model(:,3)), max(model(:,3)),min(model(:,4)), max(model(:,4)), min(model(:,5)), max(model(:,5)), 9999.0,9999.0,9999.0,9999.0 );
length(model(:,1))
for i=1:length(model(:,1))
 fprintf(fileID,'%f %f %f %f %f %f %f \n',model(i,1),model(i,2),model(i,3),model(i,4),model(i,5),9999.0,9999.0);
end
exit
%%
