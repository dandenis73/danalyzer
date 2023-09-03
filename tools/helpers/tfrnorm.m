function normpower = tfrnorm(rawpower, baseline, method)
% Normaliise time-frequency power using one of the following methods:
%
% db = Decibel normalisation
% pct = Percent change
% div = Divide by baseline
% z = z-score
%
%
% Required inputs:
%
% rawpower: frequency x times matrix
% baseline: Indices for baseline period
% method: Normalisation method (see above)
%% 

baselinepower = mean(rawpower(:, baseline(1):baseline(2)), 2);


if strcmpi(method, 'db')
    normpower = 10*log10(rawpower./baselinepower);
elseif strcmpi(method, 'pct')
    normpower = 100 * (rawpower - baselinepower) ./  baselinepower;
elseif strcmpi(method, 'div')
    normpower = rawpower ./ baselinepower;
elseif strcmpi(method, 'z')
    baselinepowerSD = std(rawpower(baseline(1):baseline(2)));
    normpower = (rawpower - baselinepower) ./ baselinepowerSD;
end


