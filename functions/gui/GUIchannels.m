function h = GUIchannels(C,I)


%function h = GUIchannels(G)

C.Crop = [];
h = figure(...
    'Name','Channel Position',...
    'Units','normalized',...
    'NumberTitle','off',...
    'MenuBar', 'none',...
    'Toolbar', 'none',...
    'Resize','off',...
    'OuterPosition', [0.2,0.2,0.6,0.6]);

p = uipanel('Parent',h, ...
    'Title','Preview',...
    'Position',[.02,.03,.46,.94]);

ax = axes(...
    'Parent',p,...
    'Position',[.03,.02,.94,.97],...
    'YDir','reverse',...
    'XTick',[],'YTick',[],...
    'XLabel',[],'YLabel',[],...
    'box','off',...
    'PlotBoxAspectRatio',  [1,1,1],...
    'NextPlot','replacechildren');

%imagesc(I,'Parent', ax);
updatePreview(C, ax, I);

c = uipanel('Parent',h, ...
    'Title','Channel Layout',...
    'Position',[.49,.03,.31,.94]);

uicontrol(...
    c,...
    'Style', 'pushbutton',...
    'String', 'Left',...
    'units', 'normalized',...
    'Position', [.1,.3,.2,.4],...
    'Callback', {@channelPosition, ax, I, C});

uicontrol(...
    c,...
    'Style', 'pushbutton',...
    'String', 'Right',...
    'units', 'normalized',...
    'Position', [.7,.3,.2,.4],...
    'Callback', {@channelPosition, ax, I, C});

uicontrol(...
    c,...
    'Style', 'pushbutton',...
    'String', 'Upper',...
    'units', 'normalized',...
    'Position', [.3,.7,.4,.2],...
    'Callback', {@channelPosition, ax, I, C});

uicontrol(...
    c,...
    'Style', 'pushbutton',...
    'String', 'Lower',...
    'units', 'normalized',...
    'Position', [.3,.1,.4,.2],...
    'Callback', {@channelPosition, ax, I, C});

uicontrol(...
    c,...
    'Style', 'pushbutton',...
    'String', 'Full',...
    'units', 'normalized',...
    'Position', [.3,.3,.4,.4],...
    'Callback', {@channelPosition, ax, I, C});


r = uibuttongroup(...
    'Title','Rotation (clockwise)',...
    'Parent', h,...
    'Position',[.81,.52,.18,.45],...
    'SelectionChangedFcn',{@channelOrientation, ax, I, C});

uicontrol(...
    r,...
    'Style', 'radiobutton',...
    'String', '0�',...
    'units', 'normalized',...
    'Position', [.05,.8,.9,.1]);

uicontrol(...
    r,...
    'Style', 'radiobutton',...
    'String', '90�',...
    'units', 'normalized',...
    'Position', [.05,.65,.9,.1]);

uicontrol(...
    r,...
    'Style', 'radiobutton',...
    'String', '180�',...
    'units', 'normalized',...
    'Position', [.05,.5,.9,.1]);

uicontrol(...
    r,...
    'Style', 'radiobutton',...
    'String', '270�',...
    'units', 'normalized',...
    'Position', [.05,.35,.9,.1]);

o = uipanel('Parent',h, ...
    'Title','Flip',...
    'Position',[.81,.15,.18,.36]);

uicontrol(...
    o,...
    'Style', 'checkbox',...
    'String', 'Horizontal Flip',...
    'units', 'normalized',...
    'Position', [.05,.6,.9,.15],...
    'Callback', {@channelFlip, ax, I, C});

uicontrol(...
    o,...
    'Style', 'checkbox',...
    'String', 'Vertical Flip',...
    'units', 'normalized',...
    'Position', [.05,.35,.9,.15],...
    'Callback', {@channelFlip, ax, I, C});

uicontrol(...
    h,...
    'Style', 'pushbutton',...
    'String', 'OK',...
    'units', 'normalized',...%    'BackgroundColor', [193,255,132]/256,...
    'Position', [.81,.03,.18,.1],...
    'Callback', {@channelDone, C});


end

function C =  channelFlip(hObj,~,ax, I, C)
if isempty(C.Flip); C.Flip = [0,0];end
switch hObj.String
    case 'Vertical Flip'
        C.Flip(1) = hObj.Value;
    case 'Horizontal Flip'
        C.Flip(2) = hObj.Value;
end

updatePreview(C, ax, I);
end


function C =  channelOrientation(~,callbackdata,ax,I,C)
c = callbackdata.NewValue;
C.Rotation = str2double(c.String(1:end-1));

updatePreview(C, ax, I);
end

function C =  channelPosition(hObj,~,ax,I,C)

switch hObj.String
    case 'Left'
        C.Crop = [1,1;512,256];
    case 'Right'
        C.Crop = [1,257;512,512];
    case 'Lower'
        C.Crop = [1,1;256,512];
    case 'Upper'
        C.Crop = [257,1;512,512];
    case 'Full'
        C.Crop = [1,1;512,512];
        
end

[hObj.Parent.Children.BackgroundColor] = deal([.94,.94,.94]);
hObj.BackgroundColor = [0.7695    0.8711    0.9570];
updatePreview(C, ax, I);

end

function updatePreview(C, ax, I)
% updates preview axes
%Crop 

if ~isempty(C.Crop)
    p = I(C.Crop(1,1):C.Crop(2,1),C.Crop(1,2):C.Crop(2,2));
else
    p = I;
end

%Rotation
if ~isempty(C.Rotation)
    p =   imrotate(p ,-C.Rotation);
end

%Flip
if ~isempty(C.Flip)
    if C.Flip(1) == 1; p = flipud(p);end
    if C.Flip(2) == 1; p = fliplr(p);end
end

% show
image('CData', p,'Parent',ax, 'CDataMapping', 'scaled');
ax.XLim = [1,size(p,2)];
ax.YLim = [1,size(p,1)];
end


function C =  channelDone(hObj,~,C)
delete(hObj.Parent);
end