function vel_n = vel_update(fn, vel, omega_ie_n, omega_en_n, g, dt)
% Ali Mohammadi_INS/GNSS

% vel_update: updates velocity vector in the NED frame.
%
% INPUT
%   fn, 3x1 specific forces in the nav-frame.    
%   vel, 3x1 previous (old) velocity vector in the nav-frame. 
%   omega_ie_n, 3x1 Earth rate in the nav-frame.
%   omega_en_n, 3x1 transport rate in the nav-frame.
%   g, 1x1 gravity in the nav-frame.
%   dt, 1x1 integration time step.
%
% OUTPUT
%   vel_n, 3x1 velocity vector in the nav-frame.    
%%

S = skewm(vel);     % Skew matrix with velocities
 
coriolis = S * (omega_en_n + 2 * omega_ie_n);   % Coriolis 

fn_c = fn - coriolis - g;   % Corrected specific force in nav-frame

vel_n = vel + (fn_c' * dt);

end
