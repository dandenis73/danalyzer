function sleepstagesOUT = yasa2danalyzer(sleepstagesIN)
% Convert a YASA score file to a danalyzer score file.
%%
% Authors:  Dan Denis
% Date:     2021-12-15
%%

sleepstagesOUT.stages = zeros(height(sleepstagesIN), 1);

for i = 1:height(sleepstagesIN)
    
    if strcmpi(sleepstagesIN.Stage(i), 'W')
        sleepstagesOUT.stages(i,:) = 0;
    elseif strcmpi(sleepstagesIN.Stage(i), 'N1')
        sleepstagesOUT.stages(i,:) = 1;
    elseif strcmpi(sleepstagesIN.Stage(i), 'N2')
        sleepstagesOUT.stages(i,:) = 2;
    elseif strcmpi(sleepstagesIN.Stage(i), 'N3')
        sleepstagesOUT.stages(i,:) = 3;
    elseif strcmpi(sleepstagesIN.Stage(i), 'N4')
        sleepstagesOUT.stages(i,:) = 4;
    elseif strcmpi(sleepstagesIN.Stage(i), 'R')
        sleepstagesOUT.stages(i,:) = 5;
    else
        sleepstagesOUT.stages = 7;
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




