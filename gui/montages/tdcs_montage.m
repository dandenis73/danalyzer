%% sleepDanalyzer montage. 

% Montage scripts provide a conveinient way to control how the data looks
% when sleep scoring. 

% chanList. A list of channel names and (optionally) channel coordinates.
% This should be an EEGLAB chanlocs struct. Alternatively you can read in a
% .txt file using the readlocs function (EEGLAB). If you wish to
% differentiate channel types (e.g. EEG, EOG, etc.) make sure to use the
% .type field of the chanlocs struct. If chanList = [], sleepDanalyzer will
% use the chanlocs struct that is created during import/load

% See the 'psg_low_density.txt' file to see an example of how the channel
% locatiions file should be arranged.
montage.chanList = readlocs('tdcs_low_density.txt', 'filetype', 'custom', 'format',...
    {'labels' 'X' 'Y' 'Z' 'type'});

% hideChans. List names of channels you wish to hide from view e.g. {'Fz'
% 'Cz} will hide channels 'Fz' and 'Cz' from view. If hideChans = [], no
% channels will be hidden from view
% montage.hideChans = [] % option 1
 montage.hideChans = {'Patient' 'Af4-M1' 'TRIG'}; % option 2 

% showChans. The opposite of hideChans. Use this field to control the order
% that the channels appear on the screen. if you wish to display the
% channels in a different order to how they are stored in the data,
% specify the order here e.g. {'LOC' 'ROC' 'F3' 'F4'} would display
% channels in that order i.e. the top channel would be 'LOC'. If you hide
% any channels, DO NOT put them in the showChans list. If showChans = [],
% channels will be displayed in the order they appear in the data.
% montage.showChans = []; % option 1
 montage.showChans = {'E1-M2' 'E2-M1' 'Af3-M2' 'C3-M2' 'C4-M1' 'O1-M1' 'O2-M2' 'EMG'}; % option 2

% colors. Control the colors of EEG, EOG, EMG, ECG, and Other channels. Use
% a 5x3 array where each row corresponds to a channel type (EEG, EOG, EMG,
% ECG, Other) and each column is a MATLAB rgb triplet specifying the color.
% Note this only works if channel types are specified in the chanList.
montage.colors = [0 0 0; 0 0 1; 1 0 0; 0 1 0; 1 1 0];

% scaleLine. Name of the channel in which to draw scale lines around
montage.scaleLine = {'Af3-M2'};

% scaleLinePos. Array containing where to plot scale lines at e.g. [-150;
% 0; 150] would draw scale lines at -150uV, 0uV, and 150uV around the
% selected channel
montage.scaleLinePos = [-37.5; 0; 37.5];

% scaleLineColor. The color of the scale lines, specified using MATLAB rgb
% triplets
montage.scaleLineColor = [1 0 1];

% scaleLinType. The linetype for the scale lines, specified using MATLAB
% convention e.g. '--'
montage.scaleLineType = '--';
