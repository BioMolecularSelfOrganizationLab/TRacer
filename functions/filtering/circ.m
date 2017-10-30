%% CIRC(a,r,R) function
% generates circular and ring masks with radius r/outer radius R and total matrix size a

function [output] = circ(a,varargin)
output = double(zeros(a));
o = floor(a/2)+1;
try
    
    switch numel(varargin)
        case 2 % ring shape
            [r,R] = deal(1-varargin{1},1-varargin{2});
            r = floor(a/2*r);
            R = floor(a/2*R);
            % error handling...
            if R<=r;error('Syntax error, outer ring radius <= inner ring radius');
            elseif 2*R > a || 2*r > a;error('Circle diameter exceeds bounding matrix dimensions.');end
            for x=-R:R;for y=-R:R;s = sqrt(x^2+y^2); if s>r && s<=R;output(x+o,y+o)=1;end;end;end % set inner area of ring to 1
        case 1 % circle
            r = 1-varargin{1};
            r = floor(a/2*r);
            if 2*r > a;error('Circle diameter exceeds bounding matrix dimensions.');end
            
            for x=-r:r;for y=-r:r;if sqrt(x^2+y^2)<=r;output(x+o,y+o)=1;end;end;end % set inner area of circle to 1
        otherwise
            error('Syntax: circ(matrix dim, circle radius, optional: other donut radius');
    end
    
catch err
    cprintf('_SystemCommands','circ(): ');cprintf('SystemCommands',[err.message,'\n']); %print error message as warng
end
end
