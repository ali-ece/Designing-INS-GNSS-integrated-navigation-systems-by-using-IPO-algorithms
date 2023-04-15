% Ali Mohammadi_INS/GNSS

% Convergences of algorithms for Iteration=300;

clc;clear all;close all;
figure;

%% GA
load('C:\...\Optimization Results\GA\GA(3)_it=300.mat')
plot((1:23:300),BEST(1:23:300),'m-x','LineWidth',4,'MarkerSize',10);
hold on

%% PSO
clear all;
load('C:\...\Optimization Results\PSO\PSO(3)_it=300.mat')
plot((1:23:300),gbestcost(1:23:300),'c:d','LineWidth',4,'MarkerSize',10);
hold on

%% IPO
load('C:\...\NaveGo\Optimization Results\IPO\IPO(3)_it=300.mat')
plot((1:23:300),bests(1:23:300),'r-.<','LineWidth',4,'MarkerSize',10);
hold on

%% MIPO
clear all;
load('C:\...\Optimization Results\MIPO\MIPO(3)_it=300.mat')
plot((1:23:300),bests(1:23:300),'b:>','LineWidth',4,'MarkerSize',10);
hold on

%% SIPO
clear all;
load('C:\...\Optimization Results\SIPO\SIPO(3)_it=300.mat')
plot((1:23:300),BestsCnvg(index,(1:23:300)),'g--v','LineWidth',4,'MarkerSize',10);
hold on

%% IIPO
clear all;
load('C:\...\Optimization Results\IIPO\IIPO(3)_it=300.mat')
plot((1:23:300),BestsCnvg(index,(1:23:300)),'k:^','LineWidth',4,'MarkerSize',10);
hold on

%%
legend('GA','PSO','IPO','MIPO','SIPO','IIPO')
xlabel('Iterations')
ylabel('Fitness')
% title('Convergence Curves'); 
hold off
