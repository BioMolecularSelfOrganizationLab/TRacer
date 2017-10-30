%% PADMATRIX() function
%
%   Pads matrix with zeros
%   by B.Salem, 2014
%% INPUT arguments
% *_A_: matrix to pad
% *_B_: desired output dimension as [x,y] array
%
function [output] = padmatrix(A,B)
if isempty(A) || isempty(B)
   sprintf('[PADmatrix:] No input specified.'); 
end
if max(B < size(A))
   fprintf(2, '[padmatrix] Error: Target array size is smaller than input array size.\n');
   return;
end

output = [...
    zeros(floor((B(1) - size(A,1))/2), B(2));...
    zeros(size(A,1),floor((B(2) - size(A,2))/2)),A,zeros(size(A,1),ceil((B(2) - size(A,2))/2));
    zeros(ceil((B(1) - size(A,1))/2), B(2))];
end