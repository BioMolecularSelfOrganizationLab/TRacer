
function G = createTracesTab( G )
% Creates GUI for Image Tab

h = G.Handles.Figure;

% UI containers Traces Tab

h.Tabs.Traces.MainPanel.Main = uicontainer(h.Tabs.Traces.Main, 'Position', [0,0,.8,1], 'Units', 'normalized', 'BackgroundColor', G.DefaultColors.BackColor);
h.Tabs.Traces.SidePanel.Main = uicontainer(h.Tabs.Traces.Main, 'Position', [.8,0,.2,1], 'BackgroundColor', G.DefaultColors.BackColor);

%% Traces Main Panels

for i=1:4
    h.Tabs.Traces.MainPanel.ChannelPanel{i} = struct();
    h.Tabs.Traces.MainPanel.ChannelPanel{i}.Main = uipanel(...
        'Parent', h.Tabs.Traces.MainPanel.Main, ...
        'Title', ['Channel ',num2str(i)],...
        'BackgroundColor',G.DefaultColors.BackColor,...
        'Position',[0,1-i*0.25,.9,.25]);
    
    h.Tabs.Traces.MainPanel.ChannelPanel{i}.TracesAxes.Main = axes(...
        'Parent',h.Tabs.Traces.MainPanel.ChannelPanel{i}.Main,...
        'Position',[0.05,.1,.95,.9],...
        'Color',G.DefaultColors.AxesColor,...
        'AmbientLightColor',G.DefaultColors.AxesColor,...
        'XTickMode','auto','YTickMode','auto',...
        'XGrid','on',...
        'XLabel',xlabel('Time [s]','Units','normalized','Position',[.5,.1,0]),'YLabel',ylabel('Int. [A.U.]','Units','normalized','Position',[.1,.5,0]),...
        'XAxisLocation','origin',...
        'XLimMode','auto',...
        'YLimMode','auto',...
        'Tag',num2str(i),...
        'Box','on',...
        'NextPlot', 'add',...
        'Visible','on',...
        'ButtonDownFcn',{@TracesAxes_Click,G});
    
%     h.Tabs.Traces.MainPanel.ParticlePanel{i} = struct();
    h.Tabs.Traces.MainPanel.ParticlePanel{i}.Main = uipanel(...
        'Parent', h.Tabs.Traces.MainPanel.Main, ...
        'Title', ['Channel ',num2str(i)],...
        'BackgroundColor',G.DefaultColors.BackColor,...
        'Position',[.9,1-i*0.25,.1,.25]);
    
    h.Tabs.Traces.MainPanel.ParticlePanel{i}.ParticleAxes.Main = axes(...
        'Parent',h.Tabs.Traces.MainPanel.ParticlePanel{i}.Main,...
        'Position',[0,0,1,1],...
        'Color',G.DefaultColors.AxesColor,...
        'AmbientLightColor',G.DefaultColors.AxesColor,...
        'YDir', 'reverse',... %
        'XTick',[],'YTick',[],...
        'XLabel',[],'YLabel',[],...
        'XLimMode','auto',....
        'YLimMode','auto',....
        'DataAspectRatio',[1,1,1],...
        'DataAspectRatioMode','manual',...
        'Box','off',...
        'NextPlot', 'replacechildren',...
        'Visible','on');
    
    
end

%% Controls and Classification Sidepanel


%% ====== Trace Navigation

hts = h.Tabs.Traces.SidePanel;
hts.Navigation.Main = uipanel(...
    'Parent', hts.Main, ...
    'Title', 'Navigation',...
    'BackgroundColor',G.DefaultColors.BackColor,...
    'Position',[0,.9,1,.1]);


hts.Navigation.TraceSlider.Label.Main = uicontrol(...
    'Parent',hts.Navigation.Main,...
    'Style', 'text',...
    'String','Trace',...
    'BackgroundColor',G.DefaultColors.BackColor,...
    'FontSize', 12,...
    'FontWeight','bold',...
    'units','normalized',...
    'HorizontalAlignment', 'center',...
    'Position',[0,.5,1,.5]);


hts.Navigation.TraceSlider.Main = uicontrol(...
    'Parent',hts.Navigation.Main,...
    'Style', 'slider',...
    'Min',1,'Max',1,'Value',1,'SliderStep',[1,1],...
    'Value',1,...
    'BackgroundColor',G.DefaultColors.BackColor,...
    'Enable','off',...
    'units','normalized',...
    'Position',[0,0,1,.5],...
    'Callback',{@TraceSlider,G});

%% Analyse Trace Button

hts.AnalyseButton.Main = uicontrol(...
    'Parent',hts.Main,...
    'Style', 'pushbutton',...
    'String','Analyse Traces',...
    'BackgroundColor',G.DefaultColors.BackColor,...
    'Enable','on',...
    'units','normalized',...
    'Position',[0.05,0.8,0.4,.05],...
    'Callback',{@AnalyseTrace,G});

%% Save Traces Button

hts.SaveTracesButton.Main = uicontrol(...
    'Parent',hts.Main,...
    'Style', 'pushbutton',...
    'String','Save Traces',...
    'BackgroundColor',G.DefaultColors.BackColor,...
    'Enable','on',...
    'units','normalized',...
    'Position',[0.55,0.8,0.4,.05],...
    'Callback',{@SaveTraces,G});

%%  ====== Plot display -> Channels vs Excitation

hts.PlotDisplay.Main = uipanel(...
    'Parent', hts.Main, ...
    'Title', 'Trace Plot Type',...
    'BackgroundColor',G.DefaultColors.BackColor,...
    'Position',[0,.65,1,.1]);

hts.PlotDisplay.Rbg_Display.Main = uibuttongroup(...
    hts.PlotDisplay.Main, ...
    'Units', 'normalized',...
    'Position', [0,0,1,1],...
    'BackgroundColor', G.DefaultColors.BackColor,...
    'SelectionChangedFcn',{@rbg_display_changed,G});

bn = {'One Camera channel per Plot', 'One excitation color per Plot'};
for i=1:2
    hts.PlotDisplay.Rbg_Display.Type{i}.Main = uicontrol(...
        hts.PlotDisplay.Rbg_Display.Main,...
        'Style','radiobutton',...
        'String', bn{i},...
        'BackgroundColor',G.DefaultColors.BackColor,...
        'ForegroundColor',G.DefaultColors.ForeColor,...
        'Units', 'normalized',...
        'Position',[0,1-i*1/numel(bn),1,.33]);
end

%% ====== Trace classification

hts.Classification.Main = uipanel(...
    'Parent', hts.Main, ...
    'Title', 'Classification',...
    'BackgroundColor',G.DefaultColors.BackColor,...
    'Position',[0,.35,1,.3]);

set(hts.Classification.Main,'Units','pixels');
pos = get(hts.Classification.Main,'Position');
set(hts.Classification.Main,'Units','normalized');
width = pos(3)-5;
f = 1/11;

hts.Classification.Table.Main =  uitable(...
    'Parent',hts.Classification.Main,...
    'Data',{true,'Uncategorized','','1', res(G,'/icons/trash16p.png'),res(G,'/icons/plus16p.png')},...
    'RowName',[],...
    'ColumnName',{'[x]','Category','Count',res(G,'/icons/keybutton16p.png'),res(G,'/icons/trash16p.png'),res(G,'/icons/plus16p.png')},...
    'ColumnFormat',{'logical','char','char',num2cell(char(setdiff(char(49:57),cell2mat(G.NavKeys))))},... % reduce dropdown options to non-assigned buttons,1),'char','char'},...
    'ColumnEditable',[true,true,false,true,false,false],...
    'BackgroundColor',G.DefaultColors.BackColor,...
    'Units','normalized',...
    'ColumnWidth',{f*width,4*f*width,2*f*width,2*f*width,f*width,f*width},...
    'Enable','off',...
    'Position',[0,0,1,1],...
    'CellEditCallback', {@cat_edt_cbk,G},...
    'CellSelectionCallback', {@cat_sel_cbk, G});




% ====== Trace quick classification controls

% hts.Classification.Main= uipanel(...
%     'Parent', hts.Main, ...
%     'Title', 'Quick Classification',...
%     'BackgroundColor',G.DefaultColors.BackColor,...
%     'Position',[0,.35,1,.15]);


% ====== Bleach Step Detection

hts.BleachSteps.Main = uipanel(...
    'Parent', hts.Main, ...
    'Title', 'Bleach Step Detection',...
    'BackgroundColor',G.DefaultColors.BackColor,...
    'Position',[0,.2,1,.15]);


hts.BleachSteps.Rbg_Method.Main = uibuttongroup(...
    hts.BleachSteps.Main, ...
    'Units', 'normalized',...
    'Position', [0,0,1,1],...
    'BackgroundColor', G.DefaultColors.BackColor,...
    'SelectionChangedFcn',{@rbg_method_changed,G});

bn = {'Variance','Salapaka','L1','HMM'};

for i=1:4
    hts.BleachSteps.Rbg_Method.Method{i}.Main = uicontrol(...
        hts.BleachSteps.Rbg_Method.Main,...
        'Style','radiobutton',...
        'String', bn{i},...
        'BackgroundColor',G.DefaultColors.BackColor,...
        'ForegroundColor',G.DefaultColors.ForeColor,...
        'Enable','off',...
        'Units', 'normalized',...
        'Position',[0,1-i*1/numel(bn),1,.33]); 
end

% methods not used...
set(hts.BleachSteps.Rbg_Method.Method{2}.Main,'Enable','on'),    
hts.BleachSteps.Rbg_Method.Main.SelectedObject = hts.BleachSteps.Rbg_Method.Method{2}.Main;

% ====== FRET GUI

hts.FRET.Main = uipanel(...
    'Parent', hts.Main, ...
    'Units', 'normalized',...
    'Title', 'FRET controls',...
    'BackgroundColor',G.DefaultColors.BackColor,...
    'Position',[0,0,1,.2]);

chbpos = {[1,2],[0,1],[2,1],[1,0]};
frbpos = {[0,2],[2,2],[0,0],[2,0],[1,1]};

for i=1:4
hts.FRET.ChButton{i}.Main = uicontrol(...
    'Parent', hts.FRET.Main,...
    'Style','pushbutton',...
    'Units', 'normalized',...
    'String', ['Ch',num2str(i)],...
    'Tag', ['Ch',num2str(i)],...
    'BackgroundColor',G.DefaultColors.BackColor,...
    'Position',[chbpos{i},1,1]./3,...
    'Callback',{@FRETChBtnCallback, G});
end

for i=1:5
hts.FRET.FrButton{i}.Main = uicontrol(...
    'Parent', hts.FRET.Main,...
    'Style','pushbutton',...
    'Units', 'normalized',...
    'Tag', ['Fr',num2str(i)],...
    'BackgroundColor',G.DefaultColors.BackColor,...
    'Position',[[frbpos{i},1,1]./3],...
    'Callback',{@FRETFrBtnCallback, G});
end
% load icons for FRET buttons
G.CurvedArrowIcon = imread('./res/arrow_curved.jpg');
[G.CenterArrowIcon{1:4}] =  deal([],...
    imread('./res/arrow_horizontal.jpg'),...
    imread('./res/arrow_vertical.jpg'),...
    imread('./res/arrow_both.jpg'));

h.Tabs.Traces.SidePanel = hts;
G.Handles.Figure = h;



end


%% CALLBACKS

function G = TraceSlider(o,~,G)
o.Value = round(o.Value);
G.Parent.CurrentTrace = o.Value;
updateTrace(G, o.Value);
end

function G = updateTrace(G,t,r)

% update or redraw trace plots
% G: GUI object; t: current trace number, r: plot mode changed -> recreate all plots

%% STATIC VARIABLES DECLARATION
T = G.Parent;
G = T.GUI;
ht = G.Handles.Figure.Tabs.Traces;

%% RECREATE TRACE PLOTS
if t == 1 || exist('r','var') % r=1: recreate all plots (do this as rarely as possible (slow))
    cellfun(@(x) x.TracesAxes.Main.Children.delete,ht.MainPanel.ChannelPanel(1:4)); % clear plot children
    cellfun(@(x,y) set(x.Main,'Title',[]),ht.MainPanel.ChannelPanel(1:4),'UniformOutput', false); % clear plot children[ht.MainPanel.ChannelPanel{1:4}.Main.Title]
    for i=1:4% remove deleted handles
        ht.MainPanel.ChannelPanel{i}.TracesAxes = rmfield(ht.MainPanel.ChannelPanel{i}.TracesAxes,setdiff(fieldnames(ht.MainPanel.ChannelPanel{i}.TracesAxes),'Main'));
    end 
    switch T.TraceDisplayMode
        case 1 % one camera per plot
            ch = 1/length(T.ChannelsWithData);
            
            for i=1:length(T.ChannelsWithData)
                C = T.Channel{T.ChannelsWithData(i)};
                at = ht.MainPanel.ChannelPanel{i}.TracesAxes;
                ht.ChannelPanel{i}.Main.Title = [C.ChannelColor, ' Camera'];
                
                for j=1:T.ALEXnumberofchannels
                    
                    at.Plot{j} = plot(...
                        [1:size(T.Channel{1}.RawData,3)],zeros(1,size(T.Channel{1}.RawData,3)),...
                        'Color', G.ChannelColors{find(strcmp([T.GUI.ChannelColorsText],T.ALEXorder(j)))},...
                        'Tag', [T.ALEXorder(j),C.ChannelColor],...
                        'Parent', at.Main,...
                        'HitTest','off');
                end
                legend(at.Main.Children(end-T.ALEXnumberofchannels+1:end),{at.Main.Children(end-T.ALEXnumberofchannels+1:end).Tag},'Parent',at.Main.Parent);
                
                %prepare lines and fill object for manual selection
                for k = 1:2
                    at.Selection{k}.Main = line([0,0],at.Main.YLim,'Parent', at.Main,'Tag',['l',num2str(k)],'HitTest','off') ;
                end
                % create polygon
                at.Selection{3}.Main = fill([0,0,0,0]',[0,0,repmat(at.Main.YLim(2),1,2)]',G.ChannelColors{C.ChannelColorIndex},'FaceAlpha',.1,'Parent', at.Main,'Tag','l3','HitTest', 'off');
                ht.MainPanel.ChannelPanel{i}.TracesAxes = at;
                % generate legends for trace plots
                
            end
        case 2 % one excitation per plot (show all cameras in one plot

            % update plot containers
            ch = 1/T.ALEXnumberofchannels; % normalized height of plot container
            %             ht.MainPanel.ChannelPanel{i}.Main.Position = [0,1-i*ch,1,ch];
            
            for i=1:T.ALEXnumberofchannels
                at = ht.MainPanel.ChannelPanel{i}.TracesAxes;
                 ht.ChannelPanel{i}.Main.Title = [T.ALEXorder(i), ' excitation'];
                % recreate plots (1 per camera channel)
                for j=1:length(T.ChannelsWithData)
                    C = T.Channel{T.ChannelsWithData(j)};
                    at.Plot{j} = plot(...
                        [1:size(C.RawData,3)],zeros(1,size(C.RawData,3)),...
                        'Parent', at.Main,...
                        'Color', G.ChannelColors{C.ChannelColorIndex},...
                        'Tag', [T.ALEXorder(i),C.ChannelColor],...
                        'HitTest','off');
                end
                % create one cumulated plot (sum across camera channels)
                % per plot
                at.TotalPlot = plot(...
                    [1:size(C.RawData,3)],zeros(1,size(C.RawData,3)),...
                    'Parent', at.Main,...
                    'Color', 'black',...
                    'Tag', 'Total',...
                    'HitTest','off');
                %prepare lines and fill object for manual selection
                for k = 1:2
                    at.Selection{k}.Main = line([0,0],at.Main.YLim,'Parent', at.Main,'Tag',['l',num2str(k)],'HitTest','off') ;
                end
                at.Selection{3}.Main = fill([0,0,0,0]',[0,0,repmat(at.Main.YLim(2),1,2)]',G.ChannelColors{C.ChannelColorIndex},'FaceAlpha',.1,'Parent', at.Main,'Tag','l3','HitTest', 'off');
                
                ht.MainPanel.ChannelPanel{i}.TracesAxes = at;
                
                 % generate legends for trace plots
                legend(at.Main.Children(end-length(T.ChannelsWithData):end),{at.Main.Children(end-length(T.ChannelsWithData):end).Tag},'Parent',at.Main.Parent);
            end
    end
    for i=1:4
        ht.MainPanel.ChannelPanel{i}.Main.Position = [0,1-i*ch,.9,ch];
        ht.MainPanel.ParticlePanel{i}.Main.Position = [.9,1-i/length(T.ChannelsWithData),.1,1/length(T.ChannelsWithData)];
    end % determine number of plots to show
    
    G.Handles.Figure.Tabs.Traces = ht;
end

%% UPDATE PLOTS
%

function updateManualSelection(l)
            % update manual selection lines and patch
                    s = T.Channel{l}.Traces{1}.ManualSelection{t};
                    for k=1:2
                        at.Selection{k}.Main.XData = [s(k),s(k)];
                        at.Selection{k}.Main.YData = [0,ymax];
                    end
                    at.Selection{3}.Main.XData=[s(1),s(2),s(2),s(1)]';
                    at.Selection{3}.Main.YData=[0,0,repmat(ymax,1,2)]';
end


for i=1:length(T.ChannelsWithData)
    
    C =  T.Channel{i};
    for j=1:numel(C.Traces) % loop over number of separate excitation wavelengths
        C = T.Channel{T.ChannelsWithData(i)};

        if ~isempty(C.Traces{j}.TracesCorrected{t}) && mean(C.Traces{j}.TracesCorrected{t}) ~= 0
            
           
            ap = ht.MainPanel.ParticlePanel{i}.ParticleAxes.Main;
            
            switch T.TraceDisplayMode
                case 1 % one camera per plot
                    at = ht.MainPanel.ChannelPanel{i}.TracesAxes;
                    l = i; % for trace selection
                    p = at.Plot{j};
                    % update limits
                    if j==1; p.Parent.YLim = [0,1];end
                case 2 % one excitation per plot (show all cameras in one plot)
                    at = ht.MainPanel.ChannelPanel{j}.TracesAxes;
                    p = at.Plot{i};
                    l = j;
                    p.Color = G.ChannelColors{C.ChannelColorIndex};
                    
                    if i==1 % update total plot
                        p.Parent.YLim = [0,1];
                        s = 0;
                        
                        for l=1:length(T.ChannelsWithData)
                            s = s + sum(T.Channel{l}.Traces{j}.TracesCorrected{t}(:),2);
                        end % sum all traces in plot

                        at.TotalPlot.XData = [1:length(C.Traces{j}.TracesCorrected{t})].*T.ALEXnumberofchannels.*(T.FrameTime/1000);
                        at.TotalPlot.YData = s;
                    end
            end
            
            p.XData = [1:length(C.Traces{j}.TracesCorrected{t})].*T.ALEXnumberofchannels.*(T.FrameTime/1000);
            p.YData = C.Traces{j}.TracesCorrected{t};
            p.Parent.XLim = [0,max(p.XData)];
            ymax = 0;
            ymin = 0;
            for n=4:numel(at.Main.Children)
                ymax = max(at.Main.Children(n).YData);
            end;
            for n=4:numel(at.Main.Children)
                ymin = min(at.Main.Children(n).YData);
            end;
            ymax = ymax + abs(ymax-ymin)*0.1;
            ymin = ymin - abs(ymax-ymin)*0.1;
            updateManualSelection(l);
            
            p.Parent.YLim = [ymin,ymax];
            
            
            %update slider label
            ht.SidePanel.Navigation.TraceSlider.Label.Main.String = ['Trace: ',num2str(t),' / ',num2str(numel(C.Traces{j}.TracesCorrected)) ];
            
            % update particle preview axes
            L = round(C.Particles(t,1:2));
            z = floor(size(T.MaskBG,1)/2)-1;
            imagesc(C.Cumulated(L(1)-z:L(1)+z,L(2)-z:L(2)+z), 'Parent', ap);
            ap.XLim = [.5,z*2+1.5]; ap.YLim = [.5,z*2+1.5];
            mask = T.MaskPSF+T.MaskBG;
            mask = mask(2:end-1,2:end-1);
            ap.Children.AlphaData = .7 - mask *.7+mask;
            % Update Category list
            o =  ht.SidePanel.Classification.Table.Main;
            % update trace selection axes
            refreshCategoryTable(o, t, C);
        end
    end
    G.Handles.Figure.Tabs.Traces = ht;
    T.GUI = G;
    
end
end

function G = rbg_display_changed(o,~,G)
G.Parent.TraceDisplayMode = find(o.Children==o.SelectedObject);
t = G.Parent.GUI.Handles.Figure.Tabs.Traces.SidePanel.Navigation.TraceSlider.Main.Value;
updateTrace(G,t,1);
end

function G = TracesAxes_Click(o, e, G)
t = G.Parent.GUI.Handles.Figure.Tabs.Traces.SidePanel.Navigation.TraceSlider.Main;
s = G.Parent.Channel{str2double(o.Tag)}.Traces{1}.ManualSelection{t.Value};
switch e.Button
    case 1 % 1st click: set start. 2nd click set stop if (1) ~= 0, set (2)
        if s(1) == 0 || s(2) ~= 0
            s = [0,0];
            s(1) = round(e.IntersectionPoint(1));
        elseif s(2) == 0
            s(2) = round(e.IntersectionPoint(1));
        end
    case 3 % right mouse click -> reset
        s = [0,0];
end

G.Parent.Channel{str2double(o.Tag)}.Traces{1}.ManualSelection{t.Value} = s;
for i=1:numel(o.Children)
    switch o.Children(i).Tag
        case 'l1'
            o.Children(i).XData = [s(1),s(1)];
        case 'l2'
            o.Children(i).XData = [s(2),s(2)];
        case 'l3'
            o.Children(i).XData=[s(1),s(2),s(2),s(1)];
            
    end
end
end

% Trace Classification Callbacks

function G = cat_sel_cbk(obj, e, G)
% callback to evaluate changed selection list
%global data

n=obj.ColumnName;
T = G.Parent;
I = e.Indices;
if ~isempty(I)&&~isempty(obj.Data)
    % code goes here
    %     h.cat_sel = e;
    for k=1:size(I,1)
        c = I(k,2);
        switch c
            case 1 %
                
            case 2 % Selected category for filtering
            case 4
               obj.ColumnFormat{4} = num2cell([' ',char(setdiff(char(97:122),[G.NavKeys,obj.Data{:,4}]))]); % reduce dropdown options to non-assigned buttons
            case 5 % Delete row
                if I(k,1)> 1 % cant delete first row!
                    q = questdlg('Do you really want to delete this category?','Delete Category','Yes','Cancel','Cancel');
                    if strcmp(q,'Yes')
                        updateCategories(T,'-');
                    end
                end
            case 6 % Add new row and expand selection matrix
                obj.Data(I(k)+1:end+1,:) = obj.Data(I(k):end,:);
                obj.Data(I(k)+1,:) = {false, 'New category','',num2str(size(obj.Data,1)),n{5},n{6}};
                updateCategories(T,'+');
        end
        
    end
    
end

function updateCategories(T,act)
for i=1:4
    C = T.Channel{i};
    t = T.CurrentTrace;

    if ~isempty(C.Traces)

        switch act
            case '+' % add category
                a = I(k)+1;

                
                if i==1
                    T.TraceCategories
                    T.TraceCategories(end+1) = obj.Data(a,2);
                end % add category to T.TraceCategories - but only once!
                
                T.TraceKeys = obj.Data(:,4);
                
                if I(k) < numel(T.TraceCategories)
                    C.TraceCat = [C.TraceCat(:,1:I(k)),false(size(C.TraceCat,1),1), C.TraceCat(:,a:end)];
                else
                    C.TraceCat = [C.TraceCat,false(size(C.TraceCat,1),1)];
                end

                %C.TraceCat(t,a) = true;
                obj.Data{a,1} = C.TraceCat(t,a) ;
                
            case '-' % remove categories
                disp('0');
                
                T.TraceKeys
                T.TraceKeys(I(k)) = [];
                disp('1');
                T.TraceCategories{I(k)} = {};
                disp('2');
                C.TraceCat(I(k),:) = [];
                disp('3');
                obj.Data(I(k),:) = [];
                
        end
    end
end
end
end


function cat_edt_cbk(obj, e, G)

% callback to evaluate changed cell item
T = G.Parent;
t = T.CurrentTrace;
I = e.Indices;
C = T.Channel{1};

if ~isempty(I)&&~isempty(obj.Data)
%     if numel(obj.Data) > 1
%         if sum(cell2mat(obj.Data(2:end,1))) > 0
%         obj.Data{1,1} = false;
%         else
%             obj.Data{1,1} = true;
%         end
%     end

    for k=1:size(I,1)
        c = I(k,2);
        li = I(1,1);
        switch c
            case 1 % checkbox edited
                for i=1:length(T.ChannelsWithData)
                    if I(1,1)==1 % 'Uncategorized' > 'u' pressed
                        %o.Data{1,1} = true;
                        T.Channel{i}.TraceCat(t,1) = true;
                        T.Channel{i}.TraceCat(t,2:end) = deal(false);
                    else
                        T.Channel{i}.TraceCat(t,li) = ~T.Channel{i}.TraceCat(t,li);

                        % if no category assigned
                        T.Channel{i}.TraceCat(t,1) = isempty(find(T.Channel{i}.TraceCat(t,2:end)));
                    end
                end

                %                 t = get(h.ttree);
%                 if I(1,1) == 1 && size(I,1) <= 1 % clear all selected checkboxes if 'Uncategorized' is selected
%                     [obj.Data{2:end,1}] = deal(false);
%                 end
                %                for i=1:sum(T.ChannelsWithData)
                %                C = T.Channel{i};
                %C.TraceCat(t,:) = cell2mat(obj.Data(:,1)');
                %cellfun(@(x) x.set('TraceCat',C.TraceCat),T.Channel(T.ChannelsWithData),'UniformOutput',0);    % set category for all valid channels
                
            case 2
                T.TraceCategories = obj.Data(:,2)';
                
            case 4 % hotkey changed -> update keypressfcn
                T.TraceKeys = obj.Data(:,4)';
                obj.ColumnFormat{4} = num2cell([char(setdiff(char(49:57),[cell2mat(G.NavKeys),cell2mat(T.TraceKeys)]))]); % reduce dropdown options to non-assigned buttons
                %T.trace_keys = o.Data(:,4);
        end
        %         disp(o.Data{e.Indices(1),e.Indices(2)});
        
    end
    refreshCategoryTable(obj,t,C);
end

%C.TraceCat

end

function updateKeyPressFcn(G)
T = G.Parent;
T.KeyPre


end

function refreshCategoryTable(o,t,C)
%  refreshes category table; o: table handle; t: T.CurrentTrace; C: current
%  channel
for i=1:size(o.Data,1)
    o.Data{i,1} = C.TraceCat(t,i);
    o.Data{i,3} = sum(C.TraceCat(:,i)); % update counter column
end

end

function G = FRETChBtnCallback(o,e,G)

end

function G = FRETFrBtnCallback(o,e,G)
% switches FRET relationship matrix and button icons
hfr = G.Handles.Figure.Tabs.Traces.SidePanel.FRET;
r = {-1,-1,0,0};
f = {0,1,0,1};
i= str2double(o.Tag(3));

switch i
    case {1,2,3,4} % ordinary FRET arrow buttons, only off and on
        G.Parent.FRETtable(i,3) = ~G.Parent.FRETtable(i,3);
        if G.Parent.FRETtable(i,3)
            hfr.FrButton{i}.Main.CData = imrotate(G.CurvedArrowIcon, 90*r{i});
            if f{i}; hfr.FrButton{i}.Main.CData = fliplr(hfr.FrButton{i}.Main.CData);end;
            G.Parent.FRETtable(i,4:5) = str2double(inputdlg({'Gamma','Beta'},'Gamma and Beta',1));
%             o.String = sprintf('g=%.2f\n\nb=%.2f',G.Parent.FRETtable(1,4:5));
        o.ForegroundColor = 'r';
        o.String = ['<HTML>g = ',num2str(G.Parent.FRETtable(1,4),2),'<br><br>b = ',num2str(G.Parent.FRETtable(1,5),2),'</HTML>'];
        
        % now recalculate all fret traces....
        
        else
            hfr.FrButton{i}.Main.CData = [];
            G.Parent.FRETtable(i,4:5) = 0;
            o.String = [];
        end
        
        
    case 5 % center button, has to switch 2 channels, therefore permute setting:
        j = G.Parent.FRETtable(i,3)+G.Parent.FRETtable(i+1,3)*2+1;
        a = [1,0;0,1;1,1;0,0]';
        G.Parent.FRETtable(i:i+1,3) = a(:,j);
        hfr.FrButton{i}.Main.CData = G.CenterArrowIcon{j};
        if sum(G.Parent.FRETtable(i:i+1,3)) > 0
            % now recalculate all fret traces....
        end
end


end



function AnalyseTrace(~,~,G)
    
    T = G.Parent; % tracer
    % later version: apply to all channels (this is just a test)   
    C = T.Channel{T.ChannelsWithData(1)};   % tirf
    tr = C.Traces{1}.TracesCorrected;
    
    w = waitbar(0,'Starting trace analysis...','Units','pixels');
    movegui(w,'center');
    pos = get(w,'Position');
    movegui(w,[pos(1),pos(2)+57]);

    for i=1:numel(tr)

        waitbar(i/numel(tr),w,['Processing trace ',num2str(i),' of ',num2str(numel(tr))]);
        
        C.Traces{1}.StepsFitFunction{i} = stepfit1_alvaro(tr{i});
        aux = C.Traces{1}.StepsFitFunction{i};

        [C.Traces{1}.MonomerNumber{i},C.Traces{1}.RealStep{i}] = getNumSteps(aux);
        C.Traces{1}.AuxiliarArray{i} = diff(aux);
        C.Traces{1}.AuxiliarArray{i}(end+1) = 0;
        %C.Traces{1}.AuxiliarArray{i}
    end
    close(w);
    
    % pos-process
    
    auxArray = C.Traces{1}.AuxiliarArray;
    traces = C.Traces{1}.MonomerNumber;
    
    % number of categories
    n = numel(T.TraceCategories);
    for i=1:n
        analyse = ANALYSISdata();
        % get indexes of traces belonging to current (i_th) category
       	k = find(C.TraceCat(:,i));
        
        % for each trace in category
        for j=1:numel(k)
            % k(j) is the index of the j_th trace in the current category

            % global
            step_evts_idx = find(auxArray{k(j)});
            dwell_times = diff(step_evts_idx)/100;
            step_sizes = abs(auxArray{k(j)}(step_evts_idx));
            
            analyse = addToDwellTimes(analyse, 1, dwell_times);
            analyse = addToStepSizes(analyse, step_sizes);
            
            % individual
            trace = traces{k(j)};
            c_auxArray = [diff(trace),0];
            step_evts_idx = find(c_auxArray);
            
            mx = max(C.Traces{1}.MonomerNumber{k(j)});
            %get dwell time histogram data for each jump level:
            
            % for each level
            for level= 0:(mx-1)
                acum = 0;
                % for each step event
                for stp_idx = 1:length(step_evts_idx)
                    
                    if trace(step_evts_idx(stp_idx)) == level
                        if stp_idx == 1
                            acum = acum + step_evts_idx(stp_idx);
                        else
                            acum = acum + step_evts_idx(stp_idx) - step_evts_idx(stp_idx-1);
                        end
                        
                        if c_auxArray(step_evts_idx(stp_idx)) > 0
                            %disp(sprintf('Trace %i / level %i / add %i',k(j),level,acum));
                            analyse = addToDwellTimes(analyse, level+2, acum/100);
                            acum = 0;
                        end
                    end
                end
            end
        end
        
        analysis_h = G.Handles.Figure.Tabs.Analysis;
        
        % calculate distributions' parameters
        dwell_length = length(analyse.DwellTimes);
        
        for j=1:dwell_length
            if numel(k)>0
                norm_dist = fitdist(transpose(analyse.StepSizes),'Normal');
                analyse.stepSize_miuhat = norm_dist.mu;
                analyse.stepSize_sigmahat = norm_dist.sigma;
                
                if isempty(analyse.DwellTimes{j})
                    analyse.dwellTime_miuhat{j} = 0;
                else
                    exp_dist = fitdist(transpose(analyse.DwellTimes{j}),'Exponential');
                    analyse.dwellTime_miuhat{j} = 1/exp_dist.mu;
                end
            else
                analyse.stepSize_miuhat = 0;
                analyse.stepSize_sigmahat = 0;
                analyse.dwellTime_miuhat{j} = 0;
            end
        end
        
        
        C.Traces{1}.CategoryAnalysis{i} = analyse;
    end
    
    
    set(analysis_h.SidePanel.Navigation.CategoryListbox.Main,'String',T.TraceCategories);
    set(analysis_h.SidePanel.Trace.Listbox.Main,'String',find(C.TraceCat(:,analysis_h.SidePanel.Navigation.CategoryListbox.Main.Value))');
    
    obj = analysis_h.SidePanel.Navigation.CategoryListbox.Main;
    hgfeval(obj.Callback,obj,G);
    
%     kh = analysis_h.SidePanel.Navigation.CategoryListbox.Main.Value;
%     histogram(analysis_h.MainPanel.HistogramDwell,C.Traces{1}.CategoryAnalysis{kh}.DwellTimes,30);
%     histogram(analysis_h.MainPanel.HistogramSteps,C.Traces{1}.CategoryAnalysis{kh}.StepSizes,30);
    
%     kt = str2num(analysis_h.SidePanel.Trace.Listbox.Main.String(...
%         analysis_h.SidePanel.Trace.Listbox.Main.Value));
%     
%     plot(analysis_h.MainPanel.StepFit,...
%         1:1000,C.Traces{1}.TracesCorrected{kt},'b',...
%         1:1000,C.Traces{1}.StepsFitFunction{kt},'k');
        
    
    G.Handles.Figure.Tabs.Main.SelectedTab = G.Handles.Figure.Tabs.Analysis.Main;

%     YData = G.Handles.Figure.Tabs.Traces.MainPanel.ChannelPanel{1}.TracesAxes.Main.Children(end).YData;
%     XData = G.Handles.Figure.Tabs.Traces.MainPanel.ChannelPanel{1}.TracesAxes.Main.Children(end).XData;
%     
%     % STEP FIND METHOD (SALAPAKA)
%     stepData = stepfit1_alvaro(YData);
%     
%     % step_events
%     step_events = stepData(2:end)-stepData(1:end-1);
%     step_events(end+1) = 0;
%     
%     % step_sizes
%     step_evts_idx = find(step_events);
%     
%     %step_evts_idx
%     step_sizes = abs(step_events(step_evts_idx));
%     
%     % NOTE: use frame_rate instead of 100;
%     dwell_times = (step_evts_idx(2:end)-step_evts_idx(1:end-1))/100;
%     
%     figure('Name','Dwell time Histogram');
% %     set(f1,'Units','Normalized');
% %     set(f1,'Position',[0.1,0.1,0.8,0.8]);
%     hs1 = subplot(1,2,1);
%     hs2 = subplot(1,2,2);
%     
%     histogram(hs1,dwell_times,10);
%     title(hs1,'Dwell times');
%     ylabel(hs1,'Occurrences');
%     xlabel(hs1,'Time(s)');
%     
%     histogram(hs2,step_sizes,10);
%     title(hs2,'Step sizes');
%     ylabel(hs2,'Occurrences');
%     xlabel(hs2,'Step size');
%     
%     figure('Name','Trace Step Extraction');
%     ax1 = subplot(2,1,1);
%     ax2 = subplot(2,1,2); 
%     p = plot(ax1,XData,YData,'b',XData,stepData,'k');
%     p(2).LineWidth = 2;
%     title(ax1,'Step fit function');
%     xlabel(ax1,'Time(s)');
%     ylabel(ax1,'...');
%     
%     plot(ax2,XData,step_events);
%     title(ax2,'Auxiliar step event array');
%     xlabel(ax2,'Time(s)');
%     ylabel(ax2,'Step size');
%     
    
end


function SaveTraces(~,~,G)

    T = G.Parent; % tracer
    % later version: apply to all channels (this is just a test)   
    C = T.Channel{T.ChannelsWithData(1)};   % tirf
    tr = C.Traces{1}.TracesCorrected;
	
    waitfor(saveTraces(tr));


end

