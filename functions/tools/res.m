function out = res(G,t)
% generate Matlab-HTML compliant links for res path
% necessary for icon and image display in GUI
out = ['<html><img src="',G.Parent.ResPath,t,'"></html>'];
end