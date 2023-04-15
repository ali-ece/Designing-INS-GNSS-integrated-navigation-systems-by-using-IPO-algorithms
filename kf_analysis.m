function  kf_analysis (nav_e)
% Ali Mohammadi_INS/GNSS

% kf_analysis: evaluates Kalman filter performance.
%
% INPUT
%   nav,  INS/GNSS dataset.
%% A POSTERIORI STATE ANALYSIS

variable = { 'roll', 'pitch', 'yaw', 'vel N', 'vel E', 'vel D', 'latitude', 'longitude', 'altitude' };

for i=1:9
    
    [pd, ha] = normality_test ( nav_e.xp (:, i) );
    
    figure(i)
    plot_histogram (nav_e.xp (:, i), pd)
    
    if ~( ha )
        fprintf('kf_analysis: state vector for %s comes from a normal distribution.\n', variable{i});
        
    else
         fprintf('kf_analysis: %s analysis does not come from a normal distribution.\n', variable{i});
        
    end
end

%% INNOVATION ANALYSIS

variable = { 'vel N', 'vel E', 'vel D', 'latitude', 'longitude', 'altitude' };

for i=1:6
    
    [pd, ha] = normality_test ( nav_e.v (:, i) );
    
    figure(i+9)
    plot_histogram (nav_e.v (:, i), pd)
    
    if ~( ha )
        fprintf('kf_analysis: innovations for %s comes from a normal distribution.\n', variable{i});
        
    else
         fprintf('kf_analysis: innovations for %s does not come from a normal distribution.\n', variable{i});
        
    end
end


end