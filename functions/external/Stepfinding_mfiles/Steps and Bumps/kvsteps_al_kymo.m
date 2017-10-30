% Implements the Kalafut-Visscher step detection method, using the MEX
% wrapper of the C version.
%
% Usage:
% [y, steps] = kvsteps(x,PF)
%
% Inputs
%    x      - Input signal
%   PF      - Penalty Factor
% Outputs
%    y      - Estimated piecewise constant approximation to the input signal
%    steps  - Vector of estimated step-change points in x
%
% (c) Max Little, 2010. Based on the algorithm described in:
% Kalafut, Visscher, "An objective, model-independent method for detection
% of non-uniform steps in noisy signals", Comp. Phys. Comm., 179(2008),
% 716-723.
% If you use this code for your research, please cite:
% "Steps and bumps: precision extraction of discrete states of molecular
% machines using physically-based, high-throughput time series analysis"
% Max A. Little et al., 2010, arXiv:1004.1234v1 [q-bio.QM]

function [y, steps, slope, intercept] = kvsteps_al_kymo(x,PF)

error(nargchk(2,2,nargin));
% PF = 5;
x = x(:);
N = length(x);

% Call MEX implementation of KV-algorithm for speed
steps = kvsteps_alvaro(x,PF);
steps(steps == 0) = [];
steps = [1; steps];

% Construct piecewise constant approximation
y = zeros(N,1);
S = length(steps);
for i = 1:(S-1)
    is = steps(i)+1;
    ie = steps(i+1);
    subi = is:ie;
    p = polyfit(subi',x(subi),1);
    slope(i) = p(1);
    intercept(i) = p(2);
    y(subi) = p(1).*subi + p(2);
end
y(1) = y(2);
