function yshift = phase_shift(y,phase)

npts=length(y);

Y=fft(y);

Yshift=nan*ones(npts,1);
npth=floor(npts/2);

if npth*2~=npts
    Yshift(1)=Y(1);
    for i=1:npth
        Yshift(i+1)=Y(i+1)*exp(-phase*1i);
        Yshift(npth+i+1)=Y(npth+i+1)*exp(phase*1i);
    end
else
    for i=1:npth
        if i==1
            Yshift(i)=Y(i);
            Yshift(npth+i)=Y(npth+i)*exp(phase*1i);
        else
            Yshift(i)=Y(i)*exp(-phase*1i);
            Yshift(npth+i)=Y(npth+i)*exp(phase*1i);
        end
    end
end

yshift=real(ifft(Yshift));

end