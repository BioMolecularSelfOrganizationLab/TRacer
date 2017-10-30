%% traceEx function
% Extracts an intensity trace from an image stack
%% INPUT arguments
% * _G_ TRACEdata class object


function G = traceEx(G, method)
% try
if ~exist('method', 'var') || isempty(method)
    method = 'sum'; % sum: fastest method - default
end
if length(G.ParticlesMapped) <= 1; return; end
AU = numel(unique(C.ALEXorder)); % unique ALEX excitations
for n=1:numel(AU)
    % extract traces for each ALEX channel
    clear G.Traces{n}.TracesCorrected G.Traces{n}.TracesBackground % clear old traces
    [G.Traces{n}{1:length(G.ParticlesMapped)}] = deal(zeros(1,size(G.RawData,3))); % assign empty array for traces
    
    z = (G.Parent.MaskOuterSize-1)/2;
    
    for j = 1:length(G.ParticlesMapped)
        try
            p = round(G.ParticlesMapped);
            tempcrop = G.RawData(p(j,2)-z:p(j,2)+z,p(j,1)-z:p(j,1)+z,G.ALEXsequence==AU(n));
            
            [B,I] = deal(zeros(size(G.RawData,3),1));
            psf = zeros(size(tempcrop));
            bg = zeros(size(tempcrop));
            for i = 1:size(tempcrop,3)
                psf(:,:,i) = tempcrop(:,:,i) .* G.MaskPSF; %calculate psf matrix
                bg(:,:,i) = tempcrop(:,:,i) .* G.MaskBG; %calculate background matrix
                switch method
                    case 'max'
                        I(i) = max(max(psf(:,:,i))) - max(max(bg(:,:,i)));
                    case 'mean'
                        I(i) = mean(mean(psf(:,:,i))) - mean(mean(bg(:,:,i)));
                    case 'sum'
                        B(i) = mean(mean(bg(:,:,i)));
                        I(i) = mean(mean(psf(:,:,i))) - B(i);
                    case 'weighted'
                        % weighted max by PSF shape calculated from image autocorrelation
                        I(i) = sum(sum(tempcrop(:,:,i) .* G.PSF));
                    case 'SNR'
                        %Mean / Variance
                        I(i) = mean(mean(psf(:,:,i))) / var(var(bg(:,:,i)));
                end
                
            end
            
            % export data to structs
            G.Traces{n}.TracesCorrected{j} = I;
            G.Traces{n}.TracesBackground{j} = B;
        catch
        end
    end
end

end