function plot_image(inputfile,xstart,xend,zstart,zend,xitl,zitl)
A=load(inputfile);
xline=xstart:xitl:xend;
zline=zstart:zitl:zend;
[xq zq]=meshgrid(xline,zline);
Aq=griddata(A(:,1),A(:,2),A(:,3),xq,zq);
imagesc(xline,zline,Aq);
colorbar;