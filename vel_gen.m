function vel_ned = vel_gen(lat, lon, h, t)
% Ali Mohammadi_INS/GNSS

% vel_gen: generates NED velocities from llh position
%
% INPUT
%   lat: Nx1 latitude (radians).
%   lon: Nx1 longitude (radians).
%   h:   Nx1 altitude (m).
%   dt:  1x1 sampling time (s).
%
% OUTPUT
%   vel: Nx3 NED velocities [VN VE VD] (m/s, m/s, m/s).

%% Down Velocity 

idl = h < 0;

if any(idl)
    warning('vel_gen: negative altitude.')
end

vd = - diff_central(t, h);

%% North Velocity 

[RM, ~] = radius(lat(2:end-1));

vn_c = diff_central(t, lat);
vn = vn_c .* (RM + h(2:end-1));

%% East Velocity 

[~, RN] = radius(lat(2:end-1));

ve_c = diff_central(t, lon);
ve   = ve_c .* (RN + h(2:end-1)) .* cos (lat(2:end-1));

%% NED Velocity
  
vel = [vn ve vd];

vel_ned = my_sgolayfilt(vel);

end
