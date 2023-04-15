% Ali Mohammadi_INS/GNSS

% Convergences of algorithms for Iteration=100;

clc;clear all;close all;
figure;

%% GA
load('C:\...\Optimization Results\GA\GA(1)_it=100.mat')
plot((1:9:100),BEST(1:9:100),'m-x','LineWidth',4,'MarkerSize',10);
hold on

%% PSO
clear all;
load('C:\...\Optimization Results\PSO\PSO(1)_it=100.mat')
plot((1:9:100),gbestcost(1:9:100),'c:d','LineWidth',4,'MarkerSize',10);
hold on

%% IPO
load('C:\...\Optimization Results\IPO\IPO(1)_it=100.mat')
plot((1:9:100),bests(1:9:100),'r-.<','LineWidth',4,'MarkerSize',10);
hold on

%% MIPO
clear all;
load('C:\...\Optimization Results\MIPO\MIPO(1)_it=100.mat')
plot((1:9:100),bests(1:9:100),'b:>','LineWidth',4,'MarkerSize',10);
hold on

%% SIPO
clear all;
load('C:\...\Optimization Results\SIPO\SIPO(1)_it=100.mat')
plot((1:9:100),BestsCnvg(index,(1:9:100)),'g--v','LineWidth',4,'MarkerSize',10);
hold on

%% IIPO
clear all;
load('C:\...\Optimization Results\IIPO\IIPO(1)_it=100.mat')
plot((1:9:100),BestsCnvg(index,(1:9:100)),'k:^','LineWidth',4,'MarkerSize',10);
hold on

%%
legend('GA','PSO','IPO','MIPO','SIPO','IIPO')
xlabel('Iterations')
ylabel('Fitness')
% title('Convergence Curves'); 
hold off
