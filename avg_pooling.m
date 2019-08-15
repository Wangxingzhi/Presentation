function [outputMap, outputSize] =  avg_pooling(inputMap, inputSize, poolSize, poolStride)
% ==========================================================
% INPUTS:
%        inputMap - input map of the max-pooling layer
%        inputSize - X-size(equivalent to Y-size) of input map
%        poolSize - X-size(equivalent to Y-size) of receptive field
%        poolStride -  the stride size between successive pooling squares.
% OUTPUT:
%        outputMap - output map of the max-pooling layer
%        outputSize - X-size(equivalently, Y-size) of output map
% ==========================================================
outputSize = inputSize/ poolStride;
inputChannel = size(inputMap, 3);

padMap = padarray(inputMap, [poolSize poolSize],0, 'post');
outputMap = zeros(outputSize, outputSize, inputChannel, 'single');

for j = 1:outputSize
    for i = 1:outputSize
        startX = 1 + (i-1)*poolStride;
        startY = 1 + (j-1)*poolStride;
        poolField = padMap(startY:startY+poolSize-1,startX:startX+poolSize-1,:);
        poolOut = mean(reshape(poolField, [poolSize*poolSize,inputChannel]));
        outputMap(j,i,:) = reshape(poolOut,[1 1 inputChannel]);
    end
end