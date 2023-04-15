function pos_n = pos_update(pos, vel, dt)
% Ali Mohammadi_INS/GNSS

% pos_update: updates position in the navigation frame (lat, lon, h).
%
% INPUT:
%   pos,    3x1 position vector [lat lon h] (rad, rad, m).
%   vel,    3x1 NED velocities (m/s).
%   dt,     sampling interval.
%
% OUTPUT:
%   pos,    3x1 updated position vector [lat lon h] (rad, rad, m).
%% 

lat = pos(1); 
lon = pos(2); 
h   = pos(3);
vn  = vel(1);
ve  = vel(2);
vd  = vel(3);

%% Altitude

h_n  = h - (vd) * dt;

if h_n < 0
    h_n = abs(h);
    warning('pos_update: altitude is negative.')
end

%% Latitude

[RM,~] = radius(lat);

vn_c = vn / (RM + h_n);

lat_n = lat + (vn_c) * dt;

%% Longitude

[~, RN] = radius(lat_n);

ve_c  = ve / ((RN + h_n) * cos (lat_n));

lon_n = lon + (ve_c) * dt;

%% Position update

pos_n = [lat_n lon_n h_n];

end
