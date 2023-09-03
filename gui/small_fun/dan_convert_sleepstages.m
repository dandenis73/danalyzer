function sleepstagesOUT = dan_import_sleepstages(sleepstagesIN, values)
% Generic sleep stage conversion file. Input is a list of sleep stages (one
% row = one epoch), and a list of values that correspond to Wake, N1, N2,
% N3, N4, REM, Movement, Unstaged
%%
% Authors:  Dan Denis
% Date:     2021-07-14

%%

if isa(sleepstagesIN, 'table')
    
    sleepstagesOUT.stages = zeros(height(sleepstagesIN), 1);
    
    if isa(sleepstagesIN.Var1(1), 'double')
        
        for i = 1:height(sleepstagesIN)
            
            if strcmpi(sleepstagesIN.Var1(i), str2double(values{1}))
                sleepstagesOUT.stages(i,:) = 0;
            elseif strcmpi(sleepstagesIN.Var1(i), str2double(values{2}))
                sleepstagesOUT.stages(i,:) = 1;
            elseif strcmpi(sleepstagesIN.Var1(i), str2double(values{3}))
                sleepstagesOUT.stages(i,:) = 2;
            elseif strcmpi(sleepstagesIN.Var1(i), str2double(values{4}))
                sleepstagesOUT.stages(i,:) = 3;
            elseif strcmpi(sleepstagesIN.Var1(i), str2double(values{5}))
                sleepstagesOUT.stages(i,:) = 4;
            elseif strcmpi(sleepstagesIN.Var1(i), str2double(values{6}))
                sleepstagesOUT.stages(i,:) = 5;
            elseif strcmpi(sleepstagesIN.Var1(i), str2double(values{7}))
                sleepstagesOUT.stages(i,:) = 6;
            elseif strcmpi(sleepstagesIN.Var1(i), str2double(values{8}))
                sleepstagesOUT.stages(i,:) = 7;
            else
                sleepstagesOUT.stages(i,:) = 7;
            end
            
        end
        
    else
        
        for i = 1:height(sleepstagesIN)
            
            if strcmpi(sleepstagesIN.Var1(i), values{1})
                sleepstagesOUT.stages(i,:) = 0;
            elseif strcmpi(sleepstagesIN.Var1(i), values{2})
                sleepstagesOUT.stages(i,:) = 1;
            elseif strcmpi(sleepstagesIN.Var1(i), values{3})
                sleepstagesOUT.stages(i,:) = 2;
            elseif strcmpi(sleepstagesIN.Var1(i), values{4})
                sleepstagesOUT.stages(i,:) = 3;
            elseif strcmpi(sleepstagesIN.Var1(i), values{5})
                sleepstagesOUT.stages(i,:) = 4;
            elseif strcmpi(sleepstagesIN.Var1(i), values{6})
                sleepstagesOUT.stages(i,:) = 5;
            elseif strcmpi(sleepstagesIN.Var1(i), values{7})
                sleepstagesOUT.stages(i,:) = 6;
            elseif strcmpi(sleepstagesIN.Var1(i), values{8})
                sleepstagesOUT.stages(i,:) = 7;
            else
                sleepstagesOUT.stages(i,:) = 7;
            end
        end
        
    end
    
else
    sleepstagesOUT.stages = zeros(length(sleepstagesIN), 1);
    
    if isa(sleepstagesIN, 'double')
        
        for i = 1:length(sleepstagesIN)
            
            if sleepstagesIN(i) == values{1}
                sleepstagesOUT.stages(i,:) = 0;
            elseif sleepstagesIN(i) == values{2}
                sleepstagesOUT.stages(i,:) = 1;
            elseif sleepstagesIN(i) == values{3}
                sleepstagesOUT.stages(i,:) = 2;
            elseif sleepstagesIN(i) == values{4}
                sleepstagesOUT.stages(i,:) = 3;
            elseif sleepstagesIN(i) == values{5}
                sleepstagesOUT.stages(i,:) = 4;
            elseif sleepstagesIN(i) == values{6}
                sleepstagesOUT.stages(i,:) = 5;
            elseif sleepstagesIN(i) == values{7}
                sleepstagesOUT.stages(i,:) = 6;
            elseif sleepstagesIN(i) == values{8}
                sleepstagesOUT.stages(i,:) = 7;
            else
                sleepstagesOUT.stages(i,:) = 7;
            end
        end
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


