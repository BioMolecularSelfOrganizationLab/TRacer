function [XY] = mappingZMW(img, s)
% uses ZMW images for mapping
% returns centroid coordinates of ZMW grid

% s = threshold factor for max vs mean brightness

% may have to apply gaussian / poissonian filter (blur) to get rid of noise effects.

% substract BG
img = abs(img-mean(img(:)));
img(img(:)<mean(img(:))*1.3) = 0;
% img(img(:)<=mean(img(:))*s) = 0;
    img(img(:)>0) = 1;
    % set borders to zero (ignore 10px):
    img(end-9:end,:) = 0; img(1:10,:) = 0;
    img(:,1:end-9:end) = 0; img(:,1:10) = 0;
    
    %figure; imagesc(img); %DEBUG binarized data
    r = regionprops(bwconncomp(img),'Centroid','Eccentricity','Area');
    % filter out artifacts
    %d = d([d.Eccentricity]>0.3);
    %r = r([r.Area] > mean([r.Area])*0.7 & [r.Area] < mean([r.Area])*1.75 & ...
     r = r([r.Eccentricity]<=mean([r.Eccentricity])*1.75 & [r.Area] > mean([r.Area])*0.5 & [r.Area] < mean([r.Area])*2);
    [XY] =reshape([r.Centroid],2,[])';
    
end