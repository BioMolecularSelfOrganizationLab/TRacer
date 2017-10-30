function G = createMapTab( G )
% Creates GUI for Map Tab


h = G.Handles.Figure;

% UI containers Mapping Tab

h.Tabs.Mapping.MainPanel.Main = uicontainer(h.Tabs.Mapping.Main, 'Position', [0,0,G.Panel.WidthMainPanel,1], 'Units', 'normalized', 'BackgroundColor', G.DefaultColors.BackColor);
h.Tabs.Mapping.Controls.Main = uicontainer(h.Tabs.Mapping.Main, 'Position', [G.Panel.WidthMainPanel,0,G.Panel.WidthSidePanel,0.2], 'BackgroundColor', G.DefaultColors.BackColor);
h.Tabs.Mapping.LoadFiles.Main = uicontainer(h.Tabs.Mapping.Main, 'Position', [G.Panel.WidthMainPanel,0.2,G.Panel.WidthSidePanel,0.8], 'BackgroundColor', G.DefaultColors.BackColor);


% Create Mapping Axes as required:


for i=1:4

h.Tabs.Mapping.MainPanel.ChannelPanel{i}.Main = uipanel(...
    'Parent', h.Tabs.Mapping.MainPanel.Main, ...
    'Title', ['Channel ',num2str(i)],...
    'BackgroundColor',G.DefaultColors.BackColor,...d
    'Position',[mod(mod(i,2)+1,2)*.5,floor((4-i)/2)*.5,.5,.5]);

h.Tabs.Mapping.MainPanel.ChannelPanel{i}.MapAxes.Main = axes(...
        'Parent',h.Tabs.Mapping.MainPanel.ChannelPanel{i}.Main,...
        'Position',[.05,.05,.9,.9],...
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
        'ButtonDownFcn', {@MapLine,G},...
        'Visible','off');
    
    
h.Tabs.Mapping.MainPanel.ChannelPanel{i}.ContrastSliderText.Main = uicontrol(...
    'Parent',h.Tabs.Mapping.MainPanel.ChannelPanel{i}.Main,...
    'Style', 'text',...
    'String','Threshold',...
    'BackgroundColor',G.DefaultColors.BackColor,...
    'units','normalized',...
    'Position',[0,0,.15,.05]);
    
h.Tabs.Mapping.MainPanel.ChannelPanel{i}.ContrastSlider.Main = uicontrol(...
    'Parent',h.Tabs.Mapping.MainPanel.ChannelPanel{i}.Main,...
    'Style', 'slider',...
    'Min',0,'Max',1,'Value',.0,'SliderStep',[.02,.1],...
    'BackgroundColor',G.DefaultColors.BackColor,...
    'units','normalized',...
    'Position',[.15,0,.85,.05],...
    'Callback',{@ThresholdSlider,G});
    
 
end

ctr = h.Tabs.Mapping.Controls;

%h.Tabs.Mapping.MainPanel.MapAxes = setfield(h.Tabs.Mapping.MainPanel.MapAxes,'Map',[],'Line',[]);
ctr.Controls.Main = uipanel(...
    'Parent', ctr.Main,...
    'Title', 'Mapping Controls',...
    'Position', [0,0,1,1],...
    'BackgroundColor',G.DefaultColors.BackColor);

ctr.Controls.Mapping.ReferenceChannelMenu.Main = uicontrol(...
    'Parent', ctr.Controls.Main,...
    'Style', 'popupmenu',...
    'String', {'Reference: Ch 1','Reference: Ch 2','Reference: Ch 3','Reference: Ch 4'},...
    'units', 'normalized',...
    'Position', [.05,.8,.9,.1]);

ctr.Controls.Mapping.StartMappingButton.Main = uicontrol(...
    'Parent', ctr.Controls.Main,...
    'Style', 'pushbutton',...
    'String', 'Start Mapping',...
    'units', 'normalized',...
    'Position', [.2,.2,.6,.3],...
    'Callback',{@StartMapping, G});


% ------------- Load Files listBox -----------------
lf = h.Tabs.Mapping.LoadFiles;

lf.LoadFilesPanel.Main = uipanel(...
    'Parent', lf.Main,...
    'Title', 'Load Files',...
    'Position', [0,0,1,1],...
    'BackgroundColor',G.DefaultColors.BackColor);

% Directory
lf.LoadFilesPanel.DirectoryPanel.Main = uipanel(...
    'Parent', lf.LoadFilesPanel.Main,...
    'Title', 'Current directory',...
    'Position', [0.05,0.9,.9,0.1],...
    'BackgroundColor',G.DefaultColors.BackColor);

lf.LoadFilesPanel.DirectoryPanel.DirectoryPath.Main = uicontrol(...
    'Parent', lf.LoadFilesPanel.DirectoryPanel.Main,...
    'Style', 'text',...
    'String', '',...
    'units', 'normalized',...
    'HorizontalAlignment','left',...
    'BackgroundColor',G.DefaultColors.BackColor,...
    'Position', [0,0,1,1]);

% files listBox
lf.LoadFilesPanel.FilesListBox.Main = uicontrol(...
    'Parent', lf.LoadFilesPanel.Main,...
    'Style', 'listbox',...
    'String', 'No files',...
    'Enable', 'off',...
    'units', 'normalized',...
    'Position', [.4,.05,.55,.8],...
    'Callback',{@SelectFile, G});

lf.LoadFilesPanelPanel.OpenFolder.Main = uicontrol(...
    'Parent', lf.LoadFilesPanel.Main,...
    'Style', 'pushbutton',...
    'String', 'Open Folder',...
    'units', 'normalized',...
    'Position', [.05,.75,.3,.1],...
    'Callback',{@OpenFolder, G});

% Set info PANEL
lf.LoadFilesPanel.FileInfo.Main = uipanel(...
    'Parent', lf.LoadFilesPanel.Main,...
    'Title','File Info',...
    'Position', [0.05,0.5,0.3,0.2],...
    'BackgroundColor',G.DefaultColors.BackColor);

lf.LoadFilesPanel.FileInfo.Info.Main = uicontrol(...
    'Parent', lf.LoadFilesPanel.FileInfo.Main,...
    'Style','text',...
    'String','No file selected',...
    'HorizontalAlignment','left',...
    'units', 'normalized',...   
    'Position', [0.05,0.05,0.9,0.9],...
    'BackgroundColor',G.DefaultColors.BackColor);

% Set Channel PANEL
lf.LoadFilesPanel.SetChannel.Main = uipanel(...
    'Parent', lf.LoadFilesPanel.Main,...
    'Position', [0.05,0.05,0.3,0.4],...
    'Title','Load to',...
    'BackgroundColor',G.DefaultColors.BackColor);

lf.LoadFilesPanel.SetChannel.Channel1.Main = uicontrol(...
    'Parent', lf.LoadFilesPanel.SetChannel.Main,...
    'Style', 'pushbutton',...
    'String', 'Channel 1',...
    'units', 'normalized',...
    'Position', [.2,.75,.6,.1],...
    'Enable','off',...
    'Callback',{@imgMapLoad,G, 1,'map','Button'});

lf.LoadFilesPanel.SetChannel.Channel2.Main = uicontrol(...
    'Parent', lf.LoadFilesPanel.SetChannel.Main,...
    'Style', 'pushbutton',...
    'String', 'Channel 2',...
    'units', 'normalized',...
    'Position', [.2,.55,.6,.1],...
    'Enable','off',...
    'Callback',{@imgMapLoad,G, 2,'map','Button'});

lf.LoadFilesPanel.SetChannel.Channel3.Main = uicontrol(...
    'Parent', lf.LoadFilesPanel.SetChannel.Main,...
    'Style', 'pushbutton',...
    'String', 'Channel 3',...
    'units', 'normalized',...
    'Position', [.2,.35,.6,.1],...
    'Enable','off',...
    'Callback',{@imgMapLoad,G, 3,'map','Button'});

lf.LoadFilesPanel.SetChannel.Channel4.Main = uicontrol(...
    'Parent', lf.LoadFilesPanel.SetChannel.Main,...
    'Style', 'pushbutton',...
    'String', 'Channel 4',...
    'units', 'normalized',...
    'Position', [.2,.15,.6,.1],...
    'Enable','off',...
    'Callback',{@imgMapLoad,G, 4,'map','Button'});



 % return the new handles into the main class
h.Tabs.Mapping.Controls = ctr;
h.Tabs.Mapping.LoadFiles = lf;
G.Handles.Figure = h;
end


function StartMapping(~,~,G)
    G.Parent.MappingReferenceChannel = ...
        G.Parent.GUI.Handles.Figure.Tabs.Mapping.Controls.Controls.Mapping.ReferenceChannelMenu.Main.Value;
    for i=1:4
        if ~isempty(G.Parent.Channel{i}.RawMap)
        G.Parent.Channel{i}.MapLine = fliplr(G.Parent.GUI.Handles.Figure.Tabs.Mapping.MainPanel.ChannelPanel{i}.MapAxes.Line.getPosition);
%         G = G.Parent.Channel{i}.Mapping(G.Parent, 'create');
            G.Parent.Channel{i} = createMap(G.Parent.Channel{i});
        end
    end
    
% change current tab to "Data" tab
G.Parent.GUI.Handles.Figure.Tabs.Main.SelectedTab = G.Parent.GUI.Handles.Figure.Tabs.Data.Main;
end

function ThresholdSlider(hObj,~,G)
% allows setting threshold of brightest pixel in map image for accurate
% detection of mapping coordinates

% prepare handles
c = str2double(hObj.Parent.Title(end));
C = G.Parent.Channel{c};
C.MappingThreshold = hObj.Value;
a = G.Parent.GUI.Handles.Figure.Tabs.Mapping.MainPanel.ChannelPanel{c}.MapAxes;

if isempty(a.Main.Children)
    return
end

% apply threshold and update preview
t = C.RawMap;
m = max(t(:));
t(t<hObj.Value*m) = 0;
a.Main.Children(end).CData = t;

% reacquire particles
C.MapParticles = findPart(t, C.Parent.MaskPSF,C.Parent.MaskBG);

% copy Line coordinates
api1 = iptgetapi(a.Line);
pos = api1.getPosition();

% delete scatter and imline images
a.Main.Children(1:2).delete;

% add scatter points
scatter(a.Main, C.MapParticles(:,2), C.MapParticles(:,1), 'o', 'w', 'HitTest','off','PickableParts','none');

%create alignment tool
a.Line = imline(a.Main,size(C.RawMap,2)*[0.2,0.8],size(C.RawMap,1)*[0.2,0.8]);

% prevent line from getting outside of the axis
api = iptgetapi(a.Line);
fcn = makeConstrainToRectFcn('imline',get(a.Main,'XLim'),get(a.Main,'YLim'));
api.setPositionConstraintFcn(fcn);
api.setColor([0,1,0]);
api.setPosition(pos);

G.Parent.GUI.Handles.Figure.Tabs.Mapping.MainPanel.ChannelPanel{c}.MapAxes = a;

end


function OpenFolder(hObj,event,G)
% load files from folder to the listBox

handle = G.Parent.GUI.Handles.Figure.Tabs.Mapping.LoadFiles.LoadFilesPanel;

d=uigetdir; %search for folder
if d~=0 %if not 'cancel' operation
    cd(d);
    files=ls(strcat(d,'\*.tif'));
    
    if size(files,1)==0
        set(handle.FilesListBox.Main,'Value',1);
        set(handle.FilesListBox.Main,'String','No files');
        set(handle.FilesListBox.Main,'Enable','off');
        set(handle.FileInfo.Info.Main,'String','No file selected');
        
        % disable channel buttons
        set(handle.SetChannel.Channel1.Main,'Enable','off');
        set(handle.SetChannel.Channel2.Main,'Enable','off');
        set(handle.SetChannel.Channel3.Main,'Enable','off');
        set(handle.SetChannel.Channel4.Main,'Enable','off');
    else
        set(handle.FilesListBox.Main,'Value',1);
        set(handle.FilesListBox.Main,'String',files);
        set(handle.FilesListBox.Main,'Enable','on');
        
        % enable channel buttons
        set(handle.SetChannel.Channel1.Main,'Enable','on');
        set(handle.SetChannel.Channel2.Main,'Enable','on');
        set(handle.SetChannel.Channel3.Main,'Enable','on');
        set(handle.SetChannel.Channel4.Main,'Enable','on');
        
        SelectFile(hObj,event,G);
    end;
    
    set(handle.DirectoryPanel.DirectoryPath.Main,'String',[d,'\']);
end
    
end

function SelectFile(~,~,G)
% give information about the selected file

    
    handle = G.Parent.GUI.Handles.Figure.Tabs.Mapping.LoadFiles.LoadFilesPanel;
    
    if strcmp(handle.FilesListBox.Main.String,'No files')
        set(handle.FileInfo.Info.Main,'String','No file selected');
    else
        num = handle.FilesListBox.Main.Value;
        files = handle.FilesListBox.Main.String;
        path = handle.DirectoryPanel.DirectoryPath.Main.String;
        
        info_str = imfinfo([path,'\',strtrim(files(num,:))])
        
        newstring = sprintf('%s: %.1fMb\n%s: %i\n%s: %i\n%s: %i',...
            'File size',(info_str(1).FileSize)/1000000,...
            'Frames',length(info_str),...
            'Width',info_str(1).Width,...
            'Height',info_str(1).Height);

        set(handle.FileInfo.Info.Main,'String',newstring);
    end

end


function G = imgMapLoad(~,~,G, chan, itype, from)

for i = 1:numel(chan)
   
    C = G.Parent.Channel{chan(i)};
    
    switch itype
        case 'map'
            if strcmp(from,'Button')
                disp('doing this');
                LoadMap(C,'Button');
            else
                C.LoadMap;
            end
        case 'data'
            C.LoadData;
    end
end

end

