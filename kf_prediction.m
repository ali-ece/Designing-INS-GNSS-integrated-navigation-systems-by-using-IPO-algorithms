function  kf = kf_prediction(kf, dt)
% Ali Mohammadi_INS/GNSS

% kf_prediction: Prediction update part of the Kalman filter algorithm.
%
% INPUT
%   kf: data structure with at least the following fields:
%       xp: 21x1 a posteriori state vector (old).
%       Pp: 21x21 a posteriori error covariance (old).
%        F: 21x21 state transition matrix.
%        Q: 12x12 process noise covariance.
%        G: 21x12 control-input matrix.      
%   		dt: sampling interval. 
%
% OUTPUT
%    kf: the following fields are updated:
%       xi: 21x1 a priori state vector (updated).
%       Pi: 21x21 a priori error covariance.
%        A: 21x21 state transition matrix.
%       Qd: 21x6  discrete process noise covariance.
%%

% Discretization of continous-time system
kf.A =  expm(kf.F * dt);          				% Exact solution for linerar systems
% S.A = I + (S.F * dt);         				% Approximated solution by Euler method 
kf.Qd = (kf.G * kf.Q * kf.G') .* dt;            % Digitalized covariance matrix

% Step 1, predict the a priori state vector xi
kf.xi = kf.A * kf.xp;

% Step 2, update the a priori covariance matrix Pi
kf.Pi = (kf.A * kf.Pp * kf.A') + kf.Qd;
kf.Pi =  0.5 .* (kf.Pi + kf.Pi');                  % Force Pi to be symmetric matrix

end
