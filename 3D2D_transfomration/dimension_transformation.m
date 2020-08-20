%by BinHe(binbebj@gmail.com, hebin14@mails.ucas.ac.cn) at University of Toronto, 2020-07-01
%more theory details can be found from 'Line-source simulation for shallow-seismic data. Part 1: theoretical background', 2014
%please pay attention that the fft in matlab is different with the defination in this paper
%if you use this code, please also kindly cite the paper: 
%Zhang, C., Yao, H., Liu, Q., Zhang, P., Yuan, Y. O., Feng, J., & Fang, L. (2018). Linear array ambient noise adjoint tomography reveals intense crustmantle interactions in North China craton. Journal of Geophysical Research:Solid Earth, 123, 368–383. https://doi.org/10.1002/2017JB015019
function y=dimension_transformation(trace,xt,offset)
    dt=xt(2)-xt(1);
    nt=length(xt);
    fx=fft(trace);
    xw=zeros(size(xt));
    dw=2.*pi/(nt*dt);
    for iw=1:floor(nt/2)+1
        xw(iw)=(iw-1)*dw;
    end
    for iw=floor(nt/2)+2:nt
        xw(iw)=(iw-nt-1)*dw;
    end
    xw(1)=0.1*dw;
    fft_sqrt_inv_xt=sqrt(pi/2)./sqrt(abs(xw)).*(1-sign(xw)*i);
    y1=ifft(fft_sqrt_inv_xt.*fx);
    sqrt_inv_xt=1.0./sqrt(xt+32*dt);
    y2=real(y1).*sqrt_inv_xt;
    taper=zeros(nt,1);
    ntaper=16;
    for it=1:nt
        if it<=ntaper
            taper(it)=1.0-exp(double(log(0.0625)*it*it/ntaper/ntaper));
        elseif it>=nt-ntaper
            taper(it)=exp(double(log(0.0625)*(it+ntaper-nt)*(it+ntaper-nt)/ntaper/ntaper));
        else
            taper(it)=1.0;
        end
    end
    y3=y2*sqrt(2)*abs(offset).*taper;
    y=y3;
end