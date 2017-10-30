function T = MaskfromPSF(T)


% gen PSF, tP threshold val for PSF; tI threshold for upper BG intensity, tO threshold for lower BG intensity
P = genPSF(T.Channel{T.MappingReferenceChannel}.Cumulated,T.MaskOuterSize);

%overlay alpha
T.MaskPSF = zeros(size(P));
T.MaskBG = zeros(size(P));

T.MaskPSF(P(:) > T.MaskPSFParticleThreshold * max(P(:))) = 1;
T.MaskBG(P(:) <= T.MaskPSFUpperBackgroundThreshold * max(P(:)) & P(:) > T.MaskPSFLowerBackgroundThreshold * max(P(:))) = 1;

% normalize to [0-1] interval and store
T.MaskAuto = (P - min(P(:)))/(max(P(:))-min(P(:)));

end