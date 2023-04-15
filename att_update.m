function [qua_n, DCMbn_n, euler] = att_update(wb, DCMbn, qua, omega_ie_N, omega_en_N, dt, att_mode)
% Ali Mohammadi_INS/GNSS

% att_update: updates attitude using quaternion or DCM.
%
% INPUT:
%   wb,         3x1 incremental turn-rates in body-frame (rad/s).
%   DCMbn,      3x3 body-to-nav DCM.
%   qua,        4x1 quaternion.
%   omega_ie_N, 3x1 Earth rate (rad/s).
%   omega_en_N, 3x1 Transport rate (rad/s).
%   dt,         1x1 IMU sampling interval (s).
%	att_mode,   attitude mode string.
%      'quaternion': attitude updated in quaternion format. Default value.
%             'dcm': attitude updated in Direct Cosine Matrix format.
%
% OUTPUT:
%   qua_n,      4x1 updated quaternion.
%   DCMbn_n,    3x3 updated body-to-nav DCM.
%   euler,      3x1 updated Euler angles (rad).
%%

if nargin < 7, att_mode  = 'quaternion'; end

%% Correct gyros output for Earth rate and Transport rate

wb_n = ( wb - DCMbn' * (omega_ie_N + omega_en_N));

if strcmp(att_mode, 'quaternion')
%% Quaternion update   

    qua_n   = qua_update(qua, wb_n, dt);    % Update quaternion
    qua_n   = qua_n / norm(qua_n);          % Brute-force normalization
    DCMbn_n = qua2dcm(qua_n);               % Update DCM
    euler   = qua2euler(qua_n);             % Update Euler angles
    
elseif strcmp(att_mode, 'dcm')
%% DCM update    
    
    euler_i = wb_n * dt;                    % Incremental Euler angles 
    DCMbn_n = dcm_update(DCMbn, euler_i);   % Update DCM
    euler   = dcm2euler(DCMbn_n);           % Update Euler angles
    qua_n   = euler2qua(euler);             % Update quaternion
    qua_n   = qua_n / norm(qua_n);          % Brute-force normalization
    
else
    error('att_update: no attitude update mode defined.')
end

end
