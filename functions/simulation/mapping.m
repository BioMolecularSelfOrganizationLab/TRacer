%% MAPPING() function
%
%   Detects particles withing provided image
%   by B.Salem, 2014
%% INPUT args:
%* _img:_ (as 3D stack: x|y|frame(s)
%* _pSize:_ Particle diameter = also half the border size to be excluded 
%* _thresh:_ Particles brightness threshold for background separation
%% OUTPUT args:
%* _x:_ Array containing detected x coordinates
%* _y:_ Array containing detected y coordinates
function [y,x] = mapping( img, pSize, thresh )
%MAPPING Summary of this function goes here
%   Detailed explanation goes here

% average over stack:
avg = mean(img(:,:,:),3);

% eliminate borders and pad with zeros
avg = padmatrix(avg(ceil(pSize/2):size(avg,1)-ceil(pSize/2),ceil(pSize/2):size(avg,2)-ceil(pSize/2)),size(avg));

% dilate img using strel() structuring element
dimg = imdilate(avg, strel('disk', floor(pSize/2),0));

% detect local maxima
lmax = (avg == dimg);

%thresholding with brightest percentile
[hs, bins] = hist(avg(:),1000); %convert to histogram function later

ch = cumsum(hs);
ch = ch/max(ch); %normalize to max=1
noiseind = find(ch > thresh); % filter out only particles with brightness > thresh
noiseind = noiseind(1); % this is the lowest bin to use for detection

% return coordinates of fitting particles
[y,x] = find(lmax & (avg > bins(noiseind))); 

% detect with max. brightness and perform radial symmetry fit

%% DEBUGGING
% plot image
figure;
plax = axes('NextPlot','add');
imshow(avg,[min(avg(:)),max(avg(:))]);


% plot particles
for i = 1:numel(x)
     r(i) = rectangle('Parent', plax, ...
                'Curvature', [1,1], ...
                'Position', [[x(i),y(i)]-floor(pSize / 2),pSize + 1,pSize + 1], ...
                'EdgeColor','r');
end
end

