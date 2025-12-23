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

if ~iscolumn(psgIn.label)
    psgIn.label = psgIn.label';
end

% Try to add channel type
if isfield(psgIn, 'elec')
    chan_type = psgIn.elec.chantype(ismember(lower(psgIn.elec.label), lower(psgIn.label)));
elseif isfield(psgIn, 'hdr')
    chan_type = psgIn.hdr.chantype(ismember(lower(psgIn.hdr.label), lower(psgIn.label)));
else
    chan_type = repelem({'other'}, length(psgIn.label));
end

psgOut.chans  = struct('labels', psgIn.label, 'type', chan_type);
