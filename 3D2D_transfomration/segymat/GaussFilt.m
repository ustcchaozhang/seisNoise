function OutputTrace=GaussFilt(Inputtrace,dist,deltat,T);
% parameter is 1 original waveform 2 source and station distance
% 3 time interval 4 the central piriod
npoint=length(Inputtrace);
AlphaValue=(85.89*dist + 18420)/(dist + 3261);
cenfre=deltat*npoint/T+1;
for i=1:npoint
    GaussWin(i)=exp(-AlphaValue*(i-cenfre)^2/cenfre^2);
end
fftResult=fft(Inputtrace);
for i=1:npoint/2+1
    fftResultAddGau(i)=fftResult(i)*GaussWin(i);
end
for i=2:npoint/2
    fftResultAddGau(npoint-i+2)=conj(fftResultAddGau(i));
end
OutputTrace=real(ifft(fftResultAddGau));