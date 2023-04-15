function rmse_err = plot_cdf (samples, pd)
% Ali Mohammadi_INS/GNSS

% plot_cdf: plots cumulative distribution function (CDF) from samples 
% (empirical CDF) and compares to inferred CDF (reference CDF)
%
% INPUT
%   samples: Nx1 samples.
%   pd: probality distribution object from ProbabilityDistribution class.
%
% OUTPUT
%   rmse_err: RMSE between the two curves.
%   figure with real CDF and ideal CDF.
%% PLOT PARAMETERS

font_tick = 12;
font_label = 16;
line_wd = 3;

blue_new = [0 0.4470 0.7410];
orange_new = [0.8500 0.3250 0.0980];

%% Only plot 1-sigma elements

M = 1;

sig = pd.sigma;
mu = pd.mu;

edge = abs(M * sig + mu);
idx = find (samples > -edge, 1, 'first');
fdx = find (samples <  edge, 1, 'last');
samples = samples(idx:fdx);

%% IDEAL CDF

N = length(samples);
x = linspace(min(samples), max(samples), N );
ideal_cdf = normcdf(x, mu, sig)';

%% REAL CDF

x_sort = sort(samples);
real_cdf = ( (1:N) - 0.5)' ./ N;

% Root mean squared error
rmse_err = rmse(ideal_cdf, real_cdf);

%% PLOT

h = plot(x, ideal_cdf, '--',  'LineWidth', 2, 'Color', orange_new);
hold on

s = stairs(x_sort, real_cdf,'-.', 'LineWidth', 2, 'Color', blue_new);

legend([h, s], 'Ideal CDF', 'Real CDF' )

xl = xlabel('Samples');
% yl = ylabel('Cumulative probability (CDF)');

grid
hold off

set(h,'Linewidth', line_wd );
set(gca, 'YTickMode', 'auto', 'FontSize', font_tick);

set(xl,'FontSize', font_label);
% set(yl,'FontSize', font_label);

end