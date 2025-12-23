function ftData = danalyzer2fieldtrip(psg)
% Convert a danalyzer psg struct to a FieldTrip 'raw' structure.
% Currently does not support conversion of electrode
%%
% Authors:  Dan Denis
% Date:     2023-12-12
%%

% Electrode positions
if ~isempty(psg.chans)
    ftData.elec.elecpos = zeros(length( psg.chans ), 3);
    for ind = 1:length( psg.chans )
        ftData.elec.label{ind} = psg.chans(ind).labels;
        if isfield(psg.chans, 'X')
            if ~isempty(psg.chans(ind).X)
                ftData.elec.elecpos(ind,1) = psg.chans(ind).X;
                ftData.elec.elecpos(ind,2) = psg.chans(ind).Y;
                ftData.elec.elecpos(ind,3) = psg.chans(ind).Z;
            else
                ftData.elec.elecpos(ind,:) = [0 0 0];
            end
        else
            ftData.elec.elecpos(ind,:) = [0 0 0];
        end

    end
    ftData.elec.pnt = ftData.elec.elecpos;
end

% Sample rate
ftData.fsample = psg.hdr.srate;

% Data
ftData.trial{1, 1} = psg.data;

% Time
ftData.time{1, 1}  = linspace(0, (psg.hdr.samples-1)/psg.hdr.srate, psg.hdr.samples);

% Channel label
ftData.label = {psg.chans.labels}';



