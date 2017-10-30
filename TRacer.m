%% TRacer 
%
% TIRF Image Analysis Software Suite
%


%%

function TRacer()
%%  Prepare GUI and Functions
profile on;
cd(fileparts(mfilename('fullpath')));   % Change working folder to TRacer location
addpath(genpath('./functions'));        % Add subfolders to paths


global T; % just for debugging purposes
T = TRACERdata; % create empty TRACERdata class


clc;
logo('2016/8');
    
end

function logo(ver)
disp(char(10));
disp([' _________ ..................',char(10162)]);
disp('/_  __/ _ \___ ________ ____');
disp(' / / / , _/ _ `/ __/ -_) __/');
disp('/_/ /_/|_|\_,_/\__/\__/_/   ');
disp('Single Molecule Image Analysis');
fprintf('\n');
disp([char(169),' B.Salem | AK Lamb | LMU Munich',char(10),'   v',ver]);  
disp(repmat(char(183),1,40));
fprintf('\n\n');

end

