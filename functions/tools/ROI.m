%% ROI() function
%   returns selection from matrix
%
%
%% INPUT options:
% * _inp:_ Array (Y,X)
% * _P:_ 
% * _shape:_ 
%	'arbitrary', 'pair', 'diamond', 'periodicline', 'disk'
%	'rectangle', 'line', 'square', 'octagon'; default: 'rectangle'
% * _para:_ 
%
%% OUTPUT:
% * _out:_ Output ROI
function [out] = ROI(inp, P,shape,para)

SE = getnhood(strel(shape, para)) % create structuring element & return as binary array
sSE = floor(size(SE)/2)

% switch shape
%     case 'diamond'
%     case 'disk'
%     case 'line'
%     case 'square'
%     otherwise
%        
% end
try
out = inp(P(1)-sSE(1):P(1)+sSE(1),P(2)-sSE(2):P(2)+sSE(2)) .* SE; %return output
catch
    fprintf(2, '[ROI]: Error, selection out of bounds.\n');
end
end