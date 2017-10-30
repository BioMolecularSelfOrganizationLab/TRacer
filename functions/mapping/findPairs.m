function [XY1,XY2] = findPairs(XY1,XY2, tol)
% XY1, XY2 sets of xy coordinate matrices
% overlap coordinates and find pairs within tol

%determine distance matrix & according indices
% larger array:

% pad smaller array with zeros
if length(XY1) > length(XY2)
    [XY2;zeros(length(XY1)-length(XY2),size(XY2,2))];
elseif length(XY2) > length(XY1)
    [XY1;zeros(length(XY2)-length(XY1),size(XY1,2))];
end


[D,I] = pdist2(XY1(:,1:2),XY2(:,1:2),'euclidean','Smallest',1);
d = (D(:)<=tol);
XY2 = XY2(d,:);
XY1 = XY1(I(d),:);
end