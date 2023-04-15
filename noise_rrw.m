function [rrw_n] = noise_rrw (rrw, dt, M)
% Ali Mohammadi_INS/GNSS

% noise_rrw: generates rate random walk noise.
%
% INPUT
%		rrw: 1x3 level of rate random walk.
%		dt: 1x1 sampling time.
%   M: 1x2 dimensionx of output vector.
%
% OUTPUT
%		rrw_n: M matrix with simulated rate random walk noise [X Y Z] 
%     (rad/s^2, rad/s^2, rad/s^2).
%%

rrw_n = zeros(M);
N = M(1);

for i=1:3
    
    b_noise = randn(N-1,1);
    
    for j=2:N
        rrw_n (j, i) = rrw_n(j-1, i) + rrw(i) * dt .* b_noise(j-1);
    end
end
