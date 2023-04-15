function [dbias_n] = noise_dbias (b_corr, b_dyn, dt, M)
% Ali Mohammadi_INS/GNSS

% noise_dbias: generates a dynamic bias perturbation.
%
% INPUT
%		b_corr:  1x3 correlation times.
%   b_dyn: 1x3 level of dynamic biases.
%   dt: 1x1 sampling time.
%		M: 1x2 dimension of output vector.
%
% OUTPUT
%		dbias_n: M matrix with simulated dynamic biases [X Y Z] 
%     (rad/s, rad/s, rad/s).
%%

% If correlation time is provided...
if (~isinf(b_corr))

    % Gauss-Markov process
    dbias_n = zeros(M);
    N = M(1);

    for i=1:3

        beta  = dt / ( b_corr(i) );
        sigma = b_dyn(i);
        a1 = exp(-beta);
        a2 = sigma * sqrt(1 - exp(-2*beta) );

        b_noise = randn(N-1,1); 
        
        for j=2:N
            dbias_n(j, i) = a1 * dbias_n(j-1, i) + a2 .* b_noise(j-1);
        end
    end
    
% If not...
else
    sigma = b_dyn;
    bn = randn(M);
    
    dbias_n = [sigma(1) .* bn(:,1), sigma(2) .* bn(:,2), sigma(3) .* bn(:,3)];
    
end
