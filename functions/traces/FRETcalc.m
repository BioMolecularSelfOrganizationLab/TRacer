%% FRETcalc() function
%   Calculates FRET efficiency from intensity traces
%
% FRET: E(FRET) = I(acc) / (I(don) + gamma * I(acc))
%
%% INPUT arguments
% *_Dtrace:_ Donor trace to calc. FRET
% *_Atrace:_ Acceptor trace to calc. FRET
% *_gm:_ Gamma value
%
function [Ftrace] = FRETcalc(Dtrace, Atrace, gm)
global prefs res;
% calc E(FRET) for every given traces
Ftrace = Atrace ./ (Dtrace + gm * Atrace);
end
