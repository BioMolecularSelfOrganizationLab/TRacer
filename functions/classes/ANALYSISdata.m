classdef ANALYSISdata
    %UNTITLED2 gives analysis support
    %   Detailed explanation goes here
    
    properties
        StepFit;    % stepFit data for each trace
        DwellTimes; % dwell times from stepFit
        StepSizes;  % stepSizes from stepFit
        
        % MLE for parameters N(miu,sigma^2) of Step size
        stepSize_miuhat
        stepSize_sigmahat
        
        % MLE for parameters Exp(miu) of Dwell time
        dwellTime_miuhat
        
        %Rules;
        
    end
    
    methods
        function A = ANALYSISdata()
            
            A.DwellTimes = {};
            A.StepSizes = [];
        end
        
        function A = addToDwellTimes(A,i,array)
            if size(A.DwellTimes,2) < i
                A.DwellTimes{i} = [];
            end
            A.DwellTimes{i} = [A.DwellTimes{i},array];  
        end
        
        function A = addToStepSizes(A,array)
            A.StepSizes = [A.StepSizes,array];
        end
    end
    
    
end

