classdef GUIdata < handle
    % stores all GUI-related data such as control position, sizes and settings
    
    properties
        
        % COLOR Properties
        ChannelColors  % colors for traces and channels in the order of the channels (left to right)
        ChannelColorsText = {'B','G','R','IR'};   % text of channelcolors for correct plot coloring
        DefaultColors % Default control colors
        Colormaps % holds available Colormaps, first ist default
        ColormapCurrent % index for above struct with currently selected colormap
        
        % GENERAL Properties
        
        Handles % Cell array that stores all Handles
        Parent % holds TIRFdata Grandparent Handle for backreferencing
        DefaultControlSpacing = 20; % Default UI control spacing
        NavKeys  = {'w','a','s','d'};  % keys reserved for basic navigation within traces
        
        
        % GUI controls
        
        Button
        Axes
        Panel
        Figure
        CheckBox
        
        % Paths
        MainPath % Path holding main executable
        RessourcePath % Ressources Path (like GUI related icons, etc)
        
        %Ressources
        CurvedArrowIcon
        CenterArrowIcon = {};   % holds arrow icons: horizontal, vertical and crossed
        %

    end
    
    methods
        
        
        % CONSTRUCTOR for Default Values
        function G = GUIdata(C)
            
            G.Parent = C;
            
            G.ChannelColors = {'b',[.1,.7,.1],...
                'r',[.6,.1,.1],...
                [.2,.2,.2],'y'};
            
            
            
            G.DefaultColors =  struct(...
                'AxesColor',[1 1 1],...
                'BackColor',[1 1 1],...
                'ControlColor',[0.4 0.4 0.4],...
                'DisabledColor',[0.2 0.2 0.2],...
                'ShadowColor',[0.4 0.4 0.4],...
                'ForeColor',[0 0 0]);
            
            G.Colormaps = {'jet','parula','hsv','hot',...
                'cool','spring','summer','autumn',...
                'winter','gray','bone','copper',...
                'pink','lines','colorcube','prism',...
                'flag','white'};
            
            
            G.ColormapCurrent = 'hot';
            
            % GUI controls
            G.Button = struct(...
                'Height',30,...                                             % Default Button height
                'WidthNarrow',60,... % Default Button widths...
                'WidthNormal',90,...
                'WidthWide',120);
            
            G.Axes = struct(...
                'Height',612,...
                'Width',256,...
                'HeightZoom',60,...    % Zoom Axes Panel height/witdth in px
                'BackColor',G.DefaultColors.BackColor);
            
            
            G.Panel = struct(...
                'WidthMainPanel',0.7,...
                'WidthSidePanel',0.3,...
                'HeightSidePanelUpper',0.5,...
                'HeightSidePanelLower',0.5);
            
            G.CheckBox = struct(...
                'Height',16,...                                            % Default Check Box height
                'Width',16);
            
            
            G.MainPath = pwd;
            G.RessourcePath = strrep(['file:/',fullfile(pwd,'res')],'\','/');
            
            %G = createGui(G);
        end
        
        function G = createGui(G)
            % create Main GUI and children tabs
            G = createMainGui(G);
            splash =  SplashScreen('Loading TRacer', './res/tracer_splash.jpg');
            G = createMapTab(G);
            G = createDataTab(G);
            G = createTracesTab(G);
            G = createAnalysisTab(G);
            pause(1);
            delete(splash);
            % maximize main GUI window
            warning('off', 'MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
            waitfor(splash);
            maximizeCurrentWindow();
            
        end
    end
    
end

