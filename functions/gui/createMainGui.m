function G = createMainGui( G )
% CREATEMAINGUI and callbacks

set(0, 'defaultAxesXColor', G.DefaultColors.ForeColor,...
    'defaultAxesYColor', G.DefaultColors.ForeColor);

h.Main = figure(...
    'Name', 'TRACER: Main Experiment Window',...
    'NumberTitle','off',...
    'units', 'normalized', ...
    'OuterPosition', [0,0,1,1],...
    'Color', G.DefaultColors.BackColor,...
    'GraphicsSmoothing', 'on',...
    'MenuBar', 'none',...
    'Toolbar', 'none',...
    'WindowKeyReleaseFcn', {@mainKeyPress,G},...
    'WindowScrollWheelFcn', {@mainMouseWheel,G},...
    'WindowButtonMotionFcn', {@mainBtnMotion,G});
colormap(G.ColormapCurrent);%'CloseRequestFcn', {@mainCloseReq,G},... % remember to pass G for handle modification
%% MENU Structure

% [Menu]File
% h.Menu = {};h.Menu.File = {};
h.Menu.File.Main = uimenu(h.Main, 'Label', 'File');
h.Menu.File.Mapping.Main = uimenu(h.Menu.File.Main, 'Label', 'Mapping...');
h.Menu.File.Mapping.Generate.Main = uimenu(h.Menu.File.Mapping.Main, 'Label', 'Create New Map');
h.Menu.File.Mapping.Generate.Ch1 = uimenu(h.Menu.File.Mapping.Generate.Main, 'Label', '1st channel','Callback', {@imgLoad,G,  1,'map'});
h.Menu.File.Mapping.Generate.Ch2 = uimenu(h.Menu.File.Mapping.Generate.Main, 'Label', '2nd channel','Callback', {@imgLoad,G,  2,'map'});
h.Menu.File.Mapping.Generate.Ch3 = uimenu(h.Menu.File.Mapping.Generate.Main, 'Label', '3rd channel','Callback', {@imgLoad,G,  3,'map'});
h.Menu.File.Mapping.Generate.Ch4 = uimenu(h.Menu.File.Mapping.Generate.Main, 'Label', '4th channel','Callback', {@imgLoad,G,  4,'map'});

h.Menu.File.Mapping.Load.Main = uimenu(h.Menu.File.Mapping.Main, 'Label', 'Load Prev. Map','Callback', {@load_map,G});
h.Menu.File.Mapping.Save.Main = uimenu(h.Menu.File.Mapping.Main, 'Label', 'Save Map', 'Callback', {@save_map,G});

h.Menu.File.Load.Main = uimenu(h.Menu.File.Main, 'Label', 'Load Image Data');
h.Menu.File.Load.Ch1 = uimenu(h.Menu.File.Load.Main, 'Label', '1st channel','Callback', {@imgLoad, G, 1,'data'});
h.Menu.File.Load.Ch2 = uimenu(h.Menu.File.Load.Main, 'Label', '2nd channel','Callback', {@imgLoad, G, 2,'data'});
h.Menu.File.Load.Ch3 = uimenu(h.Menu.File.Load.Main, 'Label', '3rd channel','Callback', {@imgLoad, G, 3,'data'});
h.Menu.File.Load.Ch4 = uimenu(h.Menu.File.Load.Main, 'Label', '4th channel','Callback', {@imgLoad, G, 4,'data'});

h.Menu.File.Traces.Main = uimenu(h.Menu.File.Main, 'Label', 'State...');
h.Menu.File.Traces.Load.Main = uimenu(h.Menu.File.Traces.Main, 'Label', 'Load State', 'Callback', {@load_state,G},'Accelerator','o');
h.Menu.File.Traces.Save.Main = uimenu(h.Menu.File.Traces.Main, 'Label', 'Save State', 'Callback', {@save_state,G},'Accelerator','s');

h.Menu.File.Quit.Main = uimenu(h.Menu.File.Main, 'Label', 'Quit','Callback',{@mainCloseReq,G},'Separator','on','Accelerator','q');

% [Menu]Edit


% [Menu]Settings
% h.menu_set = uimenu(h.main, 'Label', 'Settings');
% h.menu_set_traces = uimenu(h.menu_set, 'Label', 'Traces');
% h.menu_set_traces_bg = uimenu(h.menu_set_traces, 'Label', 'Background Correction');
% h.menu_set_traces_bg_off = uimenu(h.menu_set_traces_bg, 'Label', 'off');
% h.menu_set_traces_bg_local = uimenu(h.menu_set_traces_bg, 'Label', 'Local');
% h.menu_set_traces_bg_whole = uimenu(h.menu_set_traces_bg, 'Label', 'Whole Frame Avg.');
% h.menu_set_traces_bg_global = uimenu(h.menu_set_traces_bg, 'Label', 'Global Framestack');

% [Menu]View
h.Menu.View.Main = uimenu(h.Main, 'Label', 'View');
h.Menu.View.Colormap.Main = uimenu(h.Menu.View.Main, 'Label', 'Colormap');
for i = 1:numel(G.Colormaps);h.Menu.View.Colormap.Subitem(i) = uimenu(h.Menu.View.Colormap.Main, 'Label', G.Colormaps{i}, 'Callback', {@mainColormapChanged,G});end
h.Menu.View.Colormap.Subitem(1).Checked = 'on';

% [Menu]Reset
h.Menu.Reset.Main = uimenu(h.Main, 'Label', 'Reset','Callback', {@mainReset,G});



% Create Tabs
h.Tabs.Main = uitabgroup(h.Main, 'Units', 'normalized', 'Position', [0,.02,1,0.98]);
h.Tabs.Mapping.Main = uitab(h.Tabs.Main, 'Title', 'Mapping', 'BackgroundColor', G.DefaultColors.BackColor);
h.Tabs.Data.Main = uitab(h.Tabs.Main, 'Title', 'Image Data', 'BackgroundColor', G.DefaultColors.BackColor);
h.Tabs.Traces.Main = uitab(h.Tabs.Main, 'Title', 'Traces', 'BackgroundColor', G.DefaultColors.BackColor,...
    'TooltipString','This tab allows for the selection and categorization of traces');
h.Tabs.Analysis.Main = uitab(h.Tabs.Main, 'Title', 'Analysis', 'BackgroundColor', G.DefaultColors.BackColor,...
    'TooltipString','This tab allows the analysis of categorized traces');

G.Handles.Figure = h; % write all that to the class property

end

%% CALLBACKS


function mainCloseReq(~,~,G)
% close main figure and delete workspaces
try
    delete(G.Parent.GUI.Handles.Figure.Main);
catch
end
%close(G.Parent.GUI.Handles.Figure.Main);
clear G;
warning on;
end

function mainReset(~,~,G)
if strcmp(questdlg('Resetting will delete any unsaved data!', 'Reset TRacer...','Yes, reset', 'Cancel', 'Cancel'),'Yes, reset')
    mainCloseReq([],[],G);
    TRacer();
end
end


function G = mainKeyPress(~,e,G)
% Evaluate Keyboard button presses for accelerated workflow
% try
T = G.Parent;
t = T.CurrentTrace;
g = gco;    % current Object
if ~isempty(t) && ~(strncmp(class(g),'matlab.ui.control',17))	% to exclude callbacks when entering text into a control
    
    if G.Parent.GUI.Handles.Figure.Tabs.Main.SelectedTab == G.Parent.GUI.Handles.Figure.Tabs.Traces.Main
        s = G.Handles.Figure.Tabs.Traces.SidePanel.Navigation.TraceSlider.Main;
        o = G.Handles.Figure.Tabs.Traces.SidePanel.Classification.Table.Main;
        switch e.Key
            case {'a','leftarrow'}  % go to previous trace

                if t > s.Min
                    s.Value = s.Value - 1;
                    hgfeval(s.Callback,s,G);
                end
            case {'d','rightarrow'}  % go to next trace
                if t < s.Max
                    s.Value = s.Value + 1;
                    hgfeval(s.Callback,s,G);
                end
            case 'w'
            case 's'
            otherwise
                %if strcmp(e.Key,'space'); e.Key = u;end
                if length(e.Key)==1 % ignore special keys

                    k = find(not(cellfun('isempty',strfind(T.TraceKeys,e.Key))));
                    if ~isempty(k)

                        for i=1:length(T.ChannelsWithData)
                            if k==1 % 'Uncategorized' > 'u' pressed
                                %o.Data{1,1} = true;
                                T.Channel{i}.TraceCat(t,1) = true;
                                T.Channel{i}.TraceCat(t,2:end) = deal(false);
                            else
                                T.Channel{i}.TraceCat(t,k) = ~T.Channel{i}.TraceCat(t,k);
                                
                                % if no category assigned
                                T.Channel{i}.TraceCat(t,1) = isempty(find(T.Channel{i}.TraceCat(t,2:end)));
                            end
                      
                        end

%                         %o.Data{k,1} = T.Channel{i}.TraceCat(t,k);
%                         d.Indices = [k,1];
%                         cb = o.CellEditCallback;
%                         cb{1}(o,d,G); %call uitable's cell edt function
                        
                        refreshCategoryTable(o,t,G.Parent.Channel{1});
                    end
                end
        end
    end
end
% catch
    % end
end

function G = mainMouseWheel(~,e,G)
switch sign(e.VerticalScrollCount)
    case 1
        d.Key = 'a';
    case -1 
       d.Key = 'd';
end
mainKeyPress([],d,G);
end

function G = mainBtnMotion(~,~,G)

end

function G = imgLoad(~,~,G, chan, itype)


for i = 1:numel(chan)
   
    C = G.Parent.Channel{chan(i)};
    
    switch itype
        case 'map'
            C.LoadMap
        case 'data'
            C.LoadData;
    end
end

end

function G = save_map(~,~,G)
% save map...
T = G.Parent;
if T.LastPath == 0; T.LastPath = pwd;end
[file,T.LastPath] = uiputfile('*.mat','Save Map',[T.LastPath,date,'_map.mat']);

if file == 0;
    disp('Map save aborted.');
    return;
end


for i=1:4
    C = T.Channel{i};
    if ~isempty(C.MapToReference)
        f = fieldnames(C);
        for j=1:numel(f)
            m{i}.(f{j}) = C.(f{j});
        end
        
        m{i} = rmfield(m{i},{'RawMap','RawData','Parent','Traces'});
    end
end
save(fullfile(T.LastPath,[date,'_map.mat']),'m');
fprintf('\n')
disp(['Map saved as ''',fullfile(T.LastPath,[date,'_map.mat']),'''']);

end

function G = load_map(~,~,G)
% load map
T = G.Parent;
if T.LastPath == 0; T.LastPath = pwd;end
[file,T.LastPath] = uigetfile('*.mat','Load Map',[T.LastPath,date,'_map.mat']);
if file == 0;
    disp('Map loading aborted.');
    return;
end
try
    msg = msgbox('Loading Map, please wait...','Please Wait.');msg.Children(1).delete;
    load(fullfile([T.LastPath,file])); %load map file...
catch
    delete m;
    return;
end

for i=1:length(m)
    C = T.Channel{i};
    if ~isempty(m{i}.MapToReference)
        
        f = fieldnames(m{i});
        for j=1:numel(f)
            try
                C.(f{j}) = m{i}.(f{j});
            catch
                warning([f{j},' doesn''t exist in class definition.']);
            end
        end
        
    end
    % load into GUI
    ax = T.GUI.Handles.Figure.Tabs.Mapping.MainPanel.ChannelPanel{i}.MapAxes.Main;
    ax.Children(1:end).delete;
    ax.XLim = [1,size(C.MapResultImage,2)];ax.YLim = [1,size(C.MapResultImage,1)];
    image(C.MapResultImage , 'Parent',ax);
    scatter(ax, C.MapParticles(:,2), C.MapParticles(:,1), 'o', 'w', 'HitTest','off');
end
close(msg);
disp(['Map loading complete: ',num2str(i),' Channels']);
G.Parent.GUI.Handles.Figure.Tabs.Main.SelectedTab = G.Parent.GUI.Handles.Figure.Tabs.Data.Main;
end

function G = save_state(~,~,G)
T = G.Parent;
if T.LastPath == 0; T.LastPath = pwd;end
[file,T.LastPath] = uiputfile('*.mat','Save State',[T.LastPath,date,'_traces.mat']);
fp = fullfile(T.LastPath,file);
if file == 0;
    disp('Saving aborted.');
    return;
end

%alternate saving method
warning('off', 'MATLAB:Figure:FigureSavedToMATFile');
temp = T;
for i=1:4
    if ~isempty(temp.Channel{i}.Cumulated)
        temp.Channel{i}.RawData = [];
    end
end
save(fp, 'temp');
clear temp;
disp(['TRacer state saved as ''',fp,'''']);
return;

% legacy method
f = fieldnames(T);
for j=1:numel(f)
    if ~strcmpi(f{j},{'Parent','GUI'})
        temp.(f{j}) = T.(f{j});
    end
end
for i=1:4
    if ~isempty(temp.Channel{i}.Cumulated)
        temp.Channel{i}.RawData = [];
    end
    
end

warning('off','MATLAB:Figure:FigureSavedToMATFile');
save(fp,'temp','-v7.3');
disp(['TRacer state saved as ''',fp,'''']);
disp(repmat('-',1,40));
end

function G = load_state(~,~,G)
T = G.Parent;
if T.LastPath == 0; T.LastPath = pwd;end
[file,lp] = uigetfile('*.mat','Load State',[T.LastPath,date,'_state.mat']);

if file == 0;
    disp('Loading aborted.');
    return;
end
mainCloseReq([],[],G);
clear T G;

% try
    msg = msgbox('Loading State, please wait...','Please Wait.');msg.Children(1).delete;
    load(fullfile([lp,file]),'temp'); %load map file...
    assignin('base','T',temp);
    clear temp;
% catch
%     delete msg;
%     return;
% end

disp(['Successfully loaded state from ''',file,'''']);
delete(msg);


end


function G = mainColormapChanged(hObj,~,G)
h = G.Parent.GUI.Handles.Figure;
[h.Menu.View.Colormap.Subitem(1:numel(G.Colormaps)).Checked] = deal('off');
G.ColormapCurrent = hObj.Label;
hObj.Checked = 'on';

colormap(h.Main,G.ColormapCurrent);

end



function refreshCategoryTable(o,t,C)
%  refreshes category table; o: table handle; t: T.CurrentTrace; C: current
%  channel
for i=1:size(o.Data,1)
    o.Data{i,1} = C.TraceCat(t,i);
    o.Data{i,3} = sum(C.TraceCat(:,i)); % update counter column
end

end