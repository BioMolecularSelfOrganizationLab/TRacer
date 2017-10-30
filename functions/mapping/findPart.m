function [XY] = findPart(I, P, B, m)
% r: rad of particle crop
% P: psf mask
% B: BG mask
% m: method for background eval

% apply bandpass filter and smooth
warning off MATLAB:colon:nonIntegerIndex; % to prevent subindex adressing warnings

fI = bpass(I,1,7);
% fI = imfilter(I, fspecial('gaussian',[7,7],0.5));

% use different algorithm for low signal images (no max projection)
SNR = mean(I(:))/var(I(:));
if SNR > 0
    fI2 = zeros(size(fI));
    fI2(fI>0.03*max(fI(:))) = 1;
    bw = bwmorph(fI2,'erode');
    s = regionprops(bw,'Centroid');
    rMax = [s.Centroid];
    XY = fliplr((reshape(rMax,2,[]))');
    
else
    %find local maxima
    rMax = imregionalmax(fI);
    r = (size(B,1)-1)/2;
    %throw away borders:
    d = 3*r;
    rMax(1:d,:)=0;rMax(end-d+1:end,:)=0;rMax(:,end-d+1:end)=0;rMax(:,1:d)=0;
    
    [ty,tx] = find(rMax==1); %coord of local max. ty=row; tx=col
    % DEBUG
    % figure, ax = axes('NextPlot','add'); imagesc(rMax, 'Parent',ax); scatter(ax, tx(:),ty(:), 'o','w');
    % find true centroids by feeding into rad sym
    % XY = zeros(numel(tx),2);
    j = 0;
%     t = mean(fI(:));
%     t2 = var(fI(:));
    
    
    for i=1:numel(tx)
        cI = fI(ty(i)-r:ty(i)+r,tx(i)-r:tx(i)+r);
        V(i) = var(var(cI*B));
        %     if mean(fI(ty(i)-1:ty(i)+1,tx(i)-1:tx(i)+1))>=t
        if mean(mean(cI*P))/V(i) > 9.3341e-09*2  % bc of uint16 to double conv
            j = j + 1;
            cI = fI(ty(i)-r:ty(i)+r,tx(i)-r:tx(i)+r);
            [y,x] =  radialcenter(cI);
            xy(j,1:2) = [ty(i),tx(i)] - r-1 + [y,x];
            %         nI = I(xy(j,1)-r:xy(j,1)+r,xy(j,2)-r:xy(j,2)+r);
            % get of particles with weird background
            %         if filterPart(nI,B,'Variance', 0.001)
            XY(j,1:2) = xy(j,1:2);
            %         end
            %
            
            %% function for bg filtering here
            
            
        end
        
    end
    if ~exist('XY')
        XY = [];
        return;
    end
%     filter out particles that are closer than the PSF radius
    
    
end
    D = squareform(pdist(XY(:,1:2),'euclidean'));
    %XY((max(D>0&D<5)),:) = [];
    XY = XY(max(D>9),:);
warning on MATLAB:colon:nonIntegerIndex;
% DEBUG
%figure, ax = axes('NextPlot','add'); imagesc(fI, 'Parent',ax); scatter(ax,XY(:,2),XY(:,1),'o','w'); %scatter(ax, tx(:),ty(:), 'o','w');
end
