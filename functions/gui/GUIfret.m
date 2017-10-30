%%  FRET GUI
%
%   generates figure to display FRET traces

function GUIfret()
global h prefs;

%% Main Figure

h.open = figure(...
    'Name', 'Open File',...
    'NumberTitle','off',...
    'units', 'normalized', ...
    'OuterPosition', [0.3 0.3 0.7 0.7],...
    'units','pixels',...
    'Color', prefs.BackColor,...
    'CloseRequestFcn', @fret_close,...
    'MenuBar', 'none',...
    'Toolbar', 'none');



h.preview = uipanel(...
    h.open,...
    'Tag', 'Preview',...
    'Title', 'Trace preview',...
    'BackgroundColor',prefs.BackColor,...
    'ForegroundColor', prefs.ForeColor,...
    'Clipping', 'on',...
    'Position',[0,0,.6,1]);

h.options = uipanel(...
    h.open,...
    'Tag', 'Preview',...
    'Title', 'Options',...
    'BackgroundColor',prefs.BackColor,...
    'ForegroundColor', prefs.ForeColor,...
    'Clipping', 'on',...
    'Position',[0.6,0,.4,1]); 
end
function fret_close(hObj,~,~)
delete(hObj);
end