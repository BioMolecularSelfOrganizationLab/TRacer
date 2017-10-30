function [I,BG] = extractTraces(S,L,P,B,m)
% EXTRACTTRACES extracts intensity traces in image stack S at locations L with
% particle mask P and background mask B with method m
% if ~exist('m', 'var') || isempty(m)
%     m = 'sum'; % sum: fastest method - default
% end

L = round(L); % use absolute coordinates
z = floor(size(B,1)/2);
[I{1:size(L,1)}] = deal(zeros(1,size(S,3))); % assign empty array for traces
[BG{1:size(L,1)}] = deal(zeros(1,size(S,3)));

psf = zeros(2*z+1,2*z+1,size(S,3));
bg = zeros(2*z+1,2*z+1,size(S,3));

wb = waitbar(0,'Extracting traces...');

% P
% B

% for each location
for j=1:size(L,1)
    waitbar(j/size(L,1),wb,...
        ['Extracting traces...',char(10),'Trace ',num2str(j),' of ',num2str(size(L,1))]);
    
    try
    tempcrop = S(L(j,1)-z:L(j,1)+z,L(j,2)-z:L(j,2)+z,:); % crop particle for all frames
    
    % for each frame
    for i = 1:size(tempcrop,3)
        psf(:,:,i) = tempcrop(:,:,i) .* P; %calculate psf matrix
        bg(:,:,i) = tempcrop(:,:,i) .* B; %calculate background matrix
        switch m
            case 'Max'
                I{j}(i) = max(max(psf(:,:,i))) / mean(mean(bg(:,:,i)));
            case 'Mean'
                I{j}(i) = mean(mean(psf(:,:,i))) - mean(mean(bg(:,:,i)));
            case 'Sum'
%                 BG{j}(i) = mean(mean(bg(:,:,i)));
%                 I{j}(i) = mean(mean(psf(:,:,i))) - BG{j}(i);
                BG{j}(i) = sum(bg(:,:,i)) / sum(B);
                I{j}(i) = (sum(psf(:,:,i)) / sum(P))-  BG{j}(i);    
            case 'Weighted Mean'
                % weighted max by PSF shape calculated from image autocorrelation
                I{j}(i) = sum(sum(tempcrop(:,:,i) .* P));
            case 'SNR'
                %Mean / Variance
                I{j}(i) = mean(mean(psf(:,:,i))) / var(var(bg(:,:,i)));
        end
        
    end
    catch
        
    end
end

close(wb);

end