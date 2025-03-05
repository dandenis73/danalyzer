function handlesOut = dan_import_data(handlesIn)
% Take input strings and load data into file

%%
% Authors:  Dan Denis
% Date:     2021-07-14

%%

dataString   = get(handlesIn.data_file_string, 'String');
stageString  = get(handlesIn.stage_file_string, 'String');
eventsString = get(handlesIn.events_file_string, 'String');
arString     = get(handlesIn.ar_file_string, 'String');

%% Import data

if ~isempty(dataString)
    
    [dataPath,dataName,dataExt] = fileparts(dataString);
    disp(['Attempting to load data in ' strtok(dataExt, '.') ' format...'])
    
    % Load data from various formats
    if strcmpi(dataExt, '.edf')
        psg = pop_biosig(dataString, 'importevent', 'off', 'importannot', 'off');
    elseif strcmpi(dataExt, '.set')
        psg = pop_loadset(dataString);
    elseif strcmpi(dataExt, '.vhdr')
        psg = pop_loadbv(dataPath, [dataName dataExt], [], []);
    elseif strcmpi(dataExt, '.mat')
        psg = load(dataString);   
    end
        
    % Convert the data to a danalyzer matlab struct
    
    if ~strcmpi(dataExt, '.mat')
        eegevent = psg.event;
        psg = eeglab2danalyzer(psg);
        psg.hdr.name = dataName;
        psg.hdr.original = dataString;
    else
        structFields = fieldnames(psg);
        psg = psg.(structFields{1});
        eegevent = [];

        % Try to guess if this is FieldTrip
        if isfield(psg, 'trial') && isfield(psg, 'label')
            disp('I think this is FieldTrip data...')
            psg = fieldtrip2danalyzer(psg);
        end
    end
    
    % Prepare an empty montage based on the input data
    montage = dan_empty_montage(psg);
    
    % Prepare detection struct based on input data
    detections.d1 = struct('label', cell(length({psg.chans.labels}), 1), 'sleepstage', [],...
        'count', [], 'startSample', [], 'endSample', [],...
        'duration', [], 'peakAmp', [], 'peakFreq', []);
    [detections.d1.label] = psg.chans.labels;
    [detections.d1.count] = deal(0);
end

%% Import sleep stages

if ~isempty(stageString)
    [~, ~, stageExt] = fileparts(stageString);
    
    if strcmpi(stageExt, '.mat')
        sleepstages = load(stageString);
        structField = fieldnames(sleepstages);
        sleepstages = sleepstages.(structField{1});

        if isstruct(sleepstages)
            
            % Some older versions have different field names for lights off
            % and lights on.
            if isfield(sleepstages.hdr, 'lightsOFF')
                sleepstages.hdr.lOff = '';
            end
            
            if isfield(sleepstages.hdr, 'lightsON')
                sleepstages.hdr.lOn = '';
            end
            
            if isnumeric(sleepstages.hdr.recStart)
                sleepstages.hdr.recStart ='';
            end
            
            psg.stages.s1 = sleepstages;
        else
            psg.stages.s1.stages = sleepstages;
            psg.stages.s1.hdr.lOn       = '';
            psg.stages.s1.hdr.lOff      = '';
            psg.stages.s1.hdr.recStart  = '';
            psg.stages.s1.hdr.notes     = [];
            psg.stages.s1.hdr.onsets    = [];
            psg.stages.s1.hdr.stageTime = [];
            psg.stages.s1.hdr.win       = [];
            psg.stages.s1.hdr.srate     = [];
            psg.stages.s1.hdr.scorer    = [];
        end
        
    elseif strcmpi(stageExt, '.xlsx') || strcmpi(stageExt, '.xls')
        psg.stages.s1.stages = excelStageChangesToList(stageString);
        psg.stages.s1.hdr    = [];
        
    end

else
    psg.stages.s1.stages        = [];
    psg.stages.s1.hdr.lOn       = '';
    psg.stages.s1.hdr.lOff      = '';
    psg.stages.s1.hdr.recStart  = '';
    psg.stages.s1.hdr.notes     = [];
    psg.stages.s1.hdr.onsets    = [];
    psg.stages.s1.hdr.stageTime = [];
    psg.stages.s1.hdr.win       = [];
    psg.stages.s1.hdr.srate     = [];
    psg.stages.s1.hdr.scorer    = [];
end

%% Import events

if ~isempty(eventsString)
    [~, ~, eventsExt] = fileparts(eventsString);
    
    if strcmpi(eventsExt, '.xlsx') || strcmpi(eventsExt, '.xls') || strcmpi(eventsExt, '.csv')
        
        % Get just the time strings and event names
        eventsTable = dan_convert_csv_events(eventsString);
        
        % Convert these times into samples
        psg.events = dan_get_event_latencies(eventsTable, psg.hdr.recStart, psg.hdr.srate);
        
    elseif strcmpi(eventsExt, '.vmrk')
        [eventsTable, recStart] = dan_convert_vmrk_events(eventsString, psg.hdr.srate);
        
        if isa(eventsTable.Clock_Time, 'datetime')
            eventsTable.Clock_Time = cellstr(eventsTable.Clock_Time);
        end
            psg.events = eventsTable;
            psg.hdr.recStart = recStart;
    elseif strcmpi(eventsExt, '.mat')
        load(eventsString, 'events');
        psg.events = events;
    end
    
    if ~any(strcmpi(psg.events.Event, 'lights out') | strcmpi(psg.events.Event, 'lights off')) && ~strcmpi(psg.stages.s1.hdr.lOff, "")
        eventsTable = {psg.stages.s1.hdr.lOff 'Lights off'};
        lOffEvent = dan_get_event_latencies(eventsTable, psg.hdr.recStart, psg.hdr.srate);
        psg.events = [psg.events; lOffEvent];
        psg.events = sortrows(psg.events, 2);
    end

    if ~any(strcmpi(psg.events.Event, 'lights on')) && ~strcmpi(psg.stages.s1.hdr.lOn, "")
        eventsTable = {psg.stages.s1.hdr.lOn 'Lights on'};
        lOnEvent = dan_get_event_latencies(eventsTable, psg.hdr.recStart, psg.hdr.srate);
        psg.events = [psg.events; lOnEvent];
        psg.events = sortrows(psg.events, 2);
    end
    
else
    if ~isempty(stageString)
        if ~strcmp(psg.stages.s1.hdr.recStart, "") && ~strcmp(psg.stages.s1.hdr.lOff, "") && ~strcmp(psg.stages.s1.hdr.lOn, "")
            
            eventsTable = {psg.stages.s1.hdr.recStart 'Start recording';
                psg.stages.s1.hdr.lOff 'Lights off';...
                psg.stages.s1.hdr.lOn 'Lights on'};
            
            psg.events = dan_get_event_latencies(eventsTable, sleepstages.hdr.recStart, psg.hdr.srate);
        else
            if ~isempty(psg.hdr.recStart)
                psg.events(1, :) = table({datestr(datetime(psg.hdr.recStart, 'Format', 'HH:mm:ss.SSS'))}, 0.01, 0.01*psg.hdr.srate, {'Start recording'});
                psg.events.Properties.VariableNames = {'Clock_Time', 'Seconds', 'Samples', 'Event'};
            else
                psg.events= cell2table(cell(0, 4), 'VariableNames', {'Clock_Time', 'Seconds', 'Samples', 'Event'});
            end
        end
    else
        if ~isempty(psg.hdr.recStart)
            psg.events(1, :) = table({datestr(datetime(psg.hdr.recStart, 'Format', 'HH:mm:ss.SSS'))}, 0.01, 0.01*psg.hdr.srate, {'Start recording'});
            psg.events.Properties.VariableNames = {'Clock_Time', 'Seconds', 'Samples', 'Event'};
        else
             % Attempt to read EEGLAB events
             if ~isempty(eegevent)
                 for i = 1:length(eegevent)
                     events(i).Clock_Time = ' ';
                     events(i).Seconds    = eegevent(i).latency / psg.hdr.srate;
                     events(i).Samples    = eegevent(i).latency;
                     events(i).Event     = eegevent(i).type;
                 end
             psg.events = struct2table(events);
             else
                 psg.events = cell2table(cell(0, 4), 'VariableNames', {'Clock_Time' 'Seconds' 'Samples' 'Event'});
             end

        end
    end
end

if isempty(psg.hdr.recStart) && ~isempty(psg.events)
    
    if any(strcmpi(psg.events.Event, 'start recording'))
        recStartIdx = strcmpi(psg.events.Event, 'start recording');
        psg.hdr.recStart = psg.events.Clock_Time{recStartIdx};
    end
end
    
% Add recStart/lOn/lOff times to sleepstages

isRecStart = find(ismember(lower(psg.events{:,4}), 'start recording'));
isLOut = find(ismember(lower(psg.events{:,4}), 'lights out') |...
    ismember(lower(psg.events{:,4}), 'lights off'));
isLOn = find(ismember(lower(psg.events{:,4}), 'lights on'));

if isempty(psg.stages.s1.hdr.recStart) && ~isempty(isRecStart)
    psg.stages.s1.hdr.recStart = psg.events{isRecStart, 1}{1};
end

if isempty(psg.stages.s1.hdr.lOff) && ~isempty(isLOut)
    psg.stages.s1.hdr.lOff = psg.events{isLOut, 1}{1};
end

if isempty(psg.stages.s1.hdr.lOn) && ~isempty(isLOn)
    psg.stages.s1.hdr.lOn = psg.events{isLOn, 1}{1};
end

%% Import ar

if ~isempty(arString)
    ar = load(arString);
    
    if isfield(ar, 'rejinfo')
        psg.ar = ar.rejinfo;
    elseif isfield(ar, 'ar')
        psg.ar = ar.ar;
    end
    
    arFields = fieldnames(psg.ar);
    
    if ~ismember('badepochs', arFields)
        psg.ar.badepochs = [];
    end
    
    if ~ismember('badchans', arFields)
        psg.ar.badchans = [];
    end
    
    if ~ismember('badsegments', arFields)
        psg.ar.badsegments = [];
    end
    
else
    psg.ar.badchans    = [];
    psg.ar.badepochs   = [];
    psg.ar.badsegments = [];
    
end

handlesOut = handlesIn;
handlesOut.psg = psg;
handlesOut.montage = montage;
handlesOut.detections = detections;
