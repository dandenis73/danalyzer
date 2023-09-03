function dataOUT = fun_normalize_psd(dataIN, freqs, lims, method)
% Normalizes power spectral density estimates.
%
% Required input:
%
% dataIN: A frequency x channel array containing the PSD estimate
% for each frequency bin from each channel
%
% freqs: A nx1 array indicating the frequency at each bin (each row of
% dataIN)
%
% lims: [lower upper] bounds of frequencies to normalize by. e.g. [1 35] w
% would normalize PSD relative to mean/sum of 1-35Hz activity
%
% method: How to calculate the denominator. Either 'mean' or 'sum' over
% lims.
%
% Output:
%
% dataOUT: Normalized power spectral density estimates
%
%%
% Authors:  Dimitrios Mylonas
%           Dan Denis
% Date:     2021-07-14
%% 

% Index frequencies in lims
baseIdx = freqs >= lims(1) & freqs <= lims(2);


if strcmpi(method, 'mean')
    basePSD = mean(dataIN(baseIdx, :));
elseif strcmpi(methof, 'sum')
    basePSD = sum(dataIN(baseIdx, :));
end

% Normalize by dividing absolute power by baseline power
dataOUT = dataIN ./ basePSD;





