function [ output ] = simTEST()
%SIMTEST Summary of this function goes here
%   Detailed explanation goes here
%nimg = zeros(20,20);
acc = zeros(1,2);

    if isempty(gcp('nocreate'))
        parpool(feature('NumCores'));
    end
    
    for i=1:1000
    disp(['Running ',num2str(i),' of ',num2str(1000)]);
    [nimg, rY, rX] = noiseIMG([50,50],1,3,'gaussian','poisson',6);
    [cY, cX] = radialcenter(nimg);
    % test accuracy:
    dY = abs((rY-cY));
    dX = abs(rX-cX);
    acc(i) = sqrt(dY^2+dX^2);
    
    
end
output = mean(acc(:));
end

