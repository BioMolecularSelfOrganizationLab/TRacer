function T = genMask(T)
switch T.MaskType
    
    case 1
        
        T.MaskPSF = circ(T.MaskOuterSize * 2 + 1,T.MaskPSFParticleThreshold);
        T.MaskBG = circ(T.MaskOuterSize * 2 + 1,T.MaskPSFUpperBackgroundThreshold,T.MaskPSFLowerBackgroundThreshold);
    case 2
        T = MaskfromPSF(T); % extract psf by autocorr
end

end

