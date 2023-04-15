function  kf = kf_update( kf )
% Ali Mohammadi_INS/GNSS

% kalman: Measurement update part of the Kalman filter algorithm.
%
% INPUT
%   kf: data structure with at least the following fields:
%       xi: 21x1 a priori state vector.
%       Pi: 21x21 a priori error covariance.
%        z: 6x1 innovations vector.
%        H: 6x21 observation matrix.
%        R: 6x6  observation noise covariance.
%
% OUTPUT
%    kf: the following fields are updated:
%       xp: 21x1 a posteriori state vector (updated).
%       Pp: 21x21 a posteriori error covariance (updated).  
%		 		 v: 6x1 innovation vector. 
%        K: 21x6  Kalman gain matrix.
%        S: 6x6  innovation (or residual) covariance.
%%
% I = eye(size(kf.F));

% Step 3, update Kalman gain
kf.S = (kf.R + kf.H * kf.Pi * kf.H');				% Innovations covariance matrix
kf.v =  kf.z - kf.H * kf.xi; 						% Innovations vector
kf.K = (kf.Pi * kf.H') * (kf.S)^(-1) ;				% Kalman gain matrix

% Step 4, update the a posteriori state vector xp
kf.xp = kf.xi + kf.K * kf.v; 

% Step 5, update the a posteriori covariance matrix Pp
kf.Pp = kf.Pi - kf.K * kf.S *  kf.K';                
% J = (I - S.K * S.H);                          % Joseph stabilized version     
% S.Pp = J * S.Pi * J' + S.K * S.R * S.K';      % Alternative implementation
kf.Pp =  0.5 .* (kf.Pp + kf.Pp');               % Force Pi to be symmetric matrix

end
