%% OpenTiff function
% Reads a TIF image stack into the _img_ matrix
%% INPUT arguments
% * _fullpath:_ Path to tif file
% * _range:_    Array with images to load [from:to]
%
%% OUTPUT arguments
% * _I:_    array with image stack
% * _msg:_  string output with details on file, frame count and time
%
function [I,msg] = openTiff(fullpath, varargin)

%try
tI = imfinfo(fullpath); % get TIF frame count and metadata
wI=tI(1).Width;         % width of each frame
hI=tI(1).Height;        % height of each frame
nI=length(tI);          % number of frames
%warning off;


%% EXPERIMENT: TIFF Library to read

range = [1,nI];

if ~isempty(varargin)
    
    for c = 1:length(varargin)
        switch varargin{c}
            case 'Range'
                % range specified
                range = varargin{c+1};
            case 'InternalWaitbar'
                w = waitbar(0,'Loading Data, please wait...');
            case 'ExternalWaitbar'
                h = varargin(c+1);
            otherwise
        end
    end
end


%j = java.util.Collections.synchronizedSet(java.util.HashSet());
j = 1;
I = zeros(hI,wI,numel(range(1):range(end)));    % create new 2*2*N_wanted_frames matrix (with zeros)
warning('off','MATLAB:imagesci:tiffmexutils:libtiffWarning');
tp = Tiff(fullpath, 'r');
fprintf('\n')
disp(['Reading Data from ''',fullpath,'''...']);
disp('Loading:     ');
for i=range(1):range(end)
    tp.setDirectory(i)
    I(:,:,i) = double(tp.read()); %convert from uint16 to double - /§%$&" MATLAB!!!
    %add(j,i-range(1)+1);
    %jj = j.size();
    % print command window progress
    fprintf('\b\b\b\b\b\b%3.0f %%\n',j/(range(end)-range(1)+1)*100);
%     fprintf('%3.0f%%',j/(range(end)-range(1)+1)*100)
    
    if exist('w','var')
        waitbar(j/(range(end)-range(1)+1));
       
    elseif exist('h','var')
        progBar(j/(range(end)-range(1)+1), h);
    end
    j=j+1;
end

if exist('w','var')
    close(w);
    fprintf('\n')
end
tp.close();
fprintf(repmat('\b', 1, 15))
msg = ['Successfully loaded ',num2str(j),' frame(s).'];
disp(msg);
disp(repmat('-',1,40));
%warning on;

end



function progBar(v, h)
% updates progress bar in main figure status bar
v = round(v,2);
if ~exist('h','var')
    %waitbar
    waitbar(v);
else
    % main GUI progressbar
    h.Vertices = [0,0;0,1;v,1;v,0];
    drawnow;
end
end
