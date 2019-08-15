function [index , labelnames] = SearchImage(sketch)
% load mydata.mat %读取rS压缩过的,P2,sketch_centers,sampleIndex_tr,ImageNetID,Category,anchor2, sigma2
global  myP2 myS mySampleIndex_tr net myImageNetID myCategory Drawing mymean
% net = vgg19;
% [X,Y] = find(Drawing == 0);
% xmin = min(X)-10;
% ymin = min(Y)-10;
% xmax = max(X)+10;
% ymax = max(Y)+10;
% % rect = [xmin,ymin,xmax-xmin,ymax-ymin];
% rect = [ymin,xmin,ymax-ymin,xmax-xmin];
% sketch = imcrop(sketch,rect);
Sketch1 = imresize(sketch, [256 256]);
Sketch = imresize(sketch, [224 224]);
Sketch(:,:,1) = Sketch(:,:,1) - 103.939;
Sketch(:,:,2) = Sketch(:,:,2) - 116.779;
Sketch(:,:,3) = Sketch(:,:,3) - 123.68;
% 提取pool5层特征
pool5 = activations(net,Sketch,'pool5','OutputAs','channels');
% 池化，降采样
[outputMap, ~] =  avg_pooling(pool5, 7, 7, 7);
h = reshape(outputMap,[1 512]);
h1 = extract_edh(Sketch1);
h = [h,h1];
h = bsxfun(@minus, h, mymean);
h = sign(myP2*h');
h = bitCompact( h' >= 0 );
hamm = hammingDist(h, myS);
[~, ind] = sort(hamm);
myind = mySampleIndex_tr(ind);
index = unique(myImageNetID(myind),'stable');
all_label = unique(myCategory(myind),'stable');
labelnames = all_label(1:4);







