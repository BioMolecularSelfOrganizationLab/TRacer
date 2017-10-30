

function out = imgedit(I,F)

if numel(F) < 3
    out = {'err','[imgedit] Not enough parameters to proceed.'};
end

% frame operations here:
% rotation:
if F{1} ~= 0
    I = rot90(I,floor(F{1}/90));
end

% flip frame

switch F{2}
    case 'v'
        I = flipud(I);
    case 'h'
        I = fliplr(I);
    case 'n'
        
    otherwise
        out = {'err','[imgedit] Syntax error in flip parameter. File skipped.'};
        return;
end

% frame cropping
switch F{3}
    case 'l'
        I = I(:,1:floor(size(I,2)/2),:); %crop left half
    case 'r'
        I = I(:,floor(size(I,2)/2)+1:end,:); %crop right half
    case 'f'
        % no change, full frame
    otherwise
        out = {'err','[imgedit] Syntax error in split parameter. File skipped.'};
        return;
end


out{1} = I;

end