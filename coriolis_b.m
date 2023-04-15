function cor_b = coriolis_b(lat, vel, h, DCMnb)
% Ali Mohammadi_INS/GNSS

% coriolis_b: projects Coriolis forces from navigation frame to the body frame
%
% INPUT
%		lat: Nx1 latitudes (radians).
%		vel: Nx3 NED velocities [N E D](m/s, m/s, m/s).
%   h:   Nx1 altitude (meters).
%   DCMnb: Nx9 matrix with nav-to-body direct cosine matrix (DCM). 
%		Each row contains [a11 a21 a31 a12 a22 a32 a13 a23 a33] elements 
%		from each DCM.
%
% OUTPUT
%		cor_b: Nx3 Coriolis forces in the body frame [X Y Z] (m/s^2, m/s^2, m/s^2).
%%

kn = max(size(lat)); 

cor_b = zeros(kn, 3);

for i = 1:kn
   
    dcm = reshape(DCMnb(i,:), 3, 3); 
    omega_en_N = transportrate(lat(i), vel(i,1), vel(i,2), h(i));
    omega_ie_N = earthrate(lat(i));

    S = skewm(vel(i,:));
    cor_n = S * (omega_en_N + 2*omega_ie_N);

    corb =  dcm * cor_n; 
    cor_b(i,:) = (corb);
end
