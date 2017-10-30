function [out] = imgsplit(img, P )
%IMGSPLIT splits an stack img and returns arrays with the desired splitting
%pattern defined in P

% P is a 1-dim vector defining the split frames


%% Exceptions
% f = 'imgsplit]:';
% MEsz = MException('imgsplit:size', ...
%     [f,'The split pattern defines a total of %d, while the input stack only contains %d images.'],[sum(P(:)),size(img,3)]);
% MEns = MException('imgsplit:nostack', ...
%     [f,'The input image consists of only one image.']);
% MEns = MException('imgsplit:dims', ...
%    [f,'The split array is too large, it has to be a 1-dim vector.']);
%
% %%
%
% if max(size(P)) > size(img,3)
%     throw(MEsz);
% end
%

%% Function
% initiate output array
[out{1:numel(P)}] = deal({});

out{1} = img(:,:,1:P(1));
for i=1:numel(P)-1
        out{i+1} = img(:,:,sum(P(1:i))+1:sum(P(1:i+1)));
end

% % if there are unreturned frames left:
% if before < size(img,3)
%    out{i+1} = img(:,:,before:size(img,3));
% end

end