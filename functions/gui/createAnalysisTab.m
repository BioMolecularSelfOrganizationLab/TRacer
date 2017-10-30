function G = createAnalysisTab(G)
% Analysis Tab with histograms and more
h = G.Handles.Figure;

h.Tabs.Analysis.MainPanel.Main = uicontainer(h.Tabs.Analysis.Main, 'Position', [0,0,0.85,1], 'Units', 'normalized', 'BackgroundColor', G.DefaultColors.BackColor);
h.Tabs.Analysis.SidePanel.Main = uicontainer(h.Tabs.Analysis.Main, 'Position', [0.85,0,0.15,1], 'BackgroundColor', G.DefaultColors.BackColor);

h.Tabs.Analysis.MainPanel.HistogramDwell= subplot(...
    2,2,1,...
    'Parent',h.Tabs.Analysis.MainPanel.Main,...
    'Color',G.DefaultColors.AxesColor);
    xlabel('Time (s)');

h.Tabs.Analysis.MainPanel.HistogramSteps= subplot(...
    2,2,2,...
    'Parent',h.Tabs.Analysis.MainPanel.Main,...
    'Color',G.DefaultColors.AxesColor);
    xlabel('Step Sizes');

h.Tabs.Analysis.MainPanel.StepFit= subplot(...
    2,2,[3,4],...
    'Parent',h.Tabs.Analysis.MainPanel.Main,...
    'Color',G.DefaultColors.AxesColor);
    xlabel('Time (s)');
    


%% SIDEPANEL


hts = h.Tabs.Analysis.SidePanel;
hts.Navigation.Main = uipanel(...
    'Parent', hts.Main, ...
    'Title', 'Category filter',...
    'BackgroundColor',G.DefaultColors.BackColor,...
    'Position',[0,.85,1,.15]);

% ====== Category selector
hts.Navigation.CategoryListbox.Main = uicontrol(...
    'Parent', hts.Navigation.Main, ...
    'Style','listbox',...
    'BackgroundColor',G.DefaultColors.BackColor,...
    'String', 'Uncategorized',...
    'Value', 1,...
    'Units','normalized',...
    'Position',[0,0,1,1],...
    'Callback',{@category_lbx_changed,G});

% trace selector
hts.Trace.Main = uipanel(...
    'Parent', hts.Main, ...
    'Title', 'Trace selector',...
    'BackgroundColor',G.DefaultColors.BackColor,...
    'Position',[0,0.5,1,.35]);

% ====== tracer selector
hts.Trace.Listbox.Main = uicontrol(...
    'Parent', hts.Trace.Main, ...
    'Style','listbox',...
    'BackgroundColor',G.DefaultColors.BackColor,...
    'String', '',...
    'Value', 1,...
    'Units','normalized',...
    'Position',[0,0,1,1],...
    'Callback',{@tracer_lbx_changed,G});

% hist controls
hts.HistControl.Main = uipanel(...
    'Parent', hts.Main, ...
    'Title', 'Histogram controls',...
    'BackgroundColor',G.DefaultColors.BackColor,...
    'Position',[0,0.4,1,.1]);

hts.HistControl.DwellHistBinLabel.Main = uicontrol(...
    'Parent', hts.HistControl.Main, ...
    'Style','text',...
    'BackgroundColor',G.DefaultColors.BackColor,...
    'String','Number of bins for Dwell times: ',...
    'HorizontalAlignment','left',...
    'Units','characters',...
    'Position',[2,2.5,32,1]);

hts.HistControl.Dwell.Main = uicontrol(...
    'Parent', hts.HistControl.Main, ...
    'Style','edit',...
    'BackgroundColor',G.DefaultColors.BackColor,...
    'String','15',...
    'Units','characters',...
    'Position',[33,2.5,6,1],...
    'Callback',{@category_lbx_changed,G});

hts.HistControl.StepsHistBinLabel.Main = uicontrol(...
    'Parent', hts.HistControl.Main, ...
    'Style','text',...
    'BackgroundColor',G.DefaultColors.BackColor,...
    'String','Number of bins for Steps sizes: ',...
    'HorizontalAlignment','left',...
    'Units','characters',...
    'Position',[2,1,32,1]);

hts.HistControl.Steps.Main = uicontrol(...
    'Parent', hts.HistControl.Main, ...
    'Style','edit',...
    'BackgroundColor',G.DefaultColors.BackColor,...
    'String','15',...
    'Units','characters',...
    'Position',[33,1,6,1],...
    'Callback',{@category_lbx_changed,G});

% plot controls
hts.PlotControl.Main = uipanel(...
    'Parent', hts.Main, ...
    'Title', 'Plot controls',...
    'BackgroundColor',G.DefaultColors.BackColor,...
    'Units','normalized',...
    'Position',[0,0.25,1,.15]);

hts.PlotControl.TraceData.Main = uicontrol(...
    'Parent', hts.PlotControl.Main, ...
    'Style','checkbox',...
    'String','Trace data',...
    'BackgroundColor',G.DefaultColors.BackColor,...
    'Value',1,...
    'Units','normalized',...
    'Position',[0.1,0.65,0.8,0.2],...
    'Callback',{@tracer_lbx_changed,G});

hts.PlotControl.FitFunction.Main = uicontrol(...
    'Parent', hts.PlotControl.Main, ...
    'Style','checkbox',...
    'String','Fit function',...
    'BackgroundColor',G.DefaultColors.BackColor,...
    'Value',1,...
    'Units','normalized',...
    'Position',[0.1,0.4,0.8,0.2],...
    'Callback',{@tracer_lbx_changed,G});

hts.PlotControl.MonomerNumber.Main = uicontrol(...
    'Parent', hts.PlotControl.Main, ...
    'Style','checkbox',...
    'String','Monomer number',...
    'BackgroundColor',G.DefaultColors.BackColor,...
    'Value',0,...
    'Units','normalized',...
    'Position',[0.1,0.15,0.8,0.2],...
    'Callback',{@tracer_lbx_changed,G});

% distribution parameters
hts.Distribution.Main = uipanel(...
    'Parent', hts.Main, ...
    'Title', 'Distributions',...
    'BackgroundColor',G.DefaultColors.BackColor,...
    'Units','normalized',...
    'Position',[0,0,1,.25]);

% dwell distribution
hts.Distribution.Dwell.Main = uipanel(...
    'Parent', hts.Distribution.Main, ...
    'Title', 'Dwell time',...
    'BackgroundColor',G.DefaultColors.BackColor,...
    'Units','normalized',...
    'Position',[0,0.5,1,.5]);

hts.Distribution.Dwell.Text.Main = uicontrol(...
    'Parent', hts.Distribution.Dwell.Main, ...
    'Style','text',...
    'BackgroundColor',G.DefaultColors.BackColor,...
    'String','Step jump:',...
    'Units','normalized',...
    'Position',[0.1,0.6,0.3,0.3]);

hts.Distribution.Dwell.PopUp.Main = uicontrol(...
    'Parent', hts.Distribution.Dwell.Main, ...
    'Style','popupmenu',...
    'BackgroundColor',G.DefaultColors.BackColor,...
    'String',{''},...
    'Value',1,...
    'Units','normalized',...
    'Position',[0.4,0.6,0.5,0.3],...
    'Callback',{@dwell_time_lbx_changed,G});

hts.Distribution.Dwell.Label.Main = uicontrol(...
    'Parent', hts.Distribution.Dwell.Main, ...
    'Style','text',...
    'BackgroundColor',G.DefaultColors.BackColor,...
    'String','',...
    'HorizontalAlignment','left',...
    'Units','normalized',...
    'Position',[0.05,0.15,0.9,0.3]);

% step distribution
hts.Distribution.StepSize.Main = uipanel(...
    'Parent', hts.Distribution.Main, ...
    'Title', 'Step size',...
    'BackgroundColor',G.DefaultColors.BackColor,...
    'Units','normalized',...
    'Position',[0,0,1,.5]);

hts.Distribution.StepSize.Label.Main = uicontrol(...
    'Parent', hts.Distribution.StepSize.Main, ...
    'Style','text',...
    'BackgroundColor',G.DefaultColors.BackColor,...
    'String','',...
    'HorizontalAlignment','left',...
    'Units','normalized',...
    'Position',[0.05,0.3,0.9,0.7]);

hts.Distribution.StepSize.Outliers.Main = uicontrol(...
    'Parent', hts.Distribution.StepSize.Main, ...
    'Style','checkbox',...
    'BackgroundColor',G.DefaultColors.BackColor,...
    'String','Remove outliers',...
    'Units','normalized',...
    'Position',[0.1,0.1,0.8,0.25],...
    'Callback',{@outliers_changed,G});


h.Tabs.Analysis.SidePanel = hts;
G.Handles.Figure = h; % return the new handles into the main class
G.Parent.GUI = G;
end

function category_lbx_changed(o,e,G)
    T = G.Parent;
    C = G.Parent.Channel{T.ChannelsWithData(1)};
    analysis_h = G.Handles.Figure.Tabs.Analysis;
    
    % update listbox with traces of the category
    set(analysis_h.SidePanel.Trace.Listbox.Main,...
        'String',...
        find(C.TraceCat(:,analysis_h.SidePanel.Navigation.CategoryListbox.Main.Value))');
    
    % update number of traces in the category
    set(analysis_h.SidePanel.Trace.Main,'Title',['Trace selector (',...
        num2str(size(analysis_h.SidePanel.Trace.Listbox.Main.String,1)),' available)']);
    
    % reset to first trace
    set(analysis_h.SidePanel.Trace.Listbox.Main,'Value',1);
    
    kh = analysis_h.SidePanel.Navigation.CategoryListbox.Main.Value;
    
    % update dwell time histogram options
    dwell_length = length(C.Traces{1}.CategoryAnalysis{kh}.DwellTimes);
    dwell_string = {'Global'};
    for j=1:(dwell_length-1)
        dwell_string(end+1) = {sprintf('%i to %i',j-1,j)};
    end
    set(analysis_h.SidePanel.Distribution.Dwell.PopUp.Main,'String',dwell_string);
    set(analysis_h.SidePanel.Distribution.Dwell.PopUp.Main,'Value',1);
    
    % Dwell times
    dwell_time_lbx_changed(o,e,G);    
    
    % Step sizes
    ax2 = analysis_h.MainPanel.HistogramSteps;
    cla(ax2);
    hold(ax2,'on');

    histogram(ax2,C.Traces{1}.CategoryAnalysis{kh}.StepSizes,...
        str2num(analysis_h.SidePanel.HistControl.Steps.Main.String),...
        'Normalization','pdf');
    
    xlim(ax2,'auto');
    
    miu = C.Traces{1}.CategoryAnalysis{kh}.stepSize_miuhat;
    sigma = C.Traces{1}.CategoryAnalysis{kh}.stepSize_sigmahat;
    x_lim = ax2.XLim;
    x = linspace(x_lim(1),x_lim(2),100);
    norm = exp(-(x-miu).^2./(2*sigma^2))./(sigma*sqrt(2*pi));
    
    plot(ax2,x,norm,'r','LineWidth',2);

    title(ax2,'Step sizes histogram');
    xlabel(ax2,'Step size');
    %ylabel(ax2,'Probability (%)');
    
    set(analysis_h.SidePanel.Distribution.StepSize.Label.Main,'String',[...
        'Expected step size: ',sprintf('%.2f',miu),...
        char(10),...
        'Standart deviation: ',sprintf('%.2f',sigma),...
        char(10)]);
    
    tracer_lbx_changed(o,e,G);
    outliers_changed(o,e,G);
end

function dwell_time_lbx_changed(~,~,G)
    T = G.Parent;
    C = G.Parent.Channel{T.ChannelsWithData(1)};
    analysis_h = G.Handles.Figure.Tabs.Analysis;
    kh = analysis_h.SidePanel.Navigation.CategoryListbox.Main.Value;
    
    % Dwell times
    ax1 = analysis_h.MainPanel.HistogramDwell;
    cla(ax1);
    hold(ax1,'on');
    
    dwell_select = analysis_h.SidePanel.Distribution.Dwell.PopUp.Main.Value;
    
    data_x = C.Traces{1}.CategoryAnalysis{kh}.DwellTimes{dwell_select};
    freedman_diaconis_rule = 2*(quantile(data_x,0.75)-quantile(data_x,0.25))/(length(data_x).^(1/3));
    if freedman_diaconis_rule == 0
        freedman_diaconis_rule = 1;
    end
    % plot Dwell Times histogram with bin size setted by user
%     histogram(ax1,C.Traces{1}.CategoryAnalysis{kh}.DwellTimes{dwell_select},...
%         str2num(analysis_h.SidePanel.HistControl.Dwell.Main.String),...
%         'Normalization','pdf');
    if ~isempty(C.Traces{1}.CategoryAnalysis{kh}.DwellTimes{dwell_select})
        h = histogram(ax1,C.Traces{1}.CategoryAnalysis{kh}.DwellTimes{dwell_select},...
            'BinWidth',freedman_diaconis_rule,...
            'Normalization','pdf');
        set(h,'BinLimits',[freedman_diaconis_rule,h.BinLimits(2)]);
    end
    
    
    xlim(ax1,'auto');
    stp = C.Traces{1}.CategoryAnalysis{kh}.DwellTimes{dwell_select};
    %stp = stp(stp > freedman_diaconis_rule & stp <h.BinLimits(2));
    exp_dist = fitdist(transpose(stp),'Exponential');
    dwellTime_miuhat = 1/exp_dist.mu;
    
    miu = dwellTime_miuhat;
    x_lim = ax1.XLim;
    x = linspace(x_lim(1),x_lim(2),100);
    expon = miu*exp(-miu*x);
    
    p = plot(ax1,x,expon,'r','LineWidth',2);
    
    % create context menu's
    c = uicontextmenu;
    p.UIContextMenu = c;
    
	c_linear = uimenu(...
    'Parent',c,...
    'Label','Linear scale',...
    'Callback',{@change_display_mode,G});

    c_log = uimenu(...
    'Parent',c,...
    'Label','Semi-Log scale',...
    'Callback',{@change_display_mode,G});

    if dwell_select == 1
        title(ax1,'Dwell times histogram (global)');
    else
        title(ax1,sprintf('Dwell times histogram (from %i to %i)',dwell_select - 2,dwell_select - 1));
    end
    
    xlabel(ax1,'Time (s)');
    %ylabel(ax1,'Probability (%)');
    
    % semi-log scale
    set(ax1,'XScale','linear');
    set(ax1,'YScale','log');
    
    % Distribution information
    set(analysis_h.SidePanel.Distribution.Dwell.Label.Main,'String',[...
        'Expected dwell time (ms): ',sprintf('%.2f',1000/miu),...
        char(10)]);
end

function tracer_lbx_changed(~,~,G)
    
    T = G.Parent;
    C = G.Parent.Channel{T.ChannelsWithData(1)};
    analysis_h = G.Handles.Figure.Tabs.Analysis;
    ax = analysis_h.MainPanel.StepFit;
    % clear all graphs and re-plot them
    cla(ax,'reset');
    
    % hide axis (turn them white)
    yyaxis right;
    set(ax,'YColor','w');
    yyaxis left;
    set(ax,'YColor','w');
    
    hold(ax,'on');
    
    if isempty(find(C.TraceCat(:,analysis_h.SidePanel.Navigation.CategoryListbox.Main.Value)))
        p = plot(analysis_h.MainPanel.StepFit,[0]);
    else
        
        k = str2num(analysis_h.SidePanel.Trace.Listbox.Main.String(...
            analysis_h.SidePanel.Trace.Listbox.Main.Value,:));
        
        sz = length(C.Traces{1}.TracesCorrected{k});
        
        leg = {};
        
        if analysis_h.SidePanel.PlotControl.TraceData.Main.Value
            yyaxis left;
            p = plot(ax,...
                (1:sz)/100,C.Traces{1}.TracesCorrected{k},'b');
            
            yyaxis left;
            ylabel(ax,'Intensity');
            set(ax,'YColor','k');
            
            leg = [leg;'Trace data'];
        end
        
        if analysis_h.SidePanel.PlotControl.FitFunction.Main.Value
            yyaxis left;
            p = plot(ax,...
                (1:sz)/100,C.Traces{1}.StepsFitFunction{k},'k');
            p.LineWidth = 2;
            
            yyaxis left;
            ylabel(ax,'Intensity');
            set(ax,'YColor','k');
            
            leg = [leg;'Fit function'];
        end
        
        
        
        if analysis_h.SidePanel.PlotControl.MonomerNumber.Main.Value

            yyaxis right;
            ylabel(ax,'Monomer number');
            set(ax,'YColor','r');
            p = plot(ax,...
            	(1:sz)/100,C.Traces{1}.MonomerNumber{k},'r');
            
            ax = analysis_h.MainPanel.StepFit;
            
            get(ax.YAxis)
            %ax.YAxis(2).Label.String = 'Monomer Number';
            %ax.YAxis(2).Color = 'r';
            
            % resize y-right-axis to match y-left-axis
            if analysis_h.SidePanel.PlotControl.FitFunction.Main.Value || ...
                    analysis_h.SidePanel.PlotControl.TraceData.Main.Value
                left_limits = ax.YAxis(1).Limits;
                   ax.YAxis(2).Limits = left_limits./C.Traces{1}.RealStep{k};
                right_limits = ax.YAxis(2).Limits;
                ax.YAxis(2).TickValues = 0:ceil(right_limits(2));
            else
                right_limits = ax.YAxis(2).Limits;
                ax.YAxis(2).TickValues = 0:ceil(right_limits(2));
            end
            
            % add grid lines
            p = plot(ax,...
                (1:sz)/100,repmat((0:2:ax.YAxis(2).Limits(2))',1,sz),'c');
            
            % replot this graph to print over grid
            p = plot(ax,...
            	(1:sz)/100,C.Traces{1}.MonomerNumber{k},'r');
            
            p.LineWidth = 2;
            
            leg = [leg;'Monomer number'];
            %set(ax.YAxis(2).Parent,'YGrid','on');
        end
        
        title(ax,'Step fit function');
        legend(ax,leg);
        xlabel(ax,'Time(s)');
        
    end
    yyaxis left;
    hold(ax,'off');
end

function outliers_changed(~,~,G)
    T = G.Parent;
    C = G.Parent.Channel{T.ChannelsWithData(1)};
    analysis_h = G.Handles.Figure.Tabs.Analysis;
    
    ax2 = analysis_h.MainPanel.HistogramSteps;
    kh = analysis_h.SidePanel.Navigation.CategoryListbox.Main.Value;
    outlier = analysis_h.SidePanel.Distribution.StepSize.Outliers.Main.Value;
    
    stp = C.Traces{1}.CategoryAnalysis{kh}.StepSizes;
    
    cla(ax2);
    
    if outlier
        %deal with step Size outliers
        IQR = iqr(stp);
        k = 1.5;
        stp = stp(stp > quantile(stp,0.25) - k*IQR & stp < quantile(stp,0.75) + k*IQR);
        % analyse.StepSizes = stp(isoutlier(stp,'median'));
    end
    
    histogram(ax2,stp,...
        str2num(analysis_h.SidePanel.HistControl.Steps.Main.String),...
        'Normalization','pdf');
    
    xlim(ax2,'auto');
    
    norm_dist = fitdist(transpose(stp),'Normal');
    stepSize_miuhat = norm_dist.mu;
    stepSize_sigmahat = norm_dist.sigma;
    
    miu = stepSize_miuhat;
    sigma = stepSize_sigmahat;
    x_lim = ax2.XLim;
    x = linspace(x_lim(1),x_lim(2),100);
    norm = exp(-(x-miu).^2./(2*sigma^2))./(sigma*sqrt(2*pi));
    
    plot(ax2,x,norm,'r','LineWidth',2);

    title(ax2,'Step sizes histogram');
    xlabel(ax2,'Step size');
    %ylabel(ax2,'Probability (%)');
      
    set(analysis_h.SidePanel.Distribution.StepSize.Label.Main,'String',[...
        'Expected step size: ',sprintf('%.2f',miu),...
        char(10),...
        'Standart deviation: ',sprintf('%.2f',sigma),...
        char(10)]);
    
end

function change_display_mode(src,~,G)
    T = G.Parent;
    C = G.Parent.Channel{T.ChannelsWithData(1)};
    analysis_h = G.Handles.Figure.Tabs.Analysis;
    ax = analysis_h.MainPanel.HistogramDwell;
    
    switch src.Label
        case 'Linear scale'
            set(ax,'XScale','linear');
            set(ax,'YScale','linear');
        case 'Semi-Log scale'
            set(ax,'XScale','linear');
            set(ax,'YScale','log');
    end
end





