function euler = qua2euler(qin)
% Ali Mohammadi_INS/GNSS

% qua2euler: transforms quaternion to Euler angles.
%
% INPUT
%   qin: 4x1 quaternion.
%
% OUTPUT
%   euler: 3x1 Euler angles [roll pitch yaw] (rad, rad, rad).
%%

% Quaternion format from Crassidis' book.

DCMbn = qua2dcm(qin);

phi   = atan2( DCMbn(3,2), DCMbn(3,3) );    % roll
theta = asin (-DCMbn(3,1) );                % pitch
psi   = atan2( DCMbn(2,1), DCMbn(1,1) );    % yaw

euler = [phi theta psi];

end
