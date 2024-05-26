function psgOut = fieldtrip2danalyzer(psgIn)
% Converts a FieldTrip raw struct to danalyzer format.
%%
% Authors:  Dan Denis
% Date:     2024-01-12
%%

psgOut.data         = psgIn.trial{1, 1};
psgOut.hdr.srate    = psgIn.fsample;
psgOut.hdr.samples  = size(psgIn.trial{1, 1}, 2);

psgOut.hdr.recStart = [];

psgOut.chans  = struct('labels', psgIn.label);
