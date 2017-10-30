function [R] = findBleachstep(T,m,varargin)
%% find and return index of bleach steps using different methods
% T: input trace data
% m: method to use: 'variance', 'salapaka' or 'l1'
% R: vector with output bleachstep indices


switch m
    case 'variance' % minimize variances of 2 parts divided by moving split
        R = bleach_step_find_mex(T);    % apply MEX created by A.Barth 2015, finds one step only!
    case 'salapaka' % apply Salapaka stepfinding, code courtesy of M.Hoyer, 2015
        R = stepfit1_alvaro(T);
    case 'L1'
        if length(varargin) ~= 2
            error('[findBleachstep] Incorrect arguments for Salapaka method.');
        end
        PF = varargin{1};
        l = varargin{2};
        [x, ~, ~, ~] = l1pwc(T, l, 0); % simulations
        [R, ~] = kvsteps_al(x,PF);
    case 'HMM' % use hidden markov modeling to find steps
        
    otherwise
end
   
end