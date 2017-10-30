function [x0,y0,sx,sy,OD] = gaussfit2D(I, t)
% fits a gaussian to matrix I with tolerance t and returns centroid (x0,y0)
% and sigma (sx, sy)
S = size(m);

[x,y] = meshgrid(-S(2):S(2),-S(1):S(1));
% F: a1*exp(-(x-x0)^2/(2*sigmax^2)-(y-y0)^2/(2*sigmay^2))




end