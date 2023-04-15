function [pd, ha, pa] = normality_test (samples)
% Ali Mohammadi_INS/GNSS

% normality_test: checks if samples come from a normal distribution using
% the Anderson-Darling goodness-of-fit hypothesis test.
%
% INPUT
%   samples: Nx1 samples to test.
%
% OUTPUT
%    pd: probality distribution object from ProbabilityDistribution class.
%    ha: = 0 => samples come from a normal distribution.
%        = 1 => samples do not come from a normal distribution.
%    pa: p-value.
%% Fit data to a normal disribution

pd = fitdist(samples, 'normal');

% sig = pd.sigma;
% mu  = pd.mu;
% ref = randn (1000,1) * sig + mu;

%% Test normality

% Anderson-Darling goodness-of-fit hypothesis test
[ha, pa, ~, ~] = adtest (samples,'Distribution', pd);

% Other normality tests
% [hk , pk] = kstest2 (samples, ref);           % Kolmogorov–Smirnov test
% [hz , pz] = ztest  (samples, mu, sig)
% [ht , pt] = ttest  (samples, mu)size(data)
% [hc , pc] = chi2gof(samples)
% [hj , pj] = jbtest (samples)
% [hk , pk] = kstest (samples, 'CDF', pd, 'Alpha',0.5)

end