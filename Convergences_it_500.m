% Ali Mohammadi_INS/GNSS

% Convergences of algorithms for Iteration=500;

clc;clear all;close all;
figure;

%% GA
load('C:\...\Optimization Results\GA(5)_it=500.mat')
plot((1:83:500),BEST(1:83:500),'m-x','LineWidth',4,'MarkerSize',10);
hold on

%% PSO
clear all;
load('C:\...\Optimization Results\PSO\PSO(5)_it=500.mat')
plot((1:16:500),gbestcost(1:16:500),'c:d','LineWidth',4,'MarkerSize',10);
hold on

%% IPO
load('C:\...\Optimization Results\IPO\IPO(5)_it=500.mat')
plot((1:31:500),bests(1:31:500),'r-.<','LineWidth',4,'MarkerSize',10);
hold on

%% MIPO
clear all;
load('C:\...\Optimization Results\MIPO\MIPO(5)_it=500.mat')
plot((1:33:500),bests(1:33:500),'b:>','LineWidth',4,'MarkerSize',10);
hold on

%% SIPO
clear all;
load('C:\...\Optimization Results\SIPO\SIPO(5)_it=500.mat')
plot((1:45:500),BestsCnvg(index,(1:45:500)),'g--v','LineWidth',4,'MarkerSize',10);
hold on

%% IIPO
clear all;
load('C:\...\Optimization Results\IIPO\IIPO(5)_it=500.mat')
plot((1:71:500),BestsCnvg(index,(1:71:500)),'k:^','LineWidth',4,'MarkerSize',10);
hold on

%%
legend('GA','PSO','IPO','MIPO','SIPO','IIPO')
xlabel('Iterations')
ylabel('Fitness')
% title('Convergence Curves'); 
hold off
