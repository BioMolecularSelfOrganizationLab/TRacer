%% cumIMG() FUNCTION
%
% generates cumulative Image of whole stack for selected channel under all
% unique excitations
%
%% INPUT:
%s
% * _img:_ input image stack
% * _seq:_ ALEX sequence as string until repeat (i.e. dBBGRG)
% * _ex:_ excitation channel to sum up, such as 'R'
% * _movAvg:_ size of moving average window for max intensity proj

%% OUTPUT:
% * B:_ cumulative image

function [A] = cumIMG(img, seq, ex, firstFrame, moveWindowSize, mode)

% ex = num2str(ex); % MATLAB AND ITS STUPID AUTOMATIC TYPE TRANSITIONS

img = img(:,:,seq(:)==ex); % only loop over images for the appropriate ALEX


s = size(img,3);

A = zeros(size(img,1),size(img,2)); % assign arrays

switch mode

    case 'Sum'
        A = sum(img(:,:,firstFrame:(firstFrame + moveWindowSize - 2)),3);

    case 'Max'
        A = max(img(:,:,firstFrame:(firstFrame + moveWindowSize - 2)),[],3);

end
    

end


