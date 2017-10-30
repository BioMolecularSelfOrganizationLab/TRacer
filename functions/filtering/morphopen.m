%% MORPHOPEN function
% Reduces background noise by morphological filtering

%% INPUT arguments
% * _inimg:_ image stack
% * _SE:_ structuring element for morphological opening
%

%% OUTPUT arguments
% * *outimg:* processed image
%


function [outimg] = morphopen(inimg,SE)
outimg = zeros(size(inimg));
for i = 1:size(inimg,3)
outimg(:,:,i) = inimg(:,:,i) - imopen(inimg(:,:,i), SE);
end
end

%%
% 
%  written by Bassem Salem, 2014
% 
