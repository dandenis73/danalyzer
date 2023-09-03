function [power, tfFreqs, tfTimes, efwhm] = fun_tfr_morlet(data, srate, times, varargin)
% Time frequency decomposition using complex Morlet wavelets.
%
% This function should be considered highly experimental and may not yield
% desirble results in all settings
%
% Required inputs:
%
% data: Either a channel x timepoint or a channel x timepoint x trials
% array
%
% srate: The sampling rate of the data (in Hz)
%
% times: An array of times corresponding to each timepoint (ms)
%
% Optional inputs:
%
% 'Frequencies': [min max] frequency range to analyse. Default = [2 40]
%
% 'NumFrequencies': Total number of frequencies. Default = 30
%
% 'ScaleFrequencies': Scale frequencies on either a 'log' or 'linear' scale.
% Default = 'log'
%
% 'Cycles': Number of wavelet cycles. Either a single integer to specify a
% fixed number of cycles for all frequencies or a [min max] to vary the
% number of cycles with frequency. Default = 5
%
% 'FWHM': Specify wavelet in terms of full-width at half max (FWHM) rather
% than number of cycles. Either a single integer to specify a fixed FWHM or
% a [min max] to vary the FWHM with frequency. If FWHM is set, will
% supercede 'Cycles'. If not set, wavelets will be specified in terms of
% cycles.
%
% 'Baseline': [start end] of baseline period for normalisation. Either in
% samples, or the same unit as 'Times' if provided.
%
% 'Normalization': Normalise power. Either 'db' (decibel normalisation),
% 'pct' (percent change), 'div' (divide by baseline) 'z' (z-score), or 
% 'none'. Default = 'db'
%
% 'TrialAverage': Average power across all trials. Either 'mean', 'median',
% or 'none' (will return single trial power). Default = 'mean'.
%
% Outputs:
%
% power: Channel x frequency x time power
%
% tfFreqs: Array of frequencies (in Hz)
%
% tfTimes: Array of times (either in samples or the same unit as 'Times')
%
% efwhm: The empirical full-width at half-max 
%% 
% Authors:  Dan Denis
% Date:     2021-07-14
%
% Remarks: Morlet wavelet time-frequency decomposition of event-related
% data using Mike Cohen's Implementation. See Cohen MX (2014) Analysing
% Neural Time Series Data. MIT Press and Cohen MX (2019) NeuroImage
%% Default settings

freqs      = [2 40];
nFreqs     = 30;
scale      = 'log';
cycles     = 5;
fwhm       = [];
baseline   = [];
normMethod = 'db';
avgMethod  = 'mean';

%%% Update defaults based on varargin
if find(strcmpi(varargin, 'Frequencies'))
    freqs = varargin{find(strcmpi(varargin, 'Frequencies'))+1};
end

if find(strcmpi(varargin, 'NumFrequencies'))
    nFreqs = varargin{find(strcmpi(varargin, 'NumFrequencies'))+1};
end

if find(strcmpi(varargin, 'ScaleFrequencies'))
    scale = varargin{find(strcmpi(varargin, 'ScaleFrequencies'))+1};
end

if find(strcmpi(varargin, 'Cycles'))
    cycles = varargin{find(strcmpi(varargin, 'Cycles'))+1};
end

if find(strcmpi(varargin, 'FWHM'))
    fwhm = varargin{find(strcmpi(varargin, 'FWHM'))+1};
end

if find(strcmpi(varargin, 'Baseline'))
    baseline = varargin{find(strcmpi(varargin, 'Baseline'))+1};
end

if find(strcmpi(varargin, 'Normalization'))
    normMethod = varargin{find(strcmpi(varargin, 'Normalization'))+1};
end

if find(strcmpi(varargin, 'Normalisation'))
    normMethod = varargin{find(strcmpi(varargin, 'Normalisation'))+1};
end

if find(strcmpi(varargin, 'TrialAverage'))
    avgMethod = varargin{find(strcmpi(varargin, 'TrialAverage'))+1};
end
%% Wavelet parameters

% Length of the wavelet
wavet = -1:1/srate:1;

% Define frequencies and cyles/fwhm, based on input parameters
if strcmpi(scale, 'log')
    frex = logspace(log10(freqs(1)),log10(freqs(2)),nFreqs);

    if isempty(fwhm) % Cycles
        if length(cycles) == 1
            cycles(2) = cycles(1);
        end

        s = logspace(log10(cycles(1)),log10(cycles(2)),nFreqs)./(2*pi*frex);
    else
        if length(fwhm) == 1
            fwhm(2) = fwhm(1);
        end

        s = logspace(log10(fwhm(1)),log10(fwhm(2)),length(frex));
    end

elseif strcmpi(scale, 'linear')
    frex = linspace(freqs(1), freqs(2),nFreqs);

    if isempty(fwhm) % Cycles
        if length(cycles) == 1
            cycles(2) = cycles(1);
        end

        s = linspace(cycles(1), cycles(2) ,nFreqs)./(2*pi*frex);
    else
        if length(fwhm) == 1
            fwhm(2) = fwhm(1);
        end

        s = linspace(fwhm(1),fwhm(2),length(frex));
    end
end
%% Convolution parameters

% Size of the data;
nChans = size(data, 1);
nPnts = size(data, 2);
if ndims(data) == 3
    nTrials = size(data, 3);
else
    nTrials = 1;
end

n_wavelet            = length(wavet);
n_data               = nPnts*nTrials;
n_convolution        = n_wavelet+n_data-1;
n_conv_pow2          = pow2(nextpow2(n_convolution));
half_of_wavelet_size = (n_wavelet-1)/2;

% Initialise
power = zeros(nChans, nFreqs, nPnts);
itpc  = zeros(nChans, nFreqs, nPnts);
efwhm = zeros(nFreqs, 1);

% Find baseline indices
if ~isempty(baseline)
    baseIdx = dsearchn(times', baseline');
else
    % Normalise over whole trial period if no baseline specified but a
    % normalisation has been requested
    baseIdx = 1:nPnts;
end
%% Run time-frequency decomposition

% Loop over channels
for chan_i = 1:nChans

    % Get FFT of data
    if ndims(data) == 3
        if isempty(fwhm)
        eegfft = fft(reshape(data(chan_i,:,:),1,nPnts*nTrials),n_conv_pow2);
        else
            eegfft = fft(reshape(data(chan_i,:,:),1,nPnts*nTrials),n_convolution);
        end
    elseif ismatrix(data)
        % Needs to be changed
        eegfft = fft(reshape(data(chan_i,:),1,nPnts*nTrials),n_conv_pow2);
    end

    % Loop over frequencies
    for freq_i = 1:nFreqs

        % Create wavelet
        if isempty(fwhm)
            wavelet = fft(sqrt(1/(s(freq_i)*sqrt(pi))) * exp(2*1i*pi*frex(freq_i).*wavet) .* exp(-wavet.^2./(2*(s(freq_i)^2))), n_conv_pow2);
        else
            wavelet = fft(exp(2*1i*pi*frex(freq_i)*wavet).*exp(-4*log(2)*wavet.^2/s(freq_i).^2),n_convolution);
        end

        wavelet = wavelet./max(wavelet); % normalize

        % convolution
        eegconv = ifft(wavelet.*eegfft);
        eegconv = eegconv(1:n_convolution);
        eegconv = eegconv(half_of_wavelet_size+1:end-half_of_wavelet_size);

        % Power
        temppower = abs(reshape(eegconv,nPnts,nTrials)).^2;

        % Average power over trials
        if ~strcmpi(avgMethod, 'none')

            if strcmpi(avgMethod, 'mean')
                temppower = mean(temppower, 2);
            elseif strcmpi(avgMethod, 'median')
                temppower = median(temppower, 2);
            end
        end

        power(chan_i, freq_i, :) = temppower;

        % Empirical FWHM
        hz = linspace(0, srate, n_convolution);
        idx = dsearchn(hz', frex(freq_i));
        fx  = abs(wavelet);
        efwhm(freq_i) = hz(idx-1+dsearchn(fx(idx:end)',.5)) - hz(dsearchn(fx(1:idx)',.5));

    end

    % Normalisation
    if ~strcmpi(normMethod, 'none')
        power(chan_i, :, :) = tfrnorm(squeeze(power(chan_i, :, :)), baseIdx, normMethod);
    end


end

tfFreqs = frex;
tfTimes = times;