% Ali Mohammadi_INS/GNSS

% Convergences of algorithms for Iteration=400;

clc;clear all;close all;
figure;

%% GA
load('C:\...\Optimization Results\GA\GA(4)_it=400.mat')
plot((1:33:400),BEST(1:33:400),'m-x','LineWidth',4,'MarkerSize',10);
hold on

%% PSO
clear all;
load('C:\...\Optimization Results\PSO\PSO(4)_it=400.mat')
plot((1:36:400),gbestcost(1:36:400),'c:d','LineWidth',4,'MarkerSize',10);
hold on

%% IPO
load('C:\...\Optimization Results\IPO\IPO(4)_it=400.mat')
plot((1:19:400),bests(1:19:400),'r-.<','LineWidth',4,'MarkerSize',10);
hold on

%% MIPO
clear all;
load('C:\...\Optimization Results\MIPO\MIPO(4)_it=400.mat')
plot((1:21:400),bests(1:21:400),'b:>','LineWidth',4,'MarkerSize',10);
hold on

%% SIPO
clear all;
load('C:\...\Optimization Results\SIPO\SIPO(4)_it=400.mat')
plot((1:21:400),BestsCnvg(index,(1:21:400)),'g--v','LineWidth',4,'MarkerSize',10);
hold on

%% IIPO
clear all;
load('C:\...\Optimization Results\IIPO\IIPO(4)_it=400.mat')
plot((1:21:400),BestsCnvg(index,(1:21:400)),'k:^','LineWidth',4,'MarkerSize',10);
hold on

%%
legend('GA','PSO','IPO','MIPO','SIPO','IIPO')
xlabel('Iterations')
ylabel('Fitness')
% title('Convergence Curves'); 
hold off
