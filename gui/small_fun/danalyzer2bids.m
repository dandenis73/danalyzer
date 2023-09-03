function stageOUT = danalyzer2bids(stageIN)

% Convert a danalyzer sleep scores file to a format compatible for BIDS

onset  = stageIN.hdr.stageTime;
if isempty(onset)
    onset = 0:stageIN.hdr.win:stageIN.hdr.win*length(stageIN.stages)-1;
end
onset = onset';

duration = repmat(stageIN.hdr.win, length(onset), 1);
sample = stageIN.hdr.onsets;

if isempty(sample)
    sample = 1:stageIN.hdr.win*stageIN.hdr.srate:(stageIN.hdr.win*stageIN.hdr.srate)*length(stageIN.stages)-1;
    sample = sample';
end

if size(onset, 2) > size(onset, 1)
    onset = onset';
end

if size(sample, 2) > size(sample, 1)
    sample = sample';
end

if size(duration, 2) > size(duration, 1)
    duration = duration';
end

trial_type = cell(length(onset), 1);

for i = 1:length(stageIN.stages)

    if stageIN.stages(i) == 0
        trial_type{i} = 'W';
    elseif stageIN.stages(i) == 1
        trial_type{i} = 'N1';
    elseif stageIN.stages(i) == 2
        trial_type{i} = 'N2';
    elseif stageIN.stages(i) == 3
        trial_type{i} = 'N3';
    elseif stageIN.stages(i) == 4
        trial_type{i} = 'N4';
    elseif stageIN.stages(i) == 5
        trial_type{i} = 'R';
    elseif stageIN.stages(i) == 6
        trial_type{i} = 'MVT';
    elseif stageIN.stages(i) == 7
        trial_type{i} = '?';
    end
end

stageOUT = [array2table([onset duration sample]) cell2table(trial_type)];
stageOUT.Properties.VariableNames = {'onset' 'duration' 'sample' 'trial_type'};