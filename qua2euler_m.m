function euler = qua2euler_m(qin)
% Ali Mohammadi_INS/GNSS

% qua2euler: transforms a quaternion matrix to Euler angles matrix.
%
% INPUT
%   qin: Nx4 quaternions ordered by column.
%
% OUTPUT
%   euler: Nx3 Euler angles ordered by column, [roll pitch yaw] (rad, rad, rad).
%%

% Quaternion format from Crassidis' book.

[~,m] = size(qin);

% If input is not a Nx4 matrix...
if(m ~= 4)
    qin = qin';
end

qua = zeros(size(qin));

qua(:,1) = qin(:,4);
qua(:,2) = qin(:,1);
qua(:,3) = qin(:,2);
qua(:,4) = qin(:,3);

% ZYX rotation sequence
c1 = 2.*(qua(:,2).*qua(:,3) + qua(:,1).*qua(:,4));
c2 = qua(:,1).^2 + qua(:,2).^2 - qua(:,3).^2 - qua(:,4).^2;

c3 = -2.*(qua(:,2).*qua(:,4) - qua(:,1).*qua(:,3));

c4 = 2.*(qua(:,3).*qua(:,4) + qua(:,1).*qua(:,2));
c5 = qua(:,1).^2 - qua(:,2).^2 - qua(:,3).^2 + qua(:,4).^2;

psi = atan2( c1, c2 );  % yaw
theta = asin( c3 );     % pitch
phi = atan2( c4, c5 );  % roll

euler = [phi theta psi];

end
