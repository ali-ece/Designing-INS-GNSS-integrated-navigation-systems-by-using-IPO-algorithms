function g_b = gravity_b(lat, h, DCMnb)
% Ali Mohammadi_INS/GNSS

%  gravity_b: computes gravity vector in the b-frame.
%
% INPUT
%		lat: Nx1 latitudes (radians).
%		h: Nx1 altitudes (meters)
%   DCMnb: Nx9 matrix with nav-to-body direct cosine matrix (DCM). 
%		Each row contains [a11 a21 a31 a12 a22 a32 a13 a23 a33] elements 
%		from each DCM.
%
% OUTPUT
%		g_b: Nx1 gravity force in the body frame.
%%

kn = max(size(lat));
g_b = zeros(kn,3);

for i = 1:kn
    
    dcm = reshape(DCMnb(i,:), 3, 3);    
    g_n = gravity(lat(i), h(i));
    gb = dcm * g_n';    
    g_b(i,:) = gb';
end

end
