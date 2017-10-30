%% *FFT_noise function*
%
% * filters out noise by cancelling low frequency signals in fourier space
%
%% INPUT Arguments
%
% * _img_:      image to filter
% * _lims_:     [lower,upper] array with lower and upper bounds of frequencies to delete
%
%% OUTPUT Arguments
%
% * _output_:   filtered image
%

function output = FFT_noise(img, lims)
img_FFT = fft2(img);				% create fft of image
img_FFT(lims) = 0;              	% remove low freq signal (i.e. noise) up to limit x
img_rFFT = ifft2(img_FFT);			% perform inverse FFT on image
img_rFFT(img_rFFT<0) = 0;			% set elements below 0 to 0
output = real(img_rFFT);			% collapse to real data matrix
end
noiseIMG();