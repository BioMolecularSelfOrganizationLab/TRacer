function [O] = genPSF(I,s)
% generates fourier space image of I to determine PSF shape and size
% output will be cropped to a 2*s+1^2 matrix, if s is defined
if ndims(I) == 3
    z = 1:size(I,3);
else
    z = 1;
end
if isempty(I)
   disp('genPSF: Input image can''t be empty'); 
   return;
end

O(:,:,z) = ((fftshift(real(ifft2(fft2(double(I(:,:,z))).*conj(fft2(double(I(:,:,z))))))))/(mean2(I(:,:,z))*mean2(I(:,:,z))*size(I,1)*size(I,2))) - 1;

if nargin > 1
    % find center:
    c = floor(size(I)/2)+1;
    % crop:
    O = O(c(1)-s:c(1)+s,c(2)-s:c(2)+s,:);
end

end