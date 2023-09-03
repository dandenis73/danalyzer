function h = plot_phases(data, color)
% Produces a polar plot of phase angles. Input data must be in radians.
% Requires circStats package
%
%%
% Authors:  Dan Denis
% Date:     2021-07-14
%%
if iscell(data)
    
    for i = 1:length(data)
        
        % Remove any NaN
        data{i}(isnan(data{i})) = [];
        
        % Find the mean vector length
        r(i) = circ_r(data{i}');
        
        % Find the mean phase
        mn(i) = circ_mean(data{i}');
        
    end
    
else
    data(isnan(data)) = [];
    r = circ_r(data');
    mn = circ_mean(data');
end

% Set rlim in polar plot
t = 0 : .01 : 2*pi;
[P] = polar(t, 1*ones(size(t)));
hold on
set(P, 'Visible', 'On')

if iscell(data)
    for i = 1:length(data)
        
        % Compass plot all the phase distributions
        h = compass_lines(exp(1i*data{i}));
        set(h, 'Color', [color(i,:)], 'LineWidth', 1)
        
        
    end
else
    % Compass plot all the phase distributions
    h = compass_lines(exp(1i*data));
    set(h, 'Color', [color], 'LineWidth', 1)
    
end

if iscell(data)
    for i = 1:length(data)
        
        % Plot Amplitude Criterion Mean Phase
        h  = compass(r(i)*exp(1i*mn(i)));
        set(h, 'Color',[color(i,:)],'Linewidth',3)
        
    end
    
else
    % Plot Amplitude Criterion Mean Phase
    h  = compass(r*exp(1i*mn(1)));
    set(h, 'Color','k','Linewidth',3)
    
end

% Plot athick outline
xx = 1*ones(size(t)) .* cos(t);
yy = 1*ones(size(t)) .* sin(t);
plot(xx, yy, 'Color','k','Linewidth',2);