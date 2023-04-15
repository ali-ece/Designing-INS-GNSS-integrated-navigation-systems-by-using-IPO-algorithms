function  kf = kalman(kf, dt)
% Ali Mohammadi_INS/GNSS

% kalman: Kalman filter algorithm.
%
% INPUT
%   kf: data structure with at least the following fields:
%       xp: 21x1 a posteriori state vector (old).
%        z: 6x1 innovations vector.
%        F: 21x21 state transition matrix.
%        H: 6x21 observation matrix.
%        Q: 12x12 process noise covariance.
%        R: 6x6  observation noise covariance.
%       Pp: 21x21 a posteriori error covariance.
%        G: 21x12 control-input matrix.      
%   		dt: sampling interval. 
%
% OUTPUT
%    kf: the following fields are updated:
%       xi: 21x1 a priori state vector (updated).
%       xp: 21x1 a posteriori state vector (updated).
%		 		 v: 6x1 innovation vector. 
%        A: 21x21 state transition matrix.
%        K: 21x6  Kalman gain matrix.
%       Qd: 21x6  discrete process noise covariance.
%       Pi: 21x21 a priori error covariance.
%       Pp: 21x21 a posteriori error covariance.  
%        S: 6x6  innovation (or residual) covariance.
%%

% PREDICTION STEP

kf = kf_prediction(kf, dt);

% UPDATE STEP

kf = kf_update(kf);

end
