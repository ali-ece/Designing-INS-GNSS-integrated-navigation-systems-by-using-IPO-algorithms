function cor_n = coriolis(lat, vel, h)
% Ali Mohammadi_INS/GNSS

% coriolis: calculates Coriolis forces in the navigation frame.
%
% INPUT:
%       lat: Mx1 latitude (radians).
%       vel: Mx3 NED velocities (m/s).
%         h: Mx1 altitude (m).
%
% OUTPUT:
%		cor_n: Mx1 Coriolis forces vector in the nav-frame (m/s^2).
%%

kn = max(size(lat)); 

cor_n = zeros(kn, 3);

for i = 1:kn
   
    omega_en_N = transportrate(lat(i), vel(i,1), vel(i,2), h(i));
    omega_ie_N = earthrate(lat(i));

    S = skewm(vel(i,:));
    cor_n(i,:) = (S * (omega_en_N + 2*omega_ie_N))'; 
end
