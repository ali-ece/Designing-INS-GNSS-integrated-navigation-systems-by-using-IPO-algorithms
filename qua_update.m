function qua_n = qua_update(qua, wb_n, dt)
% Ali Mohammadi_INS/GNSS

% qua_update: updates quaternions.
%
% INPUT:
%   qua,	4x1 quaternion.
%   wb_n,	3x1 incremental turn rates in body-frame (rad/s).
%   dt,     1x1 IMU sampling interval (s).
%
% OUTPUT:
%   qua_n,      4x1 updated quaternion.
%%

wnorm = norm(wb_n);

if wnorm == 0,
    
    qua_n = qua;
else
    
    co=cos(0.5*wnorm*dt);
    si=sin(0.5*wnorm*dt);
    
    n1 = wb_n(1)/wnorm;
    n2 = wb_n(2)/wnorm;
    n3 = wb_n(3)/wnorm;
    
    qw1 = n1*si;
    qw2 = n2*si;
    qw3 = n3*si;
    qw4 = co;
    
    Om=[ qw4  qw3 -qw2 qw1;
        -qw3  qw4  qw1 qw2;
         qw2 -qw1  qw4 qw3;
        -qw1 -qw2 -qw3 qw4];
    
    qua_n = Om * qua;
end

end
