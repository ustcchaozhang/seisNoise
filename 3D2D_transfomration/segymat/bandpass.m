function outputtrace=bandpass(trace,lowlimit,highlimit,deltat);
%% 
[t1 t2]=butter(2,[2*deltat/highlimit 2*deltat/lowlimit]);
outputtrace=filtfilt(t1,t2,trace);