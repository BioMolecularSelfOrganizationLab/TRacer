classdef TIRFdata < handle
    %TIRFDATA class
    %   collects data about measurements and provides methods for handling
    %   it
    
    properties
        
        % MAIN Props
        ChannelID = 5       % ESSENTIAL Holds the number of the detection channel /camera#
        ChannelColor        % Holds string with detection color of this channel as selected in GUImeasurementparams()
        ALEXID;             % ALEX excitation channel used for particle detection
        ChannelColorIndex   % Index of color as number in array {B,G,R,IR}
        ContrastThreshold   % Value of contrast slider for better visibility of particles in Data tab
        
        % GENERAL Props
        Parent
        FilePath = {'',''} % full path to raw files as {'dir','file'} cell
        MapPath = {'',''} % full path to map files as {'dir','file'} cell
        LastFolder % last used folder for map/image loading
        Status %chold status message strings and progress percentile
        
        % GEOMETRY settings
        
        Rotation % if rotation is performed during loading, this is the rotation angle in degrees
        Crop % if cropping was performed, this will hold the corner points from inbetween which was cropped
        Flip % if true, then flip vertically/horizontally
        
        % IMAGE data
        RawData % raw image data
        RawMap % Image containing the Map
        Cumulated % Maximum Intensity / Cumulated single frame from whole data
        SumMap
        MaxMap
        CumulatedWarped % cumimage warped to reference channel coordinates
        
        % Cumulative image data
        firstFrame_slider % [min,max,value]
        windowSize_slider % [min,max,value]
        method_mode % mode: 'Sum', 'Max' or 'Weighted Mean'
        
        % MAPPING
        MapParticles % XY array with map particle coordinates
        MappingThreshold % particle detection Threshold in % of max
        MapParticlesTransformed % XY array with map particles transformed to reference channel coordinates
        MapLine % coordinates of user selected line for coarse mapping (2x2 matrix)
        MapToReference % Map to transform particles to reference image set in parent TRACERdata:MappingReferenceChannel property
        MapFromReference  % Map to transform particles from reference image to this image
        MapResultImage % Holds Mapping Result Image
        
        % RESULTS
        
        
        Particles % XY array with particle coordinates
        ParticlesMapped % particles common with mapping channel particles (just indices for the Particles property)
        
        Traces = {} % traces for those particles (background corrected) (cell array)
        TraceCat;    % boolean matrix with categories for each state. cols: index of TRACEdata.TraceCategories field; rows: index of trace
        Background = {} % traces of mean background
        Photons % SNR = intensities summed up until bleaching
        
        
        
    end
    
    methods
        
        
        
        % CONSTRUCTOR
        function C = TIRFdata(T,channel)
            C.Parent = T;
            C.ChannelID = channel;
            
            % create TRACE subclasses
            % C.Traces{1} = TRACEdata(C);
            
            
            
        end
        
        
        
        function C = LoadMap(C, varargin)
            
            hasDirectory = 0;
            
            if ~isempty(varargin)
                for c=1:length(varargin)
                    if ischar(varargin{c})
                        switch varargin{c}
                            case 'LoadExistingMap'
                                % existing map; load from .MAT file
                                if C.LastFolder == 0; C.LastFolder = pwd;end
                                [file,C.LastFolder] = uigetfile('*.mat','Load existing map',C.LastFolder);
                                if ~file
                                    C.Status = 'Map loading aborted.';
                                    return
                                end
                                
                                load([C.LastPath,file]);
                                
                                C.MapFromReference = [];
                                C.MapToReference = [];
                                
                            case 'Button'
                                hasDirectory = 1;

                        end
                    end
                end
                
            end
            
            % get path and file name
            handle = C.Parent.GUI.Handles.Figure.Tabs.Mapping.LoadFiles.LoadFilesPanel;

            if isempty(C.LastFolder);C.LastFolder = pwd;end

            if hasDirectory
                if strcmp(handle.DirectoryPanel.DirectoryPath.Main.String,'No files')
                    return;
                end

                C.MapPath{1} = handle.DirectoryPanel.DirectoryPath.Main.String;                         % dir
                C.MapPath{2} = handle.FilesListBox.Main.String(handle.FilesListBox.Main.Value,:);       % filename
            else
                [C.MapPath{2},C.MapPath{1}] = uigetfile('*.tif;*.tiff','TIF Images',C.LastFolder);
                if ~C.MapPath{2}                    % exit function, if filename is empty
                    return;
                end
            end

            C.Status = ['Loading file: ', [C.MapPath{:}]];
            C.LastFolder = C.MapPath{1};
            [C.RawMap,C.Status] = openTiff([C.MapPath{:}],'InternalWaitbar');
            C.RawMap = mean(C.RawMap,3); % open map and calculate mean from stack to reduce to one frame

            
            % GUI with crop, rotation and flip controls:
            h = GUIchannels(C, C.RawMap);
            C.Parent.Channel{C.ChannelID} = C;
            waitfor(h);

            
            % perform transformations:

            if ~isempty(C.Rotation)
                % Different Channel Rotation, rotate accordingly
                C.RawMap = imrotate(C.RawMap,-C.Rotation);
            end

            if ~isempty(C.Crop)
                % Different Channel Alignment, crop accordingly
                t = C.Crop;
                C.RawMap = C.RawMap(t(1,1):t(2,1),t(1,2):t(2,2));
            end

            if ~isempty(C.Flip)
                % Different Channel Flip, crop accordingly
                if C.Flip(1) == 1; C.RawMap = flipud(C.RawMap);end
                if C.Flip(2) == 1; C.RawMap = fliplr(C.RawMap);end
            end

            % Load into gui for map creation
            m = C.Parent.GUI.Handles.Figure.Tabs.Mapping.MainPanel.ChannelPanel{C.ChannelID}.MapAxes;
            m.Main.XLim = [0, size(C.RawMap,2)];
            m.Main.YLim = [0, size(C.RawMap,1)];  % set axes limits to size of image

            % delete images/imline/scatter
            if ~isempty(m.Main.Children)
                m.Main.Children(1:end).delete;
            end
            
            % load image
            m.Map = imagesc(C.RawMap,'Parent',m.Main);
            
            % apply threshold
            tr = C.RawMap;
            mx = max(tr(:));
            threshold = C.Parent.GUI.Handles.Figure.Tabs.Mapping.MainPanel.ChannelPanel{C.ChannelID}.ContrastSlider.Main.Value;
            tr(tr<threshold*mx) = 0;
            m.Main.Children(1).CData = tr;
            
            % find all maxima/particles in RawMap
            C.MapParticles = findPart(tr, C.Parent.MaskPSF,C.Parent.MaskBG);
            
            % plot particle locations:
            scatter(m.Main, C.MapParticles(:,2), C.MapParticles(:,1), 'o', 'w', 'HitTest', 'off');
 
            %create alignment tool
            m.Line = imline(m.Main,size(C.RawMap,2)*[0.2,0.8],size(C.RawMap,1)*[0.2,0.8]);
            
            % prevent line from getting outside of the axis
            api = iptgetapi(m.Line);
            fcn = makeConstrainToRectFcn('imline',get(m.Main,'XLim'),get(m.Main,'YLim'));
            api.setPositionConstraintFcn(fcn);
            api.setColor([0,1,0]);
           
            % return new handles
            C.Parent.GUI.Handles.Figure.Tabs.Mapping.MainPanel.ChannelPanel{C.ChannelID}.MapAxes = m; 
            
            maximizeCurrentWindow();
        end
        
        
        
        function C = LoadData(C, varargin)
            % loads image data
            
            % get file path
            if isempty(C.LastFolder);C.LastFolder = pwd;end
            [C.FilePath{2},C.FilePath{1}] = uigetfile('*.tif;*.tiff','TIF Images',C.LastFolder);
            if ~C.FilePath{2}                    % exit function, if filename is empty
                return;
            end
            
            C.Status = ['Loading file: ', [C.FilePath{:}]];
            C.LastFolder = C.FilePath{1};
            
            [C.RawData,C.Status] = openTiff([C.FilePath{:}],'InternalWaitbar');
            
            % postprocessing operations (crop, rotate) - use same as for map
            
            if ~isempty(C.Rotation)
                % Different Channel Rotation, rotate accordingly
                C.RawData = imrotate(C.RawData,-C.Rotation);
            end
            
            if ~isempty(C.Crop)
                % Different Channel Alignment, crop accordingly
                t = C.Crop;
                C.RawData = C.RawData(t(1,1):t(2,1),t(1,2):t(2,2),:);
            end
            
            if ~isempty(C.Flip)
                % Different Channel Flip, crop accordingly
                if C.Flip(1) == 1; C.RawData = flipud(C.RawData);end
                if C.Flip(2) == 1; C.RawData = fliplr(C.RawData);end
            end
            
            % ask for measurement parameters
            waitfor(GUImeasurementparams(C));
            
            handle = C.Parent.GUI.Handles.Figure.Tabs.Data.SidePanel;
            handle.CumulatedImage.FirstFrame.Main.Min = C.firstFrame_slider(1);
            handle.CumulatedImage.FirstFrame.Main.Max = C.firstFrame_slider(2);
            handle.CumulatedImage.FirstFrame.Main.Value = C.firstFrame_slider(3);
            
            handle.CumulatedImage.WindowSize.Main.Min = C.windowSize_slider(1);
            handle.CumulatedImage.WindowSize.Main.Max = C.windowSize_slider(2);
            handle.CumulatedImage.WindowSize.Main.Value = C.windowSize_slider(3);
            
            % optimize to one line:...
            if C.method_mode == 'Sum'
                handle.CumulatedImage.Method.Main.SelectedObject = ...
                    handle.CumulatedImage.Method.Sum.Main;
            else
                handle.CumulatedImage.Method.Main.SelectedObject = ...
                    handle.CumulatedImage.Method.Max.Main;
            end
                    
            wb = msgbox({'Loading TIFF image...','Please wait'});
            
            if ~strcmp(C.Parent.ChannelsWithData,C.ChannelID)
                 C.Parent.ChannelsWithData(end+1)= C.ChannelID;
            end
            C.Parent.ChannelsWithData = sort(C.Parent.ChannelsWithData);
            
            % update Traces GUI with correct camera color description and
            % add legend
            C.Parent.GUI.Handles.Figure.Tabs.Traces.MainPanel.ChannelPanel{C.ChannelID}.Main.Title = [C.ChannelColor, ' Camera'];
            
            try
                C.CumulatedWarped = imwarp(C.Cumulated, C.MapFromReference, 'OutputView', imref2d(size(C.Cumulated)));
            catch
            end

            % create Traces objects and calculate cumulated images for whole image...
            AU = unique(C.Parent.ALEXorder); % unique ALEX excitations
            if AU > 1
                for i = 1:numel(AU)
                    C.Traces{i} = TRACEdata(C, AU(i));
                    
                    handle = C.Parent.GUI.Handles.Figure.Tabs.Data.SidePanel;
                    firstFrame = round(handle.CumulatedImage.FirstFrame.Main.Value);
                    windowSize = round(handle.CumulatedImage.WindowSize.Main.Value);
                    mode = handle.CumulatedImage.Method.Main.SelectedObject.String;
                    C.Traces{i}.CalcCumulated(firstFrame,windowSize,mode);

                end
            else
                C.Traces{1}.Cumulated = C.Cumulated;
            end

            % update Channel Slider
            c = C.Parent.GUI.Handles.Figure.Tabs.Data.MainPanel.ChannelPanel.ChannelSlider.Main;
            c.Min = 1; c.Max = length(C.Parent.ChannelsWithData);
            if c.Max == 1
                c.SliderStep = [1,1];
                c.Enable = 'off';
            else
                c.SliderStep = [1/(c.Max-c.Min),1/(c.Max-c.Min)];
                c.Enable = 'on';
            end
            c.Value = C.ChannelID;
            
             ...and load first into gui
            m = C.Parent.GUI.Handles.Figure.Tabs.Data.MainPanel.ChannelPanel.DataAxes;
            m.Main.XLim = [0, size(C.Cumulated,2)];
            m.Main.YLim = [0, size(C.Cumulated,1)];  % set axes limits to size of image
            if isempty(m.Main.Children)
                m.Data = imagesc(C.Cumulated,'Parent',m.Main);
            else
                m.Main.Children(end).CData = C.Cumulated;
            end
            m.Main.CLim = C.ContrastThreshold; % set limits for colormap
            o = C.Parent.GUI.Handles.Figure.Tabs.Data.MainPanel.ChannelPanel.ContrastSlider.Main;
            o.Min = C.ContrastThreshold(1); o.Max = C.ContrastThreshold(2);  o.Value = 0.5*mean(C.ContrastThreshold(:));
            C.Parent.GUI.Handles.Figure.Tabs.Data.MainPanel.ChannelPanel.ContrastSlider.Main = o;

            close(wb);
            obj = C.Parent.GUI.Handles.Figure.Tabs.Data.MainPanel.ChannelPanel.ThresholdSlider.Main;
            hgfeval(obj.Callback,obj,C.Parent.GUI);
            C.Parent.GUI.Handles.Figure.Tabs.Main.SelectedTab = C.Parent.GUI.Handles.Figure.Tabs.Data.Main;
        end
        
                
        
        
        
        
        % GENERAL METHODS
        
        function C = set(C, varargin)
            % defines basic set method
            if mod(nargin-1,2) ~= 0
                error('Incorrect number of inputs.  Must be an even number of inputs.');
            end
            for i=1:2:nargin-1
               C.(varargin{i}) = varargin{i+1};
            end
        end
        
        function R = get(C,varargin)
            % defines basic get method
            switch nargin
                case 1 % return full object
                    R = C;
                case 2 % return single field
                    if ~isfield(C, varargin{1})
                        error([varargin{1},' is not a field or member of class ''',class(T),'''.']);
                    end
                    R = C.(varargin{1});
                otherwise
                    error('usage: Object.get(''Fieldname'').');
            end
            
        end
    end
end
