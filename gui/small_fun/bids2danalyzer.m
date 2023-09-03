function sleepstagesOUT = bids2danalyzer(sleepstagesIN, values)


stageIdx = ismember(sleepstagesIN.trial_type, values);
sleepstagesIN = sleepstagesIN(stageIdx, :);

sleepstagesOUT.stages = zeros(height(sleepstagesIN), 1);

for i = 1:height(sleepstagesIN)

    if strcmpi(sleepstagesIN.trial_type(i), values{1})
        sleepstagesOUT.stages(i,:) = 0;
    elseif strcmpi(sleepstagesIN.trial_type(i), values{2})
        sleepstagesOUT.stages(i,:) = 1;
    elseif strcmpi(sleepstagesIN.trial_type(i), values{3})
        sleepstagesOUT.stages(i,:) = 2;
    elseif strcmpi(sleepstagesIN.trial_type(i), values{4})
        sleepstagesOUT.stages(i,:) = 3;
    elseif strcmpi(sleepstagesIN.trial_type(i), values{5})
        sleepstagesOUT.stages(i,:) = 4;
    elseif strcmpi(sleepstagesIN.trial_type(i), values{6})
        sleepstagesOUT.stages(i,:) = 5;
    elseif strcmpi(sleepstagesIN.trial_type(i), values{7})
        sleepstagesOUT.stages(i,:) = 6;
    elseif strcmpi(sleepstagesIN.trial_type(i), values{8})
        sleepstagesOUT.stages(i,:) = 7;
    else
        sleepstagesOUT.stages(i,:) = 7;
    end
end

sleepstagesOUT.hdr.srate     = [];
sleepstagesOUT.hdr.win       = [];
sleepstagesOUT.hdr.recStart  = '';
sleepstagesOUT.hdr.lOff      = '';
sleepstagesOUT.hdr.lOn       = '';
sleepstagesOUT.hdr.onsets    = [];
sleepstagesOUT.hdr.stageTime = [];
sleepstagesOUT.hdr.notes     = '';
sleepstagesOUT.hdr.scorer    = '';

