function bar_hist = extract_edh(Image)
mysize = size(Image);
if numel(mysize)>2
    gray_img = rgb2gray(Image);
else
    gray_img = Image;
end

[row,col]=size(gray_img);
gray_img=double(gray_img);

% 使用canny算子，提取边缘  
edge_canny=edge(gray_img,'canny');  

%计算梯度矢量Gx,Gy  
for cir1=2:row-1  
    for cir2=2:col-1  
        Gx(cir1,cir2)=sum(gray_img(cir1-1:cir1+1,cir2+1))...  
            -sum(gray_img(cir1-1:cir1+1,cir2-1))...  
            +gray_img(cir1,cir2+1)-gray_img(cir1,cir2-1);  
        Gy(cir1,cir2)=sum(gray_img(cir1+1,cir2-1:cir2+1))...  
            -sum(gray_img(cir1-1,cir2-1:cir2+1))...  
            +gray_img(cir1+1,cir2)-gray_img(cir1-1,cir2);  
        Gx(cir1,cir2)=Gx(cir1,cir2)+(Gx(cir1,cir2)==0)*1e-6; % 为避免分母为0，加上一个很小的值。  
        theta(cir1,cir2)=atan2(Gy(cir1,cir2),Gx(cir1,cir2))*180/pi;     
        %atan2：计算边缘方向；范围：[-pi,pi]；弧度->角度： [-180,180]  
    end  
end  
   
% 将[-180,180]每10度分为一组，那么方向被量化为36 bin  
TH=[-170,-160,-150,-140,-130,-120,-110,-100,-90, -80,-70,-60,-50,-40,-30,-20,-10, 0,10,20,30,40,50,60,70,80,90,100,110,120,130,140,150,160,170,180;...  
    -180,-170,-160,-150,-140,-130,-120,-110,-100,-90,-80,-70,-60,-50,-40,-30,-20,-10,0,10,20,30,40,50,60,70,80,90,100,110,120,130,140,150,160,170];  
% 存储各方向像素数目的数组  
bar_hist= zeros(1,36);  
   
%edge_theta=theta&edge_canny;  
for cir1=1:row  
    for cir2=1:col  
        for k=1:36  
            if (edge_canny(cir1,cir2)==1 & theta(cir1,cir2)<TH(1,k) & theta(cir1,cir2)>=TH(2,k))  
                bar_hist(k)=bar_hist(k)+1;  
            end  
        end  
    end  
end  
bar_hist=bar_hist/sum(bar_hist);  