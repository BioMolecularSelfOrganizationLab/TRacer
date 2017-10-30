function C = createMap(C)

% creates transformation maps between channels for alignment
% this is a class function
% C: TIRFdata class

ref = C.Parent.MappingReferenceChannel;
D  = C.Parent.Channel{ref}; % reference mapping channel TIRFdata class handle

if ~isempty(C.MapParticles)
    %%M{i}.XY = repmat(fliplr(XY),1,2);
    
    
    %         M{i}.XY = repmat(mappingZMW(M{i}.cum,C.mapthresh),1,2);
    
    % !-- determine relative angles, rotate and shift matrix for
    % preliminary overlap
    
    %select particles closest to map line endpoints
    for i=1:2
        [A,B] = pdist2(D.MapLine(i,:),D.MapParticles,'euclidean','Smallest',1);
        % if more than one particle is found in vicinity of ent
        
        D.MapLine(i,:) = D.MapParticles(A(:)<=7,:);
        [A,B] = pdist2(C.MapLine(i,:),C.MapParticles,'euclidean','Smallest',1);
        C.MapLine(i,:) = C.MapParticles(A(:)<=7,:);
    end
    as = D.MapLine(2,:) - D.MapLine(1,:); bs = C.MapLine(2,:) - C.MapLine(1,:); % calc relative shift vector
    
    alpha = -real(acos(dot(as,bs)/(norm(as)*norm(bs)))); %  angle of rotation
    % rotation matrix invariant about z axis (it has to be 3D for
    % affine2d
    R = affine2d([cos(alpha),-sin(alpha),0;sin(alpha),cos(alpha),0;0,0,1]);
    
    offs = repmat(C.MapLine(2,:) - (bs/2),[size(C.MapParticles,1),1]);
    offs2 = repmat(mean(C.MapLine-D.MapLine),[size(C.MapParticles,1),1]);
    
    %%M{i}.XY(:,1:2) = M{i}.XY(:,1:2) - offs;
    % center matrices
    % shift matrix back and correct relative shift
    
    C.MapParticlesTransformed = transformPointsForward(R, C.MapParticles - offs) + offs - offs2;
    
    % --!
    XY2 = [C.MapParticlesTransformed,C.MapParticles]; % duplicate XY2 coordinates to preserve original coords for mapping
    [XY1,XY2] = findPairs(D.MapParticles,XY2, 4);
    %XY2 = XY2(:,3:4);
    %         try
    %cpselect(C.RawMap, D.RawMap,fliplr(XY2(:,3:4)), fliplrs(XY1));
    C.MapToReference = fitgeotrans(fliplr(XY2(:,3:4)), fliplr(XY1), 'polynomial',4);
    C.MapFromReference = fitgeotrans(fliplr(XY1), fliplr(XY2(:,3:4)), 'polynomial',4); % create backwards xform map just in
end

%% DEBUGGING
% display mapping results...

% prepare fused image
a = D.RawMap; % reference image
b = imwarp(C.RawMap, C.MapToReference, 'OutputView', imref2d(size(D.RawMap))); % relatively warped image using transformation matrix


RGB=zeros([size(a),3]);
a(a(:)<mean(a(a>0))+std(a(a>0)))=0;b(b(:)<mean(b(b>0))+std(b(b>0)))=0;%c(c(:)<mean(c(c>0))+2*std(c(c>0)))=0;
RGB(:,:,1) = a/max(a(:));RGB(:,:,2) = b/max(b(:));%RGB(:,:,3) = c/max(c(:));



% generate transparency
alpha = ones(size(a));
alpha(sum(RGB,3)==0)=0;

% prepare axes and load fused image..
figure;
ax=axes(...
    'Color','black',...
    'YDir', 'reverse',... 
    'XTick',[],'YTick',[],...
    'XLabel',[],'YLabel',[],...
    'XLimMode','manual',....
    'YLimMode','manual',....
    'YLim',[1,size(a,1)],'XLim',[1,size(a,2)],...
    'Box','on',...
    'PlotBoxAspectRatio',  [1,1,1],...
    'NextPlot', 'add',...
    'Visible','on');
image(RGB,'AlphaData',alpha,'Parent',ax);
C.MapResultImage = RGB;
%scatter(XY2(:,4),XY2(:,3),'o','r');
%scatter(XY2(:,2),XY2(:,1),'square','w');
%scatter(XY1(:,2),XY1(:,1),'x','b');
for i=1:size(XY1,1)
    %    text(XY2(i,2)-5,XY2(i,1),num2str(i),'Color','white');
    text(XY1(i,2)+2,XY1(i,1)+5,num2str(i),'Color','white','FontSize',6);
end
end