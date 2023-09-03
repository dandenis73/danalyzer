function sleepstagesOUT = vmrk2danalyzer(sleepstagesIN, values)
% Convert a vmrk score file to a danalyzer score file.
%%
% Authors:  Dan Denis
% Date:     2022-07-27
%%

sleepstagesOUT.stages = zeros(size(sleepstagesIN, 1), 1);

for i = 1:size(sleepstagesIN, 1)

    if contains(sleepstagesIN{i, 1}, values{1})
        sleepstagesOUT.stages(i, 1) = 0;
    elseif contains(sleepstagesIN{i, 1}, values{2})
        sleepstagesOUT.stages(i, 1) = 1;
    elseif contains(sleepstagesIN{i, 1}, values{3})
        sleepstagesOUT.stages(i, 1) = 2;
    elseif contains(sleepstagesIN{i, 1}, values{4})
        sleepstagesOUT.stages(i, 1) = 3;
    elseif contains(sleepstagesIN{i, 1}, values{5})
        sleepstagesOUT.stages(i, 1) = 4;
    elseif contains(sleepstagesIN{i, 1}, values{6})
        sleepstagesOUT.stages(i, 1) = 5;
    elseif contains(sleepstagesIN{i, 1}, values{7})
        sleepstagesOUT.stages(i, 1) = 6;
    elseif contains(sleepstagesIN{i, 1}, values{8})
        sleepstagesOUT.stages(i, 1) = 7;
    else
        sleepstagesOUT.stages(i, 1) = 7;
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




