classdef TRACERdata < handle
    % Provides all TRACER methods and properties
    
    properties
        
        % GENERAL and GUI SETTINGS
        GUI;                                                         % holds GUIdata class with all GUI-related settings and handles
        LastPath = pwd;                                              % last path used (now: current TRacer folder)
        ResPath = strrep(['file:/',fullfile(pwd,'res')],'\','/');    % generate Matlab-HTML compliant path
        
        % MEASUREMENT PARAMETERS, PARTICLES and COLOCALIZATION
        Channel = {};                       % create empty cell array to hold TIRFdata classes with image and trace data
        ChannelsWithData = []        % indicator for channel objects containing actual data
        ALEXcurrentSelection = 1;           % this is the currently selected ALEX channel for trace extraction and GUI update
        ALEXnumberofchannels = 1;           % number of independent ALEX channels
        ALEXorder = 'N'                     % array of indices of ALEX excitation., N = no alex, default
        ALEXsequence                        % repmat of ALEXorder with blank frame excluded at beginning;length = number of frames; array of ones: no alex
        ALEXlaserPowers                     % Array with used laserpowers for each laser in the excitation order specified in ALEXorder
        MappingReferenceChannel = 1;        % the channel to which the other channels are mapped
        ParticlesColocalized                % boolean colocalization matrix in reference channel coordinates as (X|Y|Ch1|Ch2|Ch3|Ch4)
        FrameTime = 10                      % Time for one frame cycle (frame transfer + exposure + delay) in ms
        ExtractionMethod = 'Sum'            % Method used for trace extraction. changed via radiobutton on Data Tab
        RunningAverageNumber = 15;          % Number of frames of moving average maximum intensity projection for calculation of cumulated img
        
        % TRACES related
        TraceCategories  = {'Uncategorized'}% Trace category names, are indexed in each TIRFdata object, Uncategorized is always available (and chosen, if trace column indices in 'TIRFdata.TraceCat' are all zero
        TraceKeys = {'1'}                   % Cell array containing customly assigned keys for trace navigation in the order of T.TraceCategories (u= delete categories/uncategorized
        CurrentTrace                        % currently selected trace
        TraceDisplayMode = 2;                % 1: 1 camera per plot; 2: 1 excitation per plot (default for single color ex)
        FRETtable = [[1,2;1,3;2,4;3,4;1,4;2,3], zeros(6,3)]  % stores the FRET relationships and gamma and beta values of the employed fluorophores, structure: |D(ChannelID)|A(ChannelID)|gamma|beta|
        
        
        % PARTICLE MASK
        
        MaskType = 1                                % PSF mask type; 1='manual';2='auto' 
        MaskOuterSize = 9                           % Radius of circular mask, mOS * 2 + 1 = total mask dimensions
        
        MaskPSFParticleThreshold = 0.75;            % psf threshold for autocorr. psf calculation...
        MaskPSFUpperBackgroundThreshold = 0.45;     % ...same for upper background limit
        MaskPSFLowerBackgroundThreshold = 0.25;      % ...and lower background limit
        
        MaskPSF             % mask of particle
        MaskBG              % mask of background around particle (bool array)
        MaskAuto            % mask gained from autocorrelation with genPSF()
        
    end
    
    methods
        % CONSTRUCTOR
        
        function T = TRACERdata
            % create empty TIRFdata class for each camera channel
            for i=1:4
                T.Channel{i} = TIRFdata(T,i);
            end
            
            G = GUIdata(T);
            G = G.createGui();
            T.GUI = G;
            % create particle masks for trace extraction and background
            % correction:
            
            T = genMask(T);
        end
        
        %IMAGE Manipulation
        function T = LoadData(T)
        end
        
        function T = CreateMap(T)
            % creates new map with/in gui with available channels
            % containing a cumulated map image
        end
    end
    
end

