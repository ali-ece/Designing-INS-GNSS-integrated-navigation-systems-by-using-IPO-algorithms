function deltha = gyro_gen_delta(DCMnb, t)
% Ali Mohammadi_INS/GNSS

% gyro_gen_delta: calculates gyros delta angles.
%
% INPUT
%   DCMnb: Nx9 matrix with nav-to-body direct cosine matrix (DCM). 
%		Each row contains [a11 a21 a31 a12 a22 a32 a13 a23 a33] elements 
%		from each DCM.
%		t: Mx1 time vector (s).
%
% OUTPUT
%		deltha: Mx3 gyros delta angles [X, Y, Z] (rad, rad, rad).
%%

M = max(size(DCMnb));

% Preallocate

dphi   = zeros(M-1,1);
dtheta = zeros(M-1,1);
dpsi   = zeros(M-1,1);

% Calculate gyros delta angles.

for k = 2:M

  dcmnb = reshape(DCMnb(k,:), 3, 3); 
  dcmnb_old = reshape(DCMnb(k-1,:), 3, 3);  

  dPSI = (dcmnb_old * dcmnb') - eye(3);
   
  dphi(k-1,1)   = dPSI(3,2);
  dtheta(k-1,1) = dPSI(1,3);
  dpsi(k-1,1)   = dPSI(2,1); 
end

% Derivates

t_diff = diff(t);
deltha = [dphi./t_diff dtheta./t_diff dpsi./t_diff];

end
