function [NumSteps, realStep] = getNumSteps( steps )

% This program converts the steps found using a step finding algorithm
% into a stepcase trace (i.e. monomer number vs. time trace).
% Rafael Correia, Aug 6th 2017
%
% Input: "steps" is the result of the step finding algorithm applied to the
% noisy data.
% Output:   "NumSteps" is the step fit for the Monomer numbers (0,1,2,...)
%           "realStep" is the step value assumed by the algorithm


    % auxiliar function
    % constructs the Number Monomer Fit Function
    function out = fun(x,xdata)

        size_data = length(xdata);
        step_size = x;           % step size
        %offset = x(2);              % "zero" offset due to background noise
        
        stepDiff = diff(steps);
        
        step_events = [1, find(stepDiff)+1, size_data+1];

        out = ones(1,size_data);
        
        % for each step pleateau
        for i = 1:(length(step_events)-1)
            v = 0;
            % search bin
            for j = 0:((unique((max(steps)))/step_size)+2)
                step_v = steps(step_events(i));
%                 low = (j - .5) * step_size + offset;
%                 high = (j + .5) * step_size + offset;
                low = (j - .5) * step_size;
                high = (j + .5) * step_size;
                if (step_v > low && step_v < high)
                    v = (low + high)/2;
                    break;
                end
            end
            
            % set value
            out(step_events(i):(step_events(i+1)-1)) = v;
        end
    end

    % fit
    xdata = 1:length(steps);
    step_diff = diff(steps);
    step_sizes = abs(step_diff(find(step_diff)));
    min_step = min(step_sizes);
    if isempty(min_step)
        min_step = 0;
    end
    
%     max_step = max(step_sizes);
    
    % get mode(step_size)
    [stp_size_N,stp_size_edges] = histcounts(step_sizes,10);
    idx_max = find(stp_size_N == max(stp_size_N));
    stp_size_mode = (stp_size_edges(idx_max(1)) + stp_size_edges(idx_max(1)+1))/2;
    
    
%    xi = [stp_size_mode,stp_size_mode/2];
%     
%     % use limits for parameters
%     aux = @(x,xdata)fun(x,xdata);
%     
%     %xf = lsqcurvefit(aux,xi,xdata,steps,[min_step,0],[max_step,0]);
%     ms = MultiStart;
    
   %options = optimoptions('lsqcurvefit','StepTolerance',1,'DiffMinChange',0.5);
    
%     u_thr = 0 * (max(step_sizes) - stp_size_mode)/stp_size_mode;
%     l_thr = 0.5 * (stp_size_mode - min(step_sizes))/stp_size_mode;
%     
%     lb = [1-l_thr, 0] * stp_size_mode;
%     ub = [1+u_thr, 0] * stp_size_mode;
%     % safety check
%     lb = min(lb,ub);
    
%     lb = [min_step, 0];
%     ub = [min_step, 0];
    
%     problem = createOptimProblem('lsqcurvefit','ydata',steps,...
%         'xdata',xdata,'x0',xi,'lb',lb,'ub',ub,...
%         'objective',aux);
%     [xf,~] = run(ms,problem,20);
%     
%     fprintf('Step size: %d \n',xf(1));
    
%     disp(sprintf('Step: %i',xf(1)));
%     disp(sprintf('Offset: %i',xf(2)));

    %ans = round(fun(xf,xdata));
    
    % CHANGE REAL STEP HERE!
    realStep = stp_size_mode - 0.5 * (stp_size_mode - min_step)

    ans = fun(realStep, xdata);
    
    % scale down
    step_diff = diff(ans);
    step_sizes = abs(step_diff(find(step_diff)));
    min_step = min(step_sizes);
%     if isempty(min_step)
%         min_step = 1;
%     end
    ans = (ans - min(ans))/min_step;
    
    % add one frame steps in all step jumps bigger than 1
    step_diff = abs(diff(ans));
    indexes = find(step_diff >= 2);
    
    for i=indexes
        jump = step_diff(i);
        half_b = floor(jump/2);
        half_t = ceil(jump/2);
        ans(i-half_b:i+half_t) = round(linspace(ans(i),ans(i+1),half_b + half_t + 1));
        
    end
    realStep = min_step;
    NumSteps = ans;
    
end

