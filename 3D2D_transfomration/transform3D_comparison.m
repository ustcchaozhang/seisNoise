clear;
close all
%% parameter
% input data length and ramsampling frequency
TmMax=149.98;
RsmFre=50;
% output data length and frequncy
% time_shift is 1.2/f
out_time_max=150;
out_fre=50;
DT=1.0/out_fre;
time_shift=0.0;
% station number
StaNum=38;
lat_start=35.76540000;
lon_start=-122.48215225;

% input data path
DataPath='./data_for_3D_2D_comparison/';
stafile='./model/station.txt';
comp1='z';
comp2='z';
% time series and time shift information
tm=0:1/RsmFre:TmMax;
tm_size=length(tm);
tm_out=0:1/out_fre:(out_time_max-1/out_fre);
tm_out_size=length(tm_out);


%% read station list
StaInf = struct('netw','','name','','comp','','lat',0,'lon',0,'elev',0);
D=importdata(stafile);
data=D.data;
textdata=D.textdata;
for i=1:StaNum
    StaInf(i).netw='ZZ';
    StaInf(i).name=char(textdata(i+1,2));
    StaInf(i).comp='BXZ';
    StaInf(i).lat =data(i,1);
    StaInf(i).lon =data(i,2);
    StaInf(i).elev=data(i,3);
end

%% read 3D data

Data=zeros(StaNum,StaNum,tm_size);
for VirSou=1:1
    num1=floor(VirSou/10);
    num2=mod(VirSou,10);
    for i=1:StaNum
        TempName=dir([DataPath,'/',StaInf(i).netw,'.',StaInf(i).name,'.',StaInf(VirSou).comp,'.semd']);
        [DataPath,StaInf(i).netw,'.',StaInf(i).name,'.',StaInf(VirSou).comp,'.semd']
        if (isempty(TempName)==0)
            FileName=[DataPath,TempName.name];
            TempData=load(FileName);
            Data(VirSou,i,:)=TempData(1:end,2);
        end
    end
end

%taper the beginning of the data for stable fft, maybe not necessary
taper=zeros(1,1,tm_size);
ntaper=16;
for it=1:tm_size
    if it<=ntaper
        taper(1,1,it)=1.0-exp(double(log(0.0625)*it*it/ntaper/ntaper));
    elseif it>=tm_size-ntaper
        taper(1,1,it)=exp(double(log(0.0625)*(it+ntaper-tm_size)*(it+ntaper-tm_size)/ntaper/ntaper));
    else
        taper(1,1,it)=1.0;
    end
end

%calculating the offset
sta_loc=zeros(1,StaNum);
offset=zeros(1,StaNum);
for i=1:StaNum
    sta_loc(i)=distance(StaInf(i).lat,StaInf(i).lon,lat_start,lon_start)*111195;
end
traceHilb=zeros(StaNum,StaNum,tm_size);
for VirSou=1:StaNum
    for i=1:StaNum
        Data(VirSou,i,:)=Data(VirSou,i,:).*taper;
        offset(i)=sta_loc(i)-sta_loc(VirSou);
        transform=dimension_transformation(reshape(Data(VirSou,i,:),tm_size,1),tm',offset(i));
        traceHilb(VirSou,i,:)=reshape(transform,1,1,tm_size);
    end
end


shot3D=reshape(Data(1,:,:),StaNum,tm_size)';
shot3D2D=reshape(traceHilb(1,:,:),StaNum,tm_size)';
shot2D=ReadSu('data_for_3D_2D_comparison/shot2D.su');


%data normalization and plotting

shot2D=shot2D./(max(abs(shot2D))+1.0e-6);
shot3D=shot3D./(max(abs(shot3D))+1.0e-6);
shot3D2D=shot3D2D./(max(abs(shot3D2D))+1.0e-6);
shot2D_p=zeros(size(shot2D));
shot3D_p=zeros(size(shot3D));
shot3D2D_p=zeros(size(shot3D2D));

for ir=1:StaNum
    shot2D_p(:,ir)=shot2D(:,ir)+2*(ir-1);
    shot3D_p(:,ir)=shot3D(:,ir)+2*(ir-1);
    shot3D2D_p(:,ir)=shot3D2D(:,ir)+2*(ir-1);
end
XT=(0:1.0/RsmFre:TmMax)'-2.4;
figure 
h1=plot(XT,shot2D_p,'r','linewidth',1.5);
xlim([-2.4 80])
hold on
h2=plot(XT,shot3D_p,'b','linewidth',1.5);
xlim([-2.4 80])
legend([h1(1) h2(1)],'2D','3D')
ylabel('Station','fontsize',12,'Fontname','times new Roman');
xlabel('Time (s)','fontsize',12,'Fontname','times new Roman');
set(gca,'linewidth',1);
set(gcf,'color','w');
set(gcf,'position',[100 100 800 400]);



figure 
h1=plot(XT,shot2D_p,'r','linewidth',1.5);
xlim([-2.4 80])
hold on
h2=plot(XT,shot3D2D_p,'b','linewidth',1.5);
xlim([-2.4 80])
legend([h1(1) h2(1)],'2D','3D2D')
ylabel('Station','fontsize',12,'Fontname','times new Roman');
xlabel('Time (s)','fontsize',12,'Fontname','times new Roman');
set(gca,'linewidth',1);
set(gcf,'color','w');
set(gcf,'position',[100 100 800 400]);

