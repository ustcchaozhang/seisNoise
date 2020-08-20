function [frequencyindex,SingleSideSpectrum] =dfft(inputtrace,samplefre)
% dfft is function that do FFT transformation
% input is [one dimensional input trace, sample frequency]
% output is [frequency, amplitude in the frequency]

% check the dimension of inputtrace
[tempa,tempb]=size(inputtrace);
if (tempa ~= 1 && tempb ~= 1)
    error('Error: the input is not a trace, please check!');
else
    LengthOfTrace=length(inputtrace);
end
% core of the code
DoubleSideFFT=fft(inputtrace);
DoubleSideSpectrum=abs(DoubleSideFFT/LengthOfTrace);
SingleSideSpectrum=DoubleSideSpectrum(1:LengthOfTrace/2+1);
SingleSideSpectrum(2:end-1)=2*SingleSideSpectrum(2:end-1);
frequencyindex=samplefre*(0:(LengthOfTrace/2))/LengthOfTrace;