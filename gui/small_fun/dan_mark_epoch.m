function handles = dan_mark_epoch(handles)
% Label an epoch as bad
%%
% Authors:  Dan Denis
% Date:     2021-07-14
%%

epochIdx = str2double(get(handles.current_epoch_number, 'String'));

if handles.psg.ar.badepochs(epochIdx) == 0
    handles.psg.ar.badepochs(epochIdx) = 1;
elseif handles.psg.ar.badepochs(epochIdx) == 1
    handles.psg.ar.badepochs(epochIdx) = 0;
end
