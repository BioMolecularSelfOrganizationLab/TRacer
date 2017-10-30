%% initializeConstants() Function
%
% This function prepares the global GUI variables and constants
% 

function initializeConstants()
global C res img M;

%%  Assign Window and GUI properties
%

C.AxesColor = [1 1 1];
% C.BackColor = [0.2 0.2 0.2];
C.BackColor = [1 1 1];
C.ControlColor = [0.4 0.4 0.4];
C.DisabledColor = [0.2 0.2 0.2];
C.ShadowColor = [0.4 0.4 0.4];
C.ForeColor = [0 0 0];
C.Type=0;

%
C.WaP = 0.7;                                            % width of axes panel
C.WeP = 1 - C.WaP;                                  % width of eval side panel
C.HePu = 0.5;                                           % height of upper eval panel                   
C.HePl = 1 - C.HePu;                                % height of lower eval panel 

% deprecated
C.cbH = 30;                                             % Default Button height
C.cbW = 90;                                             % Default Button width
C.cbS = 60;                                             % Zoom axes fine control button size
C.UIs = 20;                                             % Default UI control spacing
C.ckW = 28;                                             % Default Check Box width
C.ckH = 16;                                             % Default Check Box height
C.CPH = C.UIs * 7.5 + C.cbH * 6;                % Control Panel height for 2 buttons and 3 spacings in px, 0.5 UIs UI panel title height correction
C.CPW = C.UIs * 3.5 + C.cbW;                    % Control Panel width for 1 button + 1 Check box and 3 spacings in px, 0.5 UIs UI panel title width correction
C.APH = 612;                                            % Main Axes Panel height in px
C.APW = 256;                                            % Main Axes panel width in px
C.mAH = 512;                                            % Main Axes height in px
C.zAP = (C.CPH - 4*C.UIs) / 2;                  % Zoom Axes Panel height/witdth in px
C.AxesOffset = [C.UIs,C.UIs*3,C.APW,512];   % image axes position and size
C.z = 9;                                                % particle selection circle radius
C.colors = {'b',[.5,.7,0],'r',[.855,.702,1],[.2,.2,.2],'y'};           % Colors of axes and according plots
C.lbx = {...
    'ch.1 [X]','ch.1 [Y]',...
    'ch.2 [X]','ch.2 [Y]',...
    'ch.3 [X]','ch.3 [Y]',...
    'ch.4 [X]','ch.4 [Y]',...
    };                                                      % Selection listbox column titles
C.uitable = [];                                         % Prepare array for listbox data                                    
%% Other Variables


C.defaultpath = pwd;                                    % assign TRacer path as starting path
C.respath = strrep(...
    ['file:/',fullfile(pwd,'res')],'\','/');                % generate Matlab-HTML compliant path
C.ALEXch = ['-'];                                       % excitation lasers in use. default: empty = no ALEX
C.ALEXcurrent = ['-'];                                  % default to no ALEX
C.movAvg = 50 - 1;                                      % moving average for tif stack maximum intensity projection

C.sPSF = 2;                                             % PSF mask radius
C.sBG = 2;                                              % BG mask radius
C.mPSF = circ(C.z * 2 + 1,C.sPSF);
C.mBG = circ(C.z * 2 + 1,C.sPSF,C.sPSF+C.sBG);

C.particleShape = uint16(padmatrix(...
    getnhood(strel('disk', 5)),[19,19]));                      % filtering shape for particle cropping
C.backgroundShape = uint16(padmatrix(...
    getnhood(strel('disk', 7)),[19,19])) - C.particleShape;      % filtering shape for neigbourhood cropping

C.cmaps = {'parula','jet','hsv','hot',...
    'cool','spring','summer','autumn',...
    'winter','gray','bone','copper',...
    'pink','lines','colorcube','prism',...
    'flag','white'};                                 % Colormaps for images
C.cmaps_sel = 2;                                        % set jet as default colormap
C.mapCh = 1;                                        % default mapping channel
C.locCh = 1;                                        % default part localization channel
C.fps = 30;                                         % frame exposure time in [ms]
C.g = [1 .6 .36 .216;1 1 .5 .25;1 1 1 .5];        % default gamma factor value to correct for different Q.Y. of don-acc FRET efficiency
                                                        %   (Row1: Ch1->Ch2,Ch1->Ch3, Ch1->Ch4; Row2: Ch2->Ch3, Ch2->Ch4; Row 3: Ch3->Ch4
                                                        %   In case of a FRET
                                                        %   cascade such as Ch1->Ch2->Ch3:
                                                        %   g(Ch1->Ch3) = g(Ch1->Ch2) * g(Ch2->Ch3)

C.b = 0.05;                                         % default beta factor value to correct for different Q.Y. of don-acc FRET efficiency


C.mapthresh = 1.990;        

C.navkeys = 'wasd';                                % keys reserved for basic navigation within traces

[res,img,M] = deal({});                                     % introduce res and img as cell arrays
[res{1:4}] = deal({});                                    % assign res array
[img{1:4}] = deal({});                                    % assign img array
[M{1:4}] = deal({});                                    % assign img array





end