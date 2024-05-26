function danalyzer_startup(danalyzer_path)
% Adds danalyzer to the MATLAB path

addpath(fullfile(danalyzer_path, 'gui'))
addpath(fullfile(danalyzer_path, 'gui', 'gui'))
addpath(fullfile(danalyzer_path, 'gui', 'montages'))
addpath(fullfile(danalyzer_path, 'gui', 'small_fun'))
addpath(fullfile(danalyzer_path, 'tools'))
addpath(fullfile(danalyzer_path, 'tools', 'helpers'))


