function varargout = spindle_visualiser(varargin)
% SPINDLE_VISUALISER MATLAB code for spindle_visualiser.fig
%      SPINDLE_VISUALISER, by itself, creates a new SPINDLE_VISUALISER or raises the existing
%      singleton*.
%
%      H = SPINDLE_VISUALISER returns the handle to a new SPINDLE_VISUALISER or the handle to
%      the existing singleton*.
%
%      SPINDLE_VISUALISER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SPINDLE_VISUALISER.M with the given input arguments.
%
%      SPINDLE_VISUALISER('Property','Value',...) creates a new SPINDLE_VISUALISER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before spindle_visualiser_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to spindle_visualiser_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help spindle_visualiser

% Last Modified by GUIDE v2.5 11-Feb-2025 16:19:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @spindle_visualiser_OpeningFcn, ...
                   'gui_OutputFcn',  @spindle_visualiser_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before spindle_visualiser is made visible.
function spindle_visualiser_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to spindle_visualiser (see VARARGIN)

% Choose default command line output for spindle_visualiser
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes spindle_visualiser wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = spindle_visualiser_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function sp_number_Callback(hObject, eventdata, handles)
% hObject    handle to sp_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sp_number as text
%        str2double(get(hObject,'String')) returns contents of sp_number as a double

new_spindle = str2double(get(handles.sp_number, 'String'));

if new_spindle < 1
    new_spindle = 1;
    set(handles.sp_number, 'String', num2str(new_spindle))
elseif new_spindle > size(handles.data.seg, 1)
    new_spindle = size(handles.data.seg, 1);
    set(handles.sp_number, 'String', num2str(new_spindle))

end

handles.sp_num = new_spindle;

% Plot data to screen
[hObject, handles] = plot_spindles(hObject, handles);

% Update handle structure
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function sp_number_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sp_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in next_sp.
function next_sp_Callback(hObject, eventdata, handles)
% hObject    handle to next_sp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

new_spindle = handles.sp_num + 1;

if new_spindle < 1
    new_spindle = 1;
elseif new_spindle > size(handles.data.seg, 1)
    new_spindle = size(handles.data.seg, 1);
end

handles.sp_num = new_spindle;

% Plot data to screen
[hObject, handles] = plot_spindles(hObject, handles);

% Update handle structure
guidata(hObject,handles);

set(handles.sp_number, 'String', num2str(new_spindle))


% --- Executes on button press in prev_sp.
function prev_sp_Callback(hObject, eventdata, handles)
% hObject    handle to prev_sp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


new_spindle = handles.sp_num - 1;

if new_spindle < 1
    new_spindle = 1;
elseif new_spindle > size(handles.data.seg, 1)
    new_spindle = size(handles.data.seg, 1);
end

handles.sp_num = new_spindle;

% Plot data to screen
[hObject, handles] = plot_spindles(hObject, handles);

% Update handle structure
guidata(hObject,handles);

set(handles.sp_number, 'String', num2str(new_spindle))



% --- Executes on button press in load_data.
function load_data_Callback(hObject, eventdata, handles)
% hObject    handle to load_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get the directory of the data file
[filename, filepath] = uigetfile({'*.mat'},...
    'Load data file');

load(fullfile(filepath, filename))

handles.data.all = sp_all;
handles.data.seg = sp_seg;
handles.data.srate = srate;
handles.data.peak_freq = peak_freq;
handles.data.bwidth = bwidth;

handles.sp_num = 1;

% Plot data to screen
[hObject, handles] = plot_spindles(hObject, handles);

% Update handle structure
guidata(hObject,handles);


% --- Executes on key press with focus on figure1 or any of its controls.
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

if strcmp(eventdata.Key, 'rightarrow')
    next_sp_Callback(hObject, eventdata, handles)
elseif strcmp(eventdata.Key, 'leftarrow')
    prev_sp_Callback(hObject, eventdata, handles)
end


function [hObject, handles] = plot_spindles(hObject, handles)


% Get data out of handles
sp_i = handles.sp_num;

sp_all = handles.data.all;
sp_seg = handles.data.seg;
srate  = handles.data.srate;
peak_freq = handles.data.peak_freq;
bwidth = handles.data.bwidth;

%% Plot raw and filtered signal

% Time vector (centred on detection point)
time_vec = (-1+1/srate):1/srate:1;

% Raw signal
plot(handles.plot_raw, time_vec, sp_seg{sp_i, 1}, 'Color', 'k', 'LineWidth', 2)
ylabel(handles.plot_raw, 'Amplitude (\muV)')
title(handles.plot_raw, 'Raw signal')

% Wavelet-filtered signal
plot(handles.plot_filt, time_vec, mean(real(sp_seg{sp_i, 2})), 'Color', 'k', 'LineWidth', 2)
ylabel(handles.plot_filt, 'Amplitude (\muV)')
title(handles.plot_filt, 'Wavelet-filtered signal')

%% Peak frequency and sigma power from FFT

% FFT of the spindle
Y = fft(mean(real(sp_seg{sp_i, 2}))); % Fourier transform of the spindle
L = length(sp_seg{sp_i, 2});
f = srate*(0:(L/2))/L; % frequencies
Y = Y(1:L/2+1);

% Find the frequency with the maximum coefficient
[~,PeakFreqIdx] = max(abs(Y));

% Sigma power (spectral density)
lowFreq = peak_freq - (bwidth/2);
highFreq = peak_freq + (bwidth/2);

Y                = (1/(srate*L)) * abs(Y).^2; % Calculate uV^2/Hz
[~,lowFreqIdx]    = min(abs(f-lowFreq));
[~,highFreqIdx]   = min(abs(f-highFreq));


plot(handles.plot_psd, f, Y, 'Color', 'k', 'LineWidth', 2)
hold on
ylim = get(handles.plot_psd, 'YLim');
xline(handles.plot_psd, f(PeakFreqIdx), 'LineWidth', 1.5, 'LineStyle', '--')
rectangle(handles.plot_psd, 'Position', [f(lowFreqIdx) ylim(1) f(highFreqIdx) - f(lowFreqIdx) ylim(2)], 'FaceColor', [0 0 0 0.1], 'EdgeColor','none')

xlabel(handles.plot_psd, 'Frequency (Hz)'); ylabel(handles.plot_psd, 'PSD (\muV^2/Hz)')
set(handles.plot_psd, 'XLim', [5 20])
title(handles.plot_psd, {['Peak Frequency = ' num2str(f(PeakFreqIdx)) 'Hz'] ...
    ['Sigma power = ' num2str(mean(Y(lowFreqIdx:highFreqIdx)), '%.2f') '\muV^2/Hz']})

%% Calculate the smoothed amplitude envelope

meanCoef      = mean(abs(real(sp_seg{sp_i, 2}))); % Rectified mean across wavelet scales
[env,~]       = envelope(meanCoef,2,'peak'); % Calculate the envelope
window        = ones(round(srate/5),1)/round(srate/5); % Create a 200ms sliding window
smoothedEnv  = filtfilt(window,1,env); % Smooth data

%% Find Peak amplitude and peak location

% Maximum amplitude and location
% Use findpeaks instead of max(smoothed_env) to avoid finding the peak
% at the end or start of the spindle
[peak,peakIdx] = findpeaks(smoothedEnv);
if ~isempty(peak)
    [~,idx] = max(peak);
    peak = peak(idx); % value of peak
    peakIdx = peakIdx(idx);% index of peak
else
    % The only case that findpeaks won't work are if envelope is a
    % motonic or a parabolic like function (both very rare but happen)
    [peak,peakIdx] = max(smoothedEnv);
end

%% Find duration (Full-width half-max)
dropmax = .50; % define where sppindle edges will be, relative to the peak (e.g. .5 of max)

% Find spindle start
edge1 = find(smoothedEnv(1:peakIdx)<peak*dropmax,1,'last')+1;
if isempty(edge1); edge1 = 1; end

% Find spindle end
edge2 = find(smoothedEnv(peakIdx:end)<peak*dropmax,1,'first')-1;
if isempty(edge2)
    edge2 = length(smoothedEnv);
else
    edge2 = edge2+peakIdx-1;
end

duration = (edge2-edge1)/srate;

%% Find Energy (Amplitude*Duration) 
% Use envelope to calculate energy
energy = sum(env(edge1:edge2));

%% Find spindle steepness (raise + drop) in amplitude/sec
raisingSlope  = srate*( peak - smoothedEnv(edge1) ) / (peakIdx - edge1); % Multiply with srate to convert to XXX/sec
droppingSlope = srate*( peak - smoothedEnv(edge2) ) / (peakIdx - edge2);

%% Find number of bumps on the smoothed envelope
[bump_amp,bumps] = findpeaks(smoothedEnv(edge1:edge2));
numBumps = length(bumps);

%% Find Symmetry (Purcell et al., 2017)
symmetry = (peakIdx-edge1)/(edge2-edge1);

%% Plot smoothed window 
cla(handles.plot_env)
plot(handles.plot_env, time_vec, smoothedEnv, 'Color', 'k', 'LineWidth', 2)
hold(handles.plot_env, 'on')
ylim = get(handles.plot_env, 'YLim');

midpoint = time_vec(floor((edge1 + edge2) / 2));

% Spindle peak
xline(handles.plot_env, time_vec(peakIdx), 'LineWidth', 1.5, 'LineStyle','-')
% Start
xline(handles.plot_env, time_vec(edge1), 'LineWidth', 1.5, 'LineStyle', '--')
% End 
xline(handles.plot_env, time_vec(edge2), 'LineWidth', 1.5, 'LineStyle', '--')
% Midpoint
xline(handles.plot_env, midpoint, 'LineWidth', 1.5, 'LineStyle', '--')
% Duration
plot(handles.plot_env, [time_vec(edge1) time_vec(edge2)], [ylim(2) * 0.05 ylim(2) * 0.05], 'LineWidth', 1.5, 'LineStyle', '-')
% Symmetry
if symmetry > 0.5
    plot(handles.plot_env, [midpoint time_vec(peakIdx)], [ylim(2)*0.5 ylim(2) * 0.5], 'LineWidth', 1.5, 'LineStyle', '-')
elseif symmetry < 0.5
    plot(handles.plot_env, [time_vec(peakIdx) midpoint], [ylim(2)*0.5 ylim(2) * 0.5], 'LineWidth', 1.5, 'LineStyle', '-')
end
% Raising slope
plot(handles.plot_env, [time_vec(edge1) time_vec(peakIdx)], [smoothedEnv(edge1) smoothedEnv(peakIdx)], 'LineWidth', 1.5, 'LineStyle', '--', 'Color', 'k')
% Dropping slope
plot(handles.plot_env, [time_vec(peakIdx) time_vec(edge2)], [smoothedEnv(peakIdx) smoothedEnv(edge2)], 'LineWidth', 1.5, 'LineStyle', '--', 'Color', 'k')
% Bumps
t2 = time_vec(edge1:edge2);
scatter(handles.plot_env, t2(bumps), bump_amp, 40, 'red', 'filled', 'o')

hold(handles.plot_env, 'off')
legend(handles.plot_env, {'Smoothed Envelope' 'Peak Amplitude' '' '' '' 'Duration' 'Symmetry' 'Raising Slope' 'Dropping Slope' 'Bumps'})
ylabel(handles.plot_env, 'Amplitude (\muV)')


%% Number of cycles

%Find number of cycles & frequency gradient & Fano factor
% Find peaks in the rectified signal

[~,locs] = findpeaks(meanCoef(edge1:edge2));

% Find zero crossings
%zeroCross = [0,diff(sign(mean(real(sp_seg{sp_i, 2}(edge1:edge2)),1)))];
%zeroLocs = find(zeroCross < 0 | zeroCross > 0);

% Work on the real signal
zeroCross = [0, diff(sign(mean(real(sp_seg{sp_i, 2}(:, edge1:edge2)))))];
zeroLocs = find(zeroCross < 0 | zeroCross > 0);

% Calculate number of cycles
numCycles = length([locs,zeroLocs])/4;

% Fit a robust regression model on the distance between peaks
try
    b = robustfit(1:length([locs,zeroLocs])-1,diff(sort([locs,zeroLocs])).*1000/srate);
catch
    disp(['Problematic fit; Frequency gradient is not calculated for spindle no. ' num2str(sp)])
    b(1)=nan;b(2)=nan;
end
% Frequency gradient tells you how many msec faster/slower is each cycle from the next one
freqGradient = 4*b(2);

% Fano factor
fano = var(diff(locs))/mean(diff(locs));

%% Plot everything

% Plot filtered signal
cla(handles.plot_all)
plot(handles.plot_all, time_vec,mean(real(sp_seg{sp_i, 2}),1),'DisplayName', ['Spindle filtered at ' num2str(12) '-' num2str(15) 'Hz'],'Color', 'k', 'LineWidth', 2);
hold(handles.plot_all, 'on')
% Plot rectified filtered signal
plot(handles.plot_all, time_vec,env,'DisplayName', 'Rectified signal' ,'Color',[.5 .5 1], 'LineWidth', 2);
% Plot smoothed mean (~envelope)
plot(handles.plot_all, time_vec,smoothedEnv, 'DisplayName', 'Smoothed Mean','Color',[0.8 0.5 0.8],'LineWidth',3);
% Plot Peak amplitude and location
scatter(handles.plot_all, time_vec(peakIdx), peak, 'DisplayName', 'Peak','sizedata', 40,'MarkerFaceColor','flat','CData',[0 1 0]);
% Plot detection point
scatter(handles.plot_all, 0, smoothedEnv(srate), '>','DisplayName', 'Peak','sizedata', 70,...
    'MarkerEdgeColor','r','LineWidth',2);
% Plot spindle start
scatter(handles.plot_all, time_vec(edge1), smoothedEnv(edge1),'o', 'DisplayName', 'Spindle start','MarkerFaceColor',[1 1 1]);
% Plot spindle end
scatter(handles.plot_all, time_vec(edge2), smoothedEnv(edge2),'o', 'DisplayName', 'Spindle end','MarkerFaceColor',[1 1 1]);
% Plot rising slope
plot(handles.plot_all, [time_vec(edge1) time_vec(peakIdx)], [smoothedEnv(edge1) smoothedEnv(peakIdx)], 'DisplayName', 'Rising slope', 'LineWidth', 1.5, 'LineStyle', '--', 'Color', 'k')
% Plot dropping slope
plot(handles.plot_all, [time_vec(peakIdx) time_vec(edge2)], [smoothedEnv(peakIdx) smoothedEnv(edge2)], 'DisplayName', 'Dropping slope', 'LineWidth', 1.5, 'LineStyle', '--', 'Color', 'k')
% Plot Local maxima
scatter(handles.plot_all, time_vec(edge1+locs-1), mean(real(sp_seg{sp_i, 2}(:,edge1+locs-1))),'*', 'sizedata', 80, 'MarkerEdgeColor',[.5 .5 1]);
hold(handles.plot_all, 'off')

%% Add to data table

set(handles.sp_features, 'Data', {'Amplitude' peak; 'Duration', duration; 'Frequency' f(PeakFreqIdx); 'Power' mean(Y(lowFreqIdx:highFreqIdx)); ...
    'Energy' energy; 'Symmetry' symmetry; 'Bumps' numBumps; 'RaisingSlope' raisingSlope; 'DroppingSlope' droppingSlope; 'Cycles' numCycles; 'FreqGradient' freqGradient; 'Fano' fano; ...
    'Refractory' sp_all.refrPeriod(sp_i); 'Correlation' sp_all.corrCoef(sp_i)})


