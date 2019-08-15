function bar_hist = extract_edh(Image)
mysize = size(Image);
if numel(mysize)>2
    gray_img = rgb2gray(Image);
else
    gray_img = Image;
end

[row,col]=size(gray_img);
gray_img=double(gray_img);

% ʹ��canny���ӣ���ȡ��Ե  
edge_canny=edge(gray_img,'canny');  

%�����ݶ�ʸ��Gx,Gy  
for cir1=2:row-1  
    for cir2=2:col-1  
        Gx(cir1,cir2)=sum(gray_img(cir1-1:cir1+1,cir2+1))...  
            -sum(gray_img(cir1-1:cir1+1,cir2-1))...  
            +gray_img(cir1,cir2+1)-gray_img(cir1,cir2-1);  
        Gy(cir1,cir2)=sum(gray_img(cir1+1,cir2-1:cir2+1))...  
            -sum(gray_img(cir1-1,cir2-1:cir2+1))...  
            +gray_img(cir1+1,cir2)-gray_img(cir1-1,cir2);  
        Gx(cir1,cir2)=Gx(cir1,cir2)+(Gx(cir1,cir2)==0)*1e-6; % Ϊ�����ĸΪ0������һ����С��ֵ��  
        theta(cir1,cir2)=atan2(Gy(cir1,cir2),Gx(cir1,cir2))*180/pi;     
        %atan2�������Ե���򣻷�Χ��[-pi,pi]������->�Ƕȣ� [-180,180]  
    end  
end  
   
% ��[-180,180]ÿ10�ȷ�Ϊһ�飬��ô��������Ϊ36 bin  
TH=[-170,-160,-150,-140,-130,-120,-110,-100,-90, -80,-70,-60,-50,-40,-30,-20,-10, 0,10,20,30,40,50,60,70,80,90,100,110,120,130,140,150,160,170,180;...  
    -180,-170,-160,-150,-140,-130,-120,-110,-100,-90,-80,-70,-60,-50,-40,-30,-20,-10,0,10,20,30,40,50,60,70,80,90,100,110,120,130,140,150,160,170];  
% �洢������������Ŀ������  
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