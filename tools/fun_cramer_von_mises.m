function z = fun_cramer_von_mises(data)
% Cramér-von Mises test of coupling strength. Tests the degree to which the
% phase distribution shows a preferential peak relative to a uniform
% distribution. Value close to 1 when the coupling phase is consistent
% across spindles
%
% Required input:
%
% data: Coupling phases in radians
%
% Outputs:
%
% z: Coupling strength
%
%% 
% Authors:  Dimitrios Mylonas
% Date:     2021-07-14
%
%%

if ~isempty(data) && length(data) > 1
    x_data = sort(data);
    y_data = (1:length(x_data))./(length(x_data)+1);
    y_unif = (x_data+pi)./(2*pi); %values from 0 to pi
    
    y_diff = abs(y_unif - y_data);
    z = trapz(x_data, y_diff); %find difference in areas using trapezoidal rule
    
else
    z = NaN;
end



