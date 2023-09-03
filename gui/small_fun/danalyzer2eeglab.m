function EEG = danalyzer2eeglab(psg)
% Convert a danalyzer psg struct to EEGLAB
%%
% Authors:  Dan Denis
% Date:     2021-07-14
%%

EEG = eeg_emptyset();

EEG.data = psg.data;
EEG.pnts = psg.hdr.samples;
EEG.srate = psg.hdr.srate;
EEG.chanlocs = psg.chans;
EEG.nbchan = length(EEG.chanlocs);
EEG.trials = 1;

EEG = eeg_checkset(EEG);