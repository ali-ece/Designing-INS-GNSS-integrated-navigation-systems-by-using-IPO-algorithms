% Ali Mohammadi_INS/GNSS

% navego_example_normality_test: example of how to use NaveGo functions for 
% test normality of a data vector

clc
clear
close all
matlabrc

format SHORTE

addpath ./
addpath ./../

%% TEST A GAUSSIAN DISTRIBUTION

X = randn(10000,1);

[pd, ha] = normality_test (X);

if ~( ha )    
    disp('navego_normality_test: data under analysis comes from a normal distribution.');
    
else
    disp('navego_normality_test: data under analysis does not come from a normal distribution.');
    
end

figure
plot_histogram (X, pd)
title ('HISTOGRAM')

figure
r = plot_cdf (X, pd)
title('NORMAL CUMULATIVE DISTRIBUTION')

fprintf('navego_normality_test: RMSE between ideal CDF and real CDF is %f \n', r)

%% TEST A UNIFORM DISTRIBUTION

Y = rand(10000,1);

[pd, ha] = normality_test (Y);

if ~( ha )    
    disp('navego_normality_test: Data under analysis comes from a normal distribution.');
    
else
    disp('navego_normality_test: data under analysis does not come from a normal distribution.');
    
end

figure
plot_histogram (Y, pd)
title ('HISTOGRAM')

figure
r = plot_cdf (X, pd)
title('NORMAL CUMULATIVE DISTRIBUTION')

fprintf('navego_normality_test: RMSE between ideal CDF and real CDF is %f \n', r)


