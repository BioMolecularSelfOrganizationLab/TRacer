function bool = filterPart(I, B, m,varargin)
% Checks for neighboring particles for image I with particle in center
%
% Return Values:
%   1: no neigboring particles
%   0: no neighboring particles detected
%  -1: error
%
% Input Values:
% I: image centered around particle (quadratic matrix)
% B: logical background mask, size identical to I
% m: method
%    Variance: check for variance across whole BG
%           * t = threshold value below which var should be
%    Segments: Divide Background mask into 4 segments and calculate
%           * t = threshold var of mean intensity across segments
%    RegMax: Look for local maxima in I
%
bool = -1;

if nargin > 2 && size(I,1) == size(I,2) && min(size(I) == size(B))
    % normalize input img: to max
    I = I ./ max(I(:));
    b = I .* double(B);
    switch m
        case 'Variance'
            if numel(varargin)==1
                t = varargin{1};
                if var(b(b(:)~=0)) > t
                    bool = 1;
                else
                    bool = 0;
                end
            end
        case 'Segments'
            % split b into segments and calculate segmentwise mean
            S = mat2cell(b,[floor(size(b,1)/2),size(b,1)-floor(size(b,1)/2)],[floor(size(b,2)/2),size(b,2)-floor(size(b,2)/2)]);
            for i = 1:4
               Sm(i) = mean(S{i}(S{i}(:)~=0));
            end
            
            if var(Sm) > t
                bool = 1;
            else
                bool = 0;
            end
        case 'RegMax'
            if sum(sum(imregionalmax(I))) == 1
                bool = 1;
            else
                bool = 0;
            end
    end
end
end