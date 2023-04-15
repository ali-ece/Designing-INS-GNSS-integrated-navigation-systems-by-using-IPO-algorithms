function DCMbn_n = dcm_update(DCMbn, euler)
% Ali Mohammadi_INS/GNSS

% dcm_update: updates  body-to-nav DCM.
%
% INPUT:
%   DCMbn,	3x3 body-to-nav DCM.
%   euler,	3x1 Euler angles (rad).
%
% OUTPUT:
%   DCMbn_n,    3x3 updated DCM body-to-nav.
%%

S = skewm(euler);
magn = norm(euler);

if magn == 0,
    
    A = eye(3);
else
    % A(k), Eq. 11.10, p. 312.
    A = eye(3) + (sin(magn)/magn) * S + ((1-cos(magn))/(magn^2)) * S * S;
end

% Eq. 11.4, p. 311.
DCMbn_n = DCMbn * A;
