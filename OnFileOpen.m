function filename=OnFileOpen()  
%UNTITLED1 Summary of this function goes here  
%  Detailed explanation goes here  
[filename,filepath]=uigetfile('*.jpg;*.tif;*.png;*.gif','���ļ�');%gui�д��ļ�  
%file=[filename,filepath];  
%fid=fopen(file,'rt');%read txt  
  
filename=strcat(filepath,filename);  

% %filep  
% workImg=imread(filep);