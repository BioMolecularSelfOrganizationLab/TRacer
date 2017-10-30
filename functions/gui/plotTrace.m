%% PLOTTRACE() function
% 
% Updates h.trax axes (main trace plot axes)
%
function plotTrace(c);
global img res prefs h; % kinda sloppy, passing globals as args would be better...
% empty trace window, if more traces than channels are displayed
if size(get(h.trax, 'Children'),1) >= numel(find(~cellfun('isempty', img)))
cla(h.trax);
end

XY = floor(res{c}.lastpos);
for i = 1:sum(cellfun(@isempty, img))
plot(h.trax, 1:size(res{c}.trace{end},2), res{c}.trace{end},'Color', prefs.colors{c});
end
end