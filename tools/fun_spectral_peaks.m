function peaks = fun_spectral_peaks(data, freqs, peakRange)
% Peak detection in a power spectrum

% Required inputs:
%
% data: A frequency x channel power spectrum (e.g. from the output of
% fun_spectral_power)
%
% freqs: Array of spectral power frequencies (must match first dimension of
% data
%
% peakRange: [min max] frequency in which to detect peaks. If empty or [0
% 0], detect all peaks in data
%
% Output:
%
% peaks: n x 2 array containing n peak frequency and prominence
%
%%
% Authors:  Dan Denis
% Date:     2021-07-14
%%

% Loop across channels (dim 2 of data

peaks = zeros(size(data, 2), 2);
for chan_i = 1:size(data, 2)

    % Find peaks and sort
    [pks, locs, ~, P] = findpeaks(double(data(:, chan_i)), double(freqs));
    [~, sortInd] = sort(pks, 'descend');
    sortedFreqs  = locs(sortInd);
    sortedProm   = P(sortInd);
    
    targetFreqs = find(sortedFreqs >= peakRange(1) & sortedFreqs <= peakRange(2), 1, 'first');
    sortedPeaks = [sortedFreqs(targetFreqs) sortedProm(targetFreqs)];

    if ~isempty(sortedPeaks)
        peaks(chan_i, :) = sortedPeaks;
    else
        peaks(chan_i, :) = nan(1, 2);
    end

end




