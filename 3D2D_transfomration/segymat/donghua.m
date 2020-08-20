num=19;
for i=1:num
    str = strcat(num2str(i), '.jpg');
    A=imread(str);
    [I,map]=rgb2ind(A,256);
    if(i==1)
        imwrite(I,map,'movefig.gif','DelayTime',0.1,'LoopCount',Inf)
    else
        imwrite(I,map,'movefig.gif','WriteMode','append','DelayTime',0.3)    
    end
end

%此时需将倒数第三行中的append改为overwrite然后运行后再改回append，就可以生成一幅GIF动画了。

