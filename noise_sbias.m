function [sbias_n] = noise_sbias (sbias, M)
% Ali Mohammadi_INS/GNSS

% noise_sbias: generates a random static bias error.
%
% INPUT
%		sbias: static bias from [-sbias sbias].
%		M: dimension of output vector.
%
% OUTPUT
%		sbias_n: Mx3 matrix with simulated static biases [X Y Z] (rad, rad, rad).
%%

a = -sbias;
b =  sbias;
ab_fix = (b' - a') .* rand(3,1) + a';
o = ones(M,1);

sbias_n = [ab_fix(1).* o   ab_fix(2).* o   ab_fix(3).* o];
