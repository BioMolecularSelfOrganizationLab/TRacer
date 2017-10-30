function out = writeTIF(fname, I)
% writes TIF stacks from 2-3dim image array I to filename fname
% opts: {Compression}{BitsPerSample}

if nargin < 2
    out = '[writeTIF] Syntax error.';
    return;
end
tic;
t = Tiff(fname, 'w');
tagstruct.ImageLength = size(I,1);
tagstruct.ImageWidth = size(I,2);
tagstruct.Compression = 1; %1==None; 5==LZW
tagstruct.SampleFormat = 1; %UInt
tagstruct.Photometric = Tiff.Photometric.MinIsBlack;
tagstruct.BitsPerSample =  16;                        %32= float data, 16= Andor standard sampling
tagstruct.SamplesPerPixel = 1;
tagstruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;
%
for K=1:size(I,3)
    if K>1
        t.writeDirectory();
    end
    %  imwrite(img(:, :, K),fname,'WriteMode', modus, 'Compression', 'none');
    t.setTag(tagstruct);
    t.write(I(:, :, K));
end
t.close();
out = [fname,' written in ',num2str(toc),'s.'];
end