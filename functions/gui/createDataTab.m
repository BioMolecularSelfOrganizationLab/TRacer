function G = createDataTab( G )
% Creates GUI for Image Tab

T = G.Parent;
h = G.Handles.Figure;

% UI containers Data Tab

h.Tabs.Data.MainPanel.Main = uicontainer(h.Tabs.Data.Main, 'Position', [0,0,G.Panel.WidthMainPanel,1], 'Units', 'normalized', 'BackgroundColor', G.DefaultColors.BackColor);
h.Tabs.Data.SidePanel.Main = uicontainer(h.Tabs.Data.Main, 'Position', [G.Panel.WidthMainPanel,0,G.Panel.WidthSidePanel,1], 'BackgroundColor', G.DefaultColors.BackColor);


h.Tabs.Data.MainPanel.ChannelPanel.Main = uipanel(...
    'Parent', h.Tabs.Data.MainPanel.Main, ...
    'Title', 'Particle Detection',...
    'BackgroundColor',G.DefaultColors.BackColor,...
    'Position',[0,0,1,1]);

h.Tabs.Data.MainPanel.ChannelPanel.DataAxes.Main = axes(...
    'Parent',h.Tabs.Data.MainPanel.ChannelPanel.Main,...
    'Position',[0,.1,1,.9],...
    'Color',G.DefaultColors.AxesColor,...
    'AmbientLightColor',G.DefaultColors.AxesColor,...
    'YDir', 'reverse',... %        'ButtonDownFcn', @ax_ButtonDownFcn,...
    'DataAspectRatio',[1,1,1],...
    'XTick',[],'YTick',[],...
    'XLabel',[],'YLabel',[],...
    'XLimMode','manual',....
    'YLimMode','manual',....
    'Box','on',...
    'PlotBoxAspectRatio',  [1,1,1],...
    'NextPlot', 'add',...
    'Visible','on');

h.Tabs.Data.MainPanel.ChannelPanel.ContrastSlider.Label.Main = uicontrol(...
    'Parent',h.Tabs.Data.MainPanel.ChannelPanel.Main,...
    'Style', 'text',...
    'String','Display contrast',...
    'HorizontalAlignment','left',...
    'BackgroundColor',G.DefaultColors.BackColor,...
    'units','normalized',...
    'Position',[0.01,.06,.15,.03]);


h.Tabs.Data.MainPanel.ChannelPanel.ContrastSlider.Main = uicontrol(...
    'Parent',h.Tabs.Data.MainPanel.ChannelPanel.Main,...
    'Style', 'slider',...
    'Min',0,'Max',1,'Value',0.5,'SliderStep',[.01,.1],...
    'BackgroundColor',G.DefaultColors.BackColor,...
    'units','normalized',...
    'Position',[.15,.06,.8,.03],...
    'Callback',{@ContrastSlider,G});

h.Tabs.Data.MainPanel.ChannelPanel.ThresholdSlider.Label.Main = uicontrol(...
    'Parent',h.Tabs.Data.MainPanel.ChannelPanel.Main,...
    'Style', 'text',...
    'String','Detection Threshold',...
    'HorizontalAlignment','left',...
    'BackgroundColor',G.DefaultColors.BackColor,...
    'units','normalized',...
    'Position',[0.01,.03,.15,.03]);


h.Tabs.Data.MainPanel.ChannelPanel.ThresholdSlider.Main = uicontrol(...
    'Parent',h.Tabs.Data.MainPanel.ChannelPanel.Main,...
    'Style', 'slider',...
    'Min',0,'Max',1,'Value',0.5,'SliderStep',[.01,.1],...
    'BackgroundColor',G.DefaultColors.BackColor,...
    'units','normalized',...
    'Position',[.15,.03,.8,.03],...
    'Callback',{@ThresholdSlider,G});

h.Tabs.Data.MainPanel.ChannelPanel.ChannelSlider.Label.Main = uicontrol(...
    'Parent',h.Tabs.Data.MainPanel.ChannelPanel.Main,...
    'Style', 'text',...
    'String','Current Channel [0]',...
    'HorizontalAlignment','left',...
    'BackgroundColor',G.DefaultColors.BackColor,...
    'units','normalized',...
    'Position',[0.01,0,0.15,.03]);


h.Tabs.Data.MainPanel.ChannelPanel.ChannelSlider.Main = uicontrol(...
    'Parent',h.Tabs.Data.MainPanel.ChannelPanel.Main,...
    'Style', 'slider',...
    'Min',1,'Max',1,'Value',1,'SliderStep',[1,1],...
    'Value',1,...
    'BackgroundColor',G.DefaultColors.BackColor,...
    'Enable','off',...
    'units','normalized',...
    'Position',[.15,0,.8,.03],...
    'Callback',{@ChannelSlider,G});

%%=====================%
% Side Panel
%======================%

hts = h.Tabs.Data.SidePanel;

%========%
% Mask Settings
%========%

space = 0.5;
n_elemts = 4;
vert_space = 1/(2*n_elemts+1);

hts.Mask.Main = uipanel(...
    'Parent',hts.Main, ...
    'Title','Mask Settings',...
    'Position',[0,0.6,1,.4],...
    'BackgroundColor',G.DefaultColors.BackColor);

hts.Mask.DataAxes.Main = axes(...
    'Parent',hts.Mask.Main,...
    'Position',[0.05,0,space-0.1,1],...
    'Color',G.DefaultColors.AxesColor,...
    'AmbientLightColor',G.DefaultColors.AxesColor,...
    'YDir', 'reverse',... %        'ButtonDownFcn', @ax_ButtonDownFcn,...
    'XTick',[],'YTick',[],...
    'XLabel',[],'YLabel',[],...
    'XLimMode','manual',....
    'YLimMode','manual',....
    'Box','on',...
    'PlotBoxAspectRatio',  [1,1,1],...
    'NextPlot', 'add',...
    'Visible','on');

hts.Mask.Selector.Label.Main = uicontrol(...
    'Parent',hts.Mask.Main,...
    'Style', 'text',...
    'String','Mask type',...
    'HorizontalAlignment','left',...
    'Tag', 'Selector' ,...
    'BackgroundColor',G.DefaultColors.BackColor,...
    'units','normalized',...
    'Position',[space,7*vert_space,0.15,vert_space]);

hts.Mask.Selector.Main = uicontrol(...
    'Parent',hts.Mask.Main,...
    'Units','normalized',...
    'Position', [space+0.2,7*vert_space,0.25,vert_space],...
    'Style', 'popupmenu',...
    'String', {'Manual Mask', 'Autocorr. PSF'},...
    'Value', 1,...
    'Callback',{@PSFCallback,G});



% Mask Shape Controls

hts.Mask.SpinnerPSF.Label.Main = uicontrol(...
    'Parent',hts.Mask.Main,...
    'Style', 'text',...
    'String','PSF',...
    'HorizontalAlignment','left',...
    'BackgroundColor',G.DefaultColors.BackColor,...
    'units','normalized',...
    'Position',[space,5*vert_space,.1,vert_space]);

hts.Mask.SpinnerPSF.Main = spinner(...
    'Parent',hts.Mask.Main,...
    'StartValue',T.MaskPSFParticleThreshold,...
    'Min',T.MaskPSFUpperBackgroundThreshold,'Max',1,'Step',0.05,...
    'Tag', 'PSF' ,...
    'Position',[space+0.2,5*vert_space,.2,vert_space],...
    'Enable', 'on',...
    'Callback',{@PSFCallback,[],[],G});

hts.Mask.SpinnerBGInner.Label.Main = uicontrol(...
    'Parent',hts.Mask.Main,...
    'Style', 'text',...
    'String','BG inner',...
    'HorizontalAlignment','left',...
    'BackgroundColor',G.DefaultColors.BackColor,...
    'units','normalized',...
    'Position',[space,3*vert_space,.15,vert_space]);

hts.Mask.SpinnerBGInner.Main = spinner(...
    'Parent',hts.Mask.Main,...
    'StartValue',T.MaskPSFUpperBackgroundThreshold,...
    'Min',T.MaskPSFLowerBackgroundThreshold,'Max',T.MaskPSFParticleThreshold,'Step',0.05,...
    'Tag', 'SpinnerBGInner',...
    'Position',[space+0.2,3*vert_space,.2,vert_space],...
    'Enable', 'on',...
    'Callback',{@PSFCallback,[],[],G});

hts.Mask.SpinnerBGOuter.Label.Main = uicontrol(...
    'Parent',hts.Mask.Main,...
    'Style', 'text',...
    'String','BG outer',...
    'HorizontalAlignment','left',...
    'BackgroundColor',G.DefaultColors.BackColor,...
    'units','normalized',...
    'Position',[space,vert_space,.1,vert_space]);

hts.Mask.SpinnerBGOuter.Main = spinner(...
    'Parent',hts.Mask.Main,...
    'StartValue',T.MaskPSFLowerBackgroundThreshold,...
    'Min',0,'Max',T.MaskPSFUpperBackgroundThreshold,'Step',0.05,...
    'Tag', 'SpinnerBGOuter',...
    'Position',[space+0.2,vert_space,.2,vert_space],...
    'Enable', 'on',...
    'Callback',{@PSFCallback,[],[],G});



%========%
% Tracking Method Selection
%========%
hts.Method.Main = uipanel(...
    'Parent',hts.Main, ...
    'Title','Method',...
    'Position',[0,0.4,1,.2],...
    'BackgroundColor',G.DefaultColors.BackColor);

% METHOD
% Trace Selection Method

hts.Method.Rbg_Selection.Main = uibuttongroup(...
    hts.Method.Main, ...
    'Title', 'Trace Selection',...
    'Units', 'normalized',...
    'Position', [.5,.02,.5,.98],...
    'BackgroundColor', G.DefaultColors.BackColor);

hts.Method.Rbg_Selection.Colocalized.Main = uicontrol(...
    hts.Method.Rbg_Selection.Main,...
    'Style','radiobutton',...
    'String', 'Colocalized only',...
    'BackgroundColor',G.DefaultColors.BackColor,...
    'ForegroundColor',G.DefaultColors.ForeColor,...
    'Units', 'normalized',...
    'Position',[0.1,.6,1,.2]);

hts.Method.Rbg_Selection.All.Main = uicontrol(...
    hts.Method.Rbg_Selection.Main,...
    'Style','radiobutton',...
    'String', 'All across all channels',...
    'BackgroundColor',G.DefaultColors.BackColor,...
    'ForegroundColor',G.DefaultColors.ForeColor,...
    'Units', 'normalized',...
    'Position',[0.1,.2,1,.2]);

    % set radioGroup option to "ALL"
    set(hts.Method.Rbg_Selection.Main,'SelectedObject',...
        hts.Method.Rbg_Selection.All.Main);
    
% Settings
% - ALEX


hts.CumulatedImage.Main = uipanel(...
    'Parent',hts.Main, ...
    'Title','Cumulated image',...
    'Position',[0,0.1,1,.3],...
    'Units','normalized',...
    'BackgroundColor',G.DefaultColors.BackColor);

hts.CumulatedImage.FirstFrame_Label.Main = uicontrol(...
    'Parent',hts.CumulatedImage.Main, ...
    'Style','text',...
    'HorizontalAlignment','left',...
   	'String','First frame (1)',...
    'BackgroundColor',G.DefaultColors.BackColor,...
    'Units','normalized',...
    'Position',[0.05,0.8,0.35,0.1]);

hts.CumulatedImage.FirstFrame.Main = uicontrol(...
    'Parent',hts.CumulatedImage.Main, ...
    'Style','slider',...
    'Min',1,'Max',1000,'Value',1,...
    'Units','normalized',...
    'Position',[0.4,0.8,0.55,0.1],...
    'Callback',{@firstImage,G});

min = get(hts.CumulatedImage.FirstFrame.Main,'Min');
max = get(hts.CumulatedImage.FirstFrame.Main,'Max');
set(hts.CumulatedImage.FirstFrame.Main,'SliderStep',(1/(max-min))*[(max-min)/10,1]);

hts.CumulatedImage.WindowSize_Label.Main = uicontrol(...
    'Parent',hts.CumulatedImage.Main, ...
    'Style','text',...
    'HorizontalAlignment','left',...
   	'String','Window size (1000 frames)',...
    'BackgroundColor',G.DefaultColors.BackColor,...
    'Units','normalized',...
    'Position',[0.05,0.65,0.35,0.1]);

hts.CumulatedImage.WindowSize.Main = uicontrol(...
    'Parent',hts.CumulatedImage.Main, ...
    'Style','slider',...
    'Min',1,'Max',1000,'Value',1000,'SliderStep',[0.1,0.1],...
    'Units','normalized',...
    'Position',[0.4,0.65,0.55,0.1],...
    'Callback',{@windowSize,G});

min = get(hts.CumulatedImage.WindowSize.Main,'Min');
max = get(hts.CumulatedImage.WindowSize.Main,'Max');
set(hts.CumulatedImage.WindowSize.Main,'SliderStep',(1/(max-min))*[(max-min)/10,1]);

% Extraction Method
hts.CumulatedImage.Method.Main = uibuttongroup(...
    hts.CumulatedImage.Main, ...
    'Title', 'Method',...
    'Units', 'normalized',...
    'Position', [.05,.02,.4,.60],...
    'BackgroundColor', G.DefaultColors.BackColor,...
    'SelectionChangedFcn',{@rbg_method_changed,G});

hts.CumulatedImage.Method.Sum.Main = uicontrol(...
    hts.CumulatedImage.Method.Main,...
    'Style','radiobutton',...
    'String', 'Sum',...
    'BackgroundColor',G.DefaultColors.BackColor,...
    'ForegroundColor',G.DefaultColors.ForeColor,...
    'Units', 'normalized',...
    'Position',[0.1,.75,1,.15]);

hts.CumulatedImage.Method.Max.Main = uicontrol(...
    hts.CumulatedImage.Method.Main,...
    'Style','radiobutton',...
    'String', 'Max',...
    'BackgroundColor',G.DefaultColors.BackColor,...
    'ForegroundColor',G.DefaultColors.ForeColor,...
    'Units', 'normalized',...
    'Position',[0.1,.45,1,.15]);

hts.CumulatedImage.Method.Weighted.Main = uicontrol(...
    hts.CumulatedImage.Method.Main,...
    'Style','radiobutton',...
    'String', 'Weighted Mean',...
    'BackgroundColor',G.DefaultColors.BackColor,...
    'ForegroundColor',G.DefaultColors.ForeColor,...
    'Enable','off',...
    'Units', 'normalized',...
    'Position',[0.1,.15,1,.15]);



% extract traces button

hts.TrackButton.Main = uicontrol(...
    'Parent',hts.Main,...
    'Style', 'pushbutton',...
    'String', 'Extract Traces',...
    'Units', 'normalized',...
    'Position', [0,.02,1,.06],...
    'Callback', {@startExtraction,G}); %,...    'CallbackFcn',{@cbn_extract, G}


% ht.Tracking.Settings = hts;
h.Tabs.Data.SidePanel = hts;
G.Handles.Figure = h; % return the new handles into the main class
G.Parent.GUI = G;
PSFCallback([], [],  G);
end



function ALEXsliderCallback(hObj, ~, G)
hObj.Value = round(hObj.Value);
for i = 1:4
    try
        G.Parent.ALEXcurrentSelection = hObj.Value;
        C = G.Parent.Channel{i};
        ax = G.Parent.GUI.Handles.Figure.Tabs.Data.MainPanel.ChannelPanel{i}.DataAxes.Main;
        ax.Children.delete;
        imagesc(C.Traces{G.Parent.ALEXcurrentSelection}.Cumulated,'Parent', ax);
        scatter(ax, C.Particles(:,2), C.Particles(:,1), 'o', 'w', 'HitTest','off');
    catch
    end
end
end

function ContrastSlider(o, ~, G)
T = G.Parent;
a = T.GUI.Handles.Figure.Tabs.Data.MainPanel.ChannelPanel.DataAxes.Main;
c = T.ChannelsWithData(T.GUI.Handles.Figure.Tabs.Data.MainPanel.ChannelPanel.ChannelSlider.Main.Value);
C = T.Channel{c};
C.ContrastThreshold(2) = o.Value;
for i=numel(a.Children):-1:1
    if isa(a.Children(i),'matlab.graphics.primitive.Image')
        a.CLim = [min(a.Children(i).CData(:)),min(max(a.Children(i).CData(:)),0.000001+o.Value*3)];
    end
end
end

function ChannelSlider(c,~,G)


c.Value = round(c.Value);
T = G.Parent;
if c.Max > 1;
    c.SliderStep = [1/(c.Max-c.Min),1/(c.Max-c.Min)];
end
a = T.GUI.Handles.Figure.Tabs.Data.MainPanel.ChannelPanel.DataAxes.Main;
C = T.Channel{T.ChannelsWithData(c.Value)};
s = size(C.CumulatedWarped);

if ~isa(a.Children(end),'matlab.graphics.primitive.Image')
    image('CData',C.CumulatedWarped, 'Parent',a);
    a.XLim=[1,s(1)];a.YLim=[1,s(2)];
else
    a.Children(end).CData = C.CumulatedWarped;
    C.CumulatedWarped
    disp('correto'); 
end

o = T.GUI.Handles.Figure.Tabs.Data.MainPanel.ChannelPanel.ContrastSlider.Main;
o.Min = C.ContrastThreshold(1); %o.Max = C.ContrastThreshold(2); %o.SliderStep = [.01,1];
a.CLim = C.ContrastThreshold; % set limits for colormap
o.Value = C.ContrastThreshold(2); % set contrast slider
end

function ThresholdSlider(s,~,G)
% allows setting threshold of brightest pixel in map image for accurate
% detection of mapping coordinates

% prepare handles
T = G.Parent;
a = T.GUI.Handles.Figure.Tabs.Data.MainPanel.ChannelPanel.DataAxes.Main;
c = T.ChannelsWithData(T.GUI.Handles.Figure.Tabs.Data.MainPanel.ChannelPanel.ChannelSlider.Main.Value) ;
C = T.Channel{c};
C.MappingThreshold = s.Value;

% apply threshold and update preview
t = C.Cumulated;
mx = max(t(:));
t(t<s.Value*mx) = 0;


% reacquire particles and find couples across channels
C.Particles = findPart(t, C.Parent.MaskPSF,C.Parent.MaskBG);
try
    C.ParticlesMapped =  C.MapFromReference.transformPointsInverse(C.Particles);
    T.ParticlesColocalized = findColoc(T, 9);
catch
end

% clear and replot particles

m = {'v','<','^','>'};  % specify markertype by channel number
col = {'green','cyan','r','magenta'};
if ~isempty(C.ParticlesMapped)
    %fp = @(c) scatter(a, C.Particles(:,2), C.Particles(:,1), m{c}, col{c}, 'HitTest','off','Tag', num2str(c),'LineWidth',1.5, 'MarkerEdgeAlpha',.75);
    fs = @(c) scatter(a, C.ParticlesMapped(:,2), C.ParticlesMapped(:,1), m{c}, col{c}, 'HitTest','off','Tag', num2str(c),'LineWidth',1.5, 'MarkerEdgeAlpha',.75, 'SizeData', 100);
    fc =  @() scatter(a, T.ParticlesColocalized(:,2), T.ParticlesColocalized(:,1), 'o', 'y', 'HitTest','off', 'Tag','c','LineWidth',2, 'SizeData', 100);
else
    fs = @(c) scatter(a, C.Particles(:,2), C.Particles(:,1), m{c}, col{c}, 'HitTest','off','Tag', num2str(c),'LineWidth',1.5, 'MarkerEdgeAlpha',.75, 'SizeData', 100);
    fc = @() [];
end

for i=numel(a.Children):-1:1
    if ~isempty(a.Children(i).Tag) && ~isa(a.Children(i),'matlab.graphics.primitive.Image')
        if a.Children(i).Tag == num2str(c)
            a.Children(i).delete;
        end
        if a.Children(i).Tag == 'c'
            a.Children(i).delete;
        end
    else
        %a.CLim = [min(a.Children(i).CData(:)),mx*min(1,s.Value*3)];    % adjust image contrast with threshold
    end
end
fs(c);
fc();
updateLegend();
for i=1:size(T.ParticlesColocalized,1); text(T.ParticlesColocalized(i,2)+4,T.ParticlesColocalized(i,1)+4,num2str(i),'Parent',a,'Color','y','FontSize',8,'FontWeight','bold','Tag','c');end


% catch
% end
%transform particle coords to reference channel if map available
%C.ParticlesMapped = C.MapToReference.Tr;

    function updateLegend()
        [l{1:2}] = deal({});
        for i=numel(a.Children):-1:1
            switch a.Children(i).Tag
                case 'c'
                    l{1} = [l{1},i];
                    l{2} = [l{2},['Colocalized: ', num2str(size(T.ParticlesColocalized,1))]];
                    
                case '1'
                    l{1} = [l{1},i];
                    l{2} = [l{2},['Ch 1: ', num2str(size(T.Channel{1}.Particles,1))]];
                case '2'
                    l{1} = [l{1},i];
                    l{2} = [l{2},['Ch 2: ', num2str(size(T.Channel{2}.Particles,1))]];
                case '3'
                    l{1} = [l{1},i];
                    l{2} = [l{2},['Ch 3: ', num2str(size(T.Channel{3}.Particles,1))]];
                case '4'
                    l{1} = [l{1},i];
                    l{2} = [l{2},['Ch 4: ', num2str(size(T.Channel{4}.Particles,1))]];
            end
        end
        legend(a.Children(cell2mat(l{1})),l{2},'Parent',a.Parent,'Position',[.85,.8,.15,.2], 'Color','black', 'TextColor','w');
        
    end

end

function cbn_extract(cbn, ~, G)
[I,BG] = extractTraces(C.Parent.RawData, C.Parent.MapToReference.transformPointsInverse(T.ParticlesColocalized(:,1:2)),C.Parent.MaskPSF,C.Parent.MaskBG,'sum');
end

function PSFCallback(o, ~,  G)

% intial loading of GUI
if isempty(o)
    o.Tag = 'Selector';
    o.Value = 1;
end


T = G.Parent;
h = T.GUI.Handles.Figure.Tabs.Data.SidePanel.Mask;
a = h.DataAxes.Main;
m = h.Selector.Main.Value;


switch o.Tag
    case 'PSF_edit'
        T.MaskPSFParticleThreshold = o.Value;
        h.SpinnerBGInner.Main.Max = o.Value;
    case 'SpinnerBGInner_edit'
        T.MaskPSFUpperBackgroundThreshold = o.Value;
        h.SpinnerBGOuter.Main.Max = o.Value-0.05;
        h.SpinnerPSF.Main.Min = o.Value;
    case 'SpinnerBGOuter_edit'
        T.MaskPSFLowerBackgroundThreshold = o.Value;
        h.SpinnerBGInner.Main.Min = o.Value +0.05;
    case 'Selector'
        % update description labels
        T.MaskType = o.Value;
    otherwise
end

genMask(T);

switch m
    case 1
        i = zeros([size(T.MaskPSF),3]);
        i(:,:,2:3) = repmat(T.MaskPSF,[1,1,2]);
        i(:,:,1) = T.MaskBG;
        a.XLim = [1,size(T.MaskPSF,2)];
        a.YLim = [1,size(T.MaskPSF,1)];
        image(i, 'Parent', a);
    case 2
        MaskfromPSF(T);
        a.XLim = [1,size(T.MaskAuto,2)];
        a.YLim = [1,size(T.MaskAuto,1)];
        a.Children(1:end-1).delete;
        imagesc(T.MaskAuto, 'Parent', a);
        a.Children(1).AlphaData = zeros(size(T.MaskPSF));
        a.Children(1).AlphaData = .2 +  (double(T.MaskBG)*.6 + double(T.MaskPSF))*.8;
    otherwise
end



end

function rbg_method_changed(o,~,G)

G.Parent.ExtractionMethod = o.SelectedObject.String;



end

function G = startExtraction(~,~,G)

T = G.Parent;
G = T.GUI;
%D = T.Channel{T.MappingReferenceChannel};

% extract colocalized particles only...
o1 = G.Handles.Figure.Tabs.Data.SidePanel.Method.Rbg_Selection.Main;
m = find(o1.Children==o1.SelectedObject);

for i = 1:length(T.ChannelsWithData)
    
    % TIRF data
    C = T.Channel{i};
    
    % if TIRF data has Particles and has more than one frame
    if ~isempty(C.Particles) && size(C.RawData,3) > 1
        
        for j=1:T.ALEXnumberofchannels  
            
            % in case ALEX is used...
            if T.ALEXnumberofchannels>1
                msg = ['Ch ',num2str(i),' | ALEX Ch ',num2str(j)];
            else
                msg = ['Ch ',num2str(i)];
            end
            disp([msg,': ']);
            switch m % TRACE extraction here
                
                case 1 % all traces
                    [C.Traces{j}.TracesCorrected,C.Traces{j}.TracesBackground] = ...
                        extractTraces(C.RawData, C.Particles(:,1:2),T.MaskPSF,T.MaskBG,T.ExtractionMethod);
                    
                case 2 % colocalized particles only
                    [C.Traces{j}.TracesCorrected,C.Traces{j}.TracesBackground] = ...
                        extractTraces(C.RawData(:,:,T.ALEXsequence(:)==T.ALEXorder(j)), T.ParticlesColocalized(:,i*3-2:i*3-1),T.MaskPSF,T.MaskBG,T.ExtractionMethod);
                   
            end
            
             % reset FRET relationships and buttons
            G.Parent.FRETtable(:,3:end) = zeros(6,3);
            for k=1:5;hts.FRET.FrButton{k}.Main.CData = [];end
            
            % Prepare Trace categorization...
            n = numel(C.Traces{1}.TracesCorrected);
            [C.Traces{j}.ManualSelection{1:numel(C.Traces{j}.TracesCorrected)}] = deal([0,0]);
            C.TraceCat = true(n, numel(T.TraceCategories));

            fprintf('\b\b %u Trace(s) extracted.\n',n);
        end
    else
        error('Either single frame image stack or no particles detected for trace extraction.');
    end
end

T.GUI = G;
% enable classification table
set(G.Handles.Figure.Tabs.Traces.SidePanel.Classification.Table.Main,'Enable','on');
% update trace slider and load first trace
s = G.Handles.Figure.Tabs.Traces.SidePanel.Navigation.TraceSlider.Main;
if ~exist('n'); return;end
if n>1
    s.Enable = 'on'; s.Min = 1; s.Max = n; if n>1;s.SliderStep = [1/(n-1), 1/(n-1)];end % set traces slider
    s.Value = 1;
    hgfeval(s.Callback,s,T.GUI);
end
T.GUI.Handles.Figure.Tabs.Main.SelectedTab = T.GUI.Handles.Figure.Tabs.Traces.Main;
disp(repmat('-',1,40));
end


function firstImage(~,~,G)

handle = G.Handles.Figure.Tabs.Data.SidePanel.CumulatedImage;

set(handle.FirstFrame_Label.Main,'String',...
    ['First frame (',sprintf('%.0f',handle.FirstFrame.Main.Value),')']);
end

function windowSize(~,~,G)

handle = G.Handles.Figure.Tabs.Data.SidePanel.CumulatedImage;

if handle.WindowSize.Main.Value >= 1.5
    set(handle.WindowSize_Label.Main,'String',...
        ['Window size (',sprintf('%.0f',handle.WindowSize.Main.Value),' frames)']);
else
    set(handle.WindowSize_Label.Main,'String','Window size (1 frame)');
end
end