%% noiseIMG() function
%   Creates simulated noisy image
%
%
%% INPUT options:
% * _simg:_ Image dimensions (Y,X)
% * _nump:_ Number of simulated particles
% * _sPSF:_ Radius of PSF in pixels
% * _ftype:_ Type of filter for blur, options are: ['none', 'gaussian', 'bessel', 'poisson', 'laplacian', 'disk']
% * _ntype:_ Type of noise, options are: ['none', 'gaussian', 'poisson', 'laplacian', 'disk']
% * _sr:_ Desired final signal to noise ratio (sig vs background
%
%% OUTPUT arguments:
% * _nimg:_ Noisy particle image simulation
% * _y:_    y-coordinates of particle seeds, mainly for debugging
% * _x:_    x-coordinates of particle seeds, mainly for debugging
%


function [nimg, y ,x ] = noiseIMG(simg, nump, sPSF, ftype, ntype, sr)

% set default arguments:
if isempty(ftype)
    ftype = 'gaussian';
end

if strcmp(ftype, 'bessel')
    % create PSF with 1st order bessel function with Airy disk diffraction pattern
    % see http://en.wikipedia.org/wiki/Airy_disk
    %
    
    NA = 1.2;       % numerical aperture of objective
    nw = 1.33;      % refractive index of second medium, 1.33 for water
    np = 100;
    scale = sPSF/1000;	% nm/pixel of high res psf
    lambda = 532;   % excitation wavelendth used in nm
    c = repmat(-np:np,2*np+1,1);  % Array of column numbers, relative to center
    r = repmat((-np:np)',1,2*np+1);  % Array of row numbers, relative to center
    d = sqrt(r.*r + c.*c);  % matrix of distances from the center, in pixels
    k = 2*pi/lambda;   % calculate wavenumber for high res psf
    rpos = d/(np*2+1);      % matrix of distances, microns * grid size -> nm per pixel; creates a 3D conical shape
    nu = k *(NA/nw)*rpos *scale;    % scaling according to instrument properties
    besv = besselj(1,nu); % calculate 1st order bessel function
    psf = 1-4*besv.*conj(besv);
    psf = psf / max(psf(:));% normalize
    psf(np+1,np+1) = 1;   % correct central value
    
    surf(psf);
    % downscale to CCD resolution:
    psfccd = imresize(psf, sPSF / length(psf));
    
    % allocate mem and add psf add random pixels
    nimg = zeros([floor((simg+sPSF*2)), 1]);
    for i=1:nump
        randXY = floor(rand(size(simg)) .* (simg - 1)) + 1;
        nimg(randXY(1)-round(sPSF/2):randXY(1)+round(sPSF/2),randXY(2)-round(sPSF/2):randXY(2)+round(sPSF/2)) = ...
            nimg(randXY(1)-round(sPSF/2):randXY(1)+round(sPSF/2),randXY(2)-round(sPSF/2):randXY(2)+round(sPSF/2)) + psfccd;
        %[y,x] = deal(randXY(1,2),randXY(1,1));
    end
    
    
end

if isempty(sPSF)
    sPSF = 5;
end



% if Input is another image...
if max(size(simg)) > 3
    nimg = simg;
    simg = size(simg);
    bimg = double(zeros(simg));
else
    nimg = double(zeros(simg)); % allocate memory for images
    bimg = nimg;
    
    % calculate and add randomized pixels
    for i=1:nump
        randXY = floor(rand(size(simg)) .* (simg - 1)) + 1;
        nimg(randXY(1),randXY(2)) = 1;
        [y,x] = deal(randXY(1,2),randXY(1,1));
    end
    
    % perform gaussian convolution (gaussian blur)
    switch ftype
        
        case 'none'
        case 'bessel'
        otherwise
            IF = fspecial(ftype,[6,6]*sPSF,sPSF); % create filter with size = 6*PSF
            nimg = imfilter(nimg,IF,'same'); % create and apply filter
            
            % normalize max to 1
            nimg = nimg ./ max(nimg(:));
            
    end
    
end






% add noise
switch ntype
    case 'poisson'
        nimg = imnoise(nimg * 1E-11, ntype);
        % normalize again to 1
        nimg = nimg ./ max(nimg(:));
    case 'none'
        
    otherwise
        nimg = imnoise(nimg, ntype);
end

% add background noise floor

if ~isempty(sr)
    bimg = imnoise(ones(simg), 'gaussian',0.2,1);
    nimg = nimg + bimg / sr;
    nimg = nimg ./ max(nimg(:)); %normalize
end

% show result -> for debugging;
%imtool(nimg,[0,1]);
end