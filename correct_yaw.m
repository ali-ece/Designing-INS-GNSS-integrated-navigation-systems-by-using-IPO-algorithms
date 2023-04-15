function yaw_new = correct_yaw (yaw)
% Ali Mohammadi_INS/GNSS

% correct_yaw: guarantee that yaw angle is between -pi and pi.
%
% INPUT:
%   yaw, Nx1 vector (radians).
%
% OUTPUT:
%   yaw_new, Nx1 vector (radians).
%%

yaw_new = yaw;

idx = (yaw > pi);
yaw_new(idx) = yaw(idx) - 2*pi;

idx = (yaw < -pi);
yaw_new(idx) = yaw(idx) + 2*pi;

end
