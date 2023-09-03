function eventsOut = dan_convert_csv_events(eventsIn)
% This function converts an Excel, CSV events file into the correct format
% for danalyzer
%%
% Authors:  Dan Denis
% Date:     2021-07-14

%%

% Read in events table
eventsTable = cellfun(@num2str,...
    table2cell(readtable(eventsIn, 'ReadVariableNames', 0)),...
    'un', 0);

% Now find which column contains rows matching the required input
timeStringIdx = regexp(eventsTable, '\d\d:\d\d:\d\d.\d*');

% Extact the column containing the times, and the column next to it
% This ASSUMES this column will contain the event names. This will
% be the case if formatting instructions correctly followed.

[timeRows, timeCols] = find(~cellfun(@isempty, timeStringIdx));
eventsOut = eventsTable(timeRows, timeCols:timeCols+1);

