% Ali Mohammadi_INS/GNSS

% The boxplots of Estimated Values of Variables (the main diagonal of R...
% and Q matrices) for all Iterations and for all algorithms (GA, PSO, IPO, MIPO, SIPO, and IIPO)

clc; clear all; close all;
% figure ;
XX = zeros(90,6) ; % 1-Dim: 18(variables) * 5(Its.) = 90; 2-Dim: 6 Algs


%% GA

% Iteration == 100
load('C:\...\Optimization Results\GA\GA(1)_it=100.mat');
XX(1:18,1)  = gpop.var' ;
clearvars -except XX
% Iteration == 200
load('C:\...\Optimization Results\GA\GA(2)_it=200.mat');
XX(19:36,1) = gpop.var' ;
clearvars -except XX
% Iteration == 300
load('C:\...\Optimization Results\GA\GA(3)_it=300.mat');
XX(37:54,1) = gpop.var' ;
clearvars -except XX
% Iteration == 400
load('C:\...\Optimization Results\GA\GA(4)_it=400.mat')
XX(55:72,1) = gpop.var' ;
clearvars -except XX
% Iteration == 500
load('C:\...\Optimization Results\GA\GA(5)_it=500.mat')
XX(73:90,1) = gpop.var' ;
clearvars -except XX


%% PSO

% Iteration == 100
load('C:\...\Optimization Results\PSO\PSO(1)_it=100.mat');
XX(1:18,2)  = gbest(it,:)' ;
clearvars -except XX
% Iteration == 200
load('C:\...\Optimization Results\PSO\PSO(2)_it=200.mat');
XX(19:36,2) = gbest(it,:)' ;
clearvars -except XX
% Iteration == 300
load('C:\...\Optimization Results\PSO\PSO(3)_it=300.mat');
XX(37:54,2) = gbest(it,:)' ;
clearvars -except XX
% Iteration == 400
load('C:\...\Optimization Results\PSO\PSO(4)_it=400.mat')
XX(55:72,2) = gbest(it,:)' ;
clearvars -except XX
% Iteration == 500
load('C:\...\\Optimization Results\PSO\PSO(5)_it=500.mat')
XX(73:90,2) = gbest(it,:)' ;
clearvars -except XX


%% IPO

% Iteration == 100
load('C:\...\Optimization Results\IPO\IPO(1)_it=100.mat');
XX(1:18,3)  = bestpop' ;
clearvars -except XX
% Iteration == 200
load('C:\...\Optimization Results\IPO\IPO(2)_it=200.mat');
XX(19:36,3) = bestpop' ;
clearvars -except XX
% Iteration == 300
load('C:\...\Optimization Results\IPO\IPO(3)_it=300.mat');
XX(37:54,3) = bestpop' ;
clearvars -except XX
% Iteration == 400
load('C:\...\Optimization Results\IPO\IPO(4)_it=400.mat')
XX(55:72,3) = bestpop' ;
clearvars -except XX
% Iteration == 500
load('C:\...\Optimization Results\IPO\IPO(5)_it=500.mat')
XX(73:90,3) = bestpop' ;
clearvars -except XX


%% MIPO

% Iteration == 100
load('C:\...\Optimization Results\MIPO\MIPO(1)_it=100.mat');
XX(1:18,4)  = bestpop' ;
clearvars -except XX
% Iteration == 200
load('C:\...\\Optimization Results\MIPO\MIPO(2)_it=200.mat');
XX(19:36,4) = bestpop' ;
clearvars -except XX
% Iteration == 300
load('C:\...\Optimization Results\MIPO\MIPO(3)_it=300.mat');
XX(37:54,4) = bestpop' ;
clearvars -except XX
% Iteration == 400
load('C:\...\Optimization Results\MIPO\MIPO(4)_it=400.mat')
XX(55:72,4) = bestpop' ;
clearvars -except XX
% Iteration == 500
load('C:\...\Optimization Results\MIPO\MIPO(5)_it=500.mat')
XX(73:90,4) = bestpop' ;
clearvars -except XX


%% SIPO

% Iteration == 100
load('C:\...\Optimization Results\SIPO\SIPO(1)_it=100.mat');
XX(1:18,5)  = BestsPop(index,:)' ;
clearvars -except XX
% Iteration == 200
load('C:\...\Optimization Results\SIPO\SIPO(2)_it=200.mat');
XX(19:36,5) = BestsPop(index,:)' ;
clearvars -except XX
% Iteration == 300
load('C:\...\Optimization Results\SIPO\SIPO(3)_it=300.mat');
XX(37:54,5) = BestsPop(index,:)' ;
clearvars -except XX
% Iteration == 400
load('C:\...\Optimization Results\SIPO\SIPO(4)_it=400.mat')
XX(55:72,5) = BestsPop(index,:)' ;
clearvars -except XX
% Iteration == 500
load('C:\...\Optimization Results\SIPO\SIPO(5)_it=500.mat')
XX(73:90,5) = BestsPop(index,:)' ;
clearvars -except XX


%% IIPO

% Iteration == 100
load('C:\...\Optimization Results\IIPO\IIPO(1)_it=100.mat');
XX(1:18,6)  = BestsPop(index,:)' ;
clearvars -except XX
% Iteration == 200
load('C:\...\Optimization Results\IIPO\IIPO(2)_it=200.mat');
XX(19:36,6) = BestsPop(index,:)' ;
clearvars -except XX
% Iteration == 300
load('C:\...\Optimization Results\IIPO\IIPO(3)_it=300.mat');
XX(37:54,6) = BestsPop(index,:)' ;
clearvars -except XX
% Iteration == 400
load('C:\...\Optimization Results\IIPO\IIPO(4)_it=400.mat')
XX(55:72,6) = BestsPop(index,:)' ;
clearvars -except XX
% Iteration == 500
load('C:\...\Optimization Results\IIPO\IIPO(5)_it=500.mat')
XX(73:90,6) = BestsPop(index,:)' ;
clearvars -except XX

%% Boxplots 
figure(1);
boxplot(XX,'notch','on','labels',{'GA','PSO','IPO','MIPO','SIPO','IIPO'},'whisker',1);xlabel('Algorithms'); ylabel('Estimated Values');title('Boxplots of Estimated Values of Variables for All Algorithms');


