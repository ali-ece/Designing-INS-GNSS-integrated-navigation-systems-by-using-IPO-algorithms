% Ali Mohammadi_INS/GNSS

% Convergences of algorithms for Iteration=200;

clc;clear all;close all;
figure;

%% GA
load('C:\...\Optimization Results\GA\GA(2)_it=200.mat')
plot((1:18:200),BEST(1:18:200),'m-x','LineWidth',4,'MarkerSize',10);
hold on

%% PSO
clear all;
load('C:\...\Optimization Results\PSO\PSO(2)_it=200.mat')
plot((1:18:200),gbestcost(1:18:200),'c:d','LineWidth',4,'MarkerSize',10);
hold on

%% IPO
load('C:\...\Optimization Results\IPO\IPO(2)_it=200.mat')
plot((1:18:200),bests(1:18:200),'r-.<','LineWidth',4,'MarkerSize',10);
hold on

%% MIPO
clear all;
load('C:\...\Optimization Results\MIPO\MIPO(2)_it=200.mat')
plot((1:18:200),bests(1:18:200),'b:>','LineWidth',4,'MarkerSize',10);
hold on

%% SIPO
clear all;
load('C:\...\Optimization Results\SIPO\SIPO(2)_it=200.mat')
plot((1:18:200),BestsCnvg(index,(1:18:200)),'g--v','LineWidth',4,'MarkerSize',10);
hold on

%% IIPO
clear all;
load('C:\...\Optimization Results\IIPO\IIPO(2)_it=200.mat')
plot((1:18:200),BestsCnvg(index,(1:18:200)),'k:^','LineWidth',4,'MarkerSize',10);
hold on

%%
legend('GA','PSO','IPO','MIPO','SIPO','IIPO')
xlabel('Iterations')
ylabel('Fitness')
% title('Convergence Curves'); 
hold off
