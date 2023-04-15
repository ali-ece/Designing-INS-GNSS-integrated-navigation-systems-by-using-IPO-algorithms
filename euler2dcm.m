function DCMnb = euler2dcm(euler)
% Ali Mohammadi_INS/GNSS

% euler2dcm: converts from Euler angles to DCM nav-to-body.
% 
% INPUT
%   euler: 3x1 Euler angles [roll pitch yaw] (rad, rad, rad).
%
% OUTPUT
%   DCMnb: 3x3 nav-to-body DCM.
%%

  phi = euler(1); theta = euler(2); psi = euler(3);

  C1 = [cos(psi)  sin(psi) 0; ...
        -sin(psi) cos(psi) 0; ...
         0     0   1];
     
  C2 = [cos(theta)  0  -sin(theta); ...
          0   1     0 ; ...
        sin(theta)  0   cos(theta)];
    
  C3 = [1   0    0;   ...
        0  cos(phi) sin(phi); ...
        0 -sin(phi) cos(phi)];  
 
  DCMnb = C3 * (C2 * C1);

end
