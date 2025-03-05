function sleepstagesOUT = dreem2danalyzer(sleepstagesIN)
% Convert a DREEM score file to a danalyzer score file.
%%
% Authors:  Dan Denis
% Date:     2024-12-09
%%

sleepstagesOUT.stages = zeros(height(sleepstagesIN), 1);

for i = 1:height(sleepstagesIN)
    
    if strcmpi(sleepstagesIN.SleepStage(i), 'SLEEP-S0')
        sleepstagesOUT.stages(i,:) = 0;
    elseif strcmpi(sleepstagesIN.SleepStage(i), 'SLEEP-S1')
        sleepstagesOUT.stages(i,:) = 1;
    elseif strcmpi(sleepstagesIN.SleepStage(i), 'SLEEP-S2')
        sleepstagesOUT.stages(i,:) = 2;
    elseif strcmpi(sleepstagesIN.SleepStage(i), 'SLEEP-S3')
        sleepstagesOUT.stages(i,:) = 3;
    elseif strcmpi(sleepstagesIN.SleepStage(i), 'SLEEP-S4')
        sleepstagesOUT.stages(i,:) = 4;
    elseif strcmpi(sleepstagesIN.SleepStage(i), 'SLEEP-REM')
        sleepstagesOUT.stages(i,:) = 5;
    elseif strcmpi(sleepstagesIN.SleepStage(i), 'SLEEP-MT')
        sleepstagesOUT.stages(i,:) = 6;
    else
        sleepstagesOUT.stages = 7;
    end
    
end

sleepstagesOUT.hdr.srate     = [];
sleepstagesOUT.hdr.win       = sleepstagesIN{1, 4};
sleepstagesOUT.hdr.recStart  = datestr(sleepstagesIN{1, 2}, 'HH:MM:ss.FFF');
sleepstagesOUT.hdr.lOff      = datestr(sleepstagesIN{1, 2}, 'HH:MM:ss.FFF');
sleepstagesOUT.hdr.lOn       = datestr(sleepstagesIN{end, 2}, 'HH:MM:ss.FFF');
sleepstagesOUT.hdr.onsets    = [];
sleepstagesOUT.hdr.stageTime = [];
sleepstagesOUT.hdr.notes     = '';
sleepstagesOUT.hdr.scorer    = '';

