function euler = dcm2euler(DCMbn)
% Ali Mohammadi_INS/GNSS

% dcm2euler: converts from body-to-nav DCM to Euler angles.
%
% INPUT
%   DCMbn: 3x3 body-to-nav DCM.
%
% OUTPUT
%   euler: 3x1 Euler angles [roll pitch yaw] (rad, rad, rad).
%%

phi   =  atan( DCMbn(3,2) ./ DCMbn(3,3) ); % roll
theta = -asin( DCMbn(3,1) );                % pitch
psi   =  atan2( DCMbn(2,1), DCMbn(1,1) );  % yaw

euler = [phi theta psi];

end
