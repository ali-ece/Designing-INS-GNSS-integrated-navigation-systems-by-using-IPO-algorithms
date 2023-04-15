% Ali Mohammadi_INS/GNSS

clc
clear all
close all
tic
% format short
%% Initialize Parameters

k1damp = 0.05  ;   %0.11  0.005    0.004
k2damp = .9     ;  % 2    1    0.9
k1     = 1     ;
k2     = 1     ;

% glocal = 0: Global search, 1: Local search
% localdist: maximum distance used for choosing local balls within it
stallgenlimit = 100  ;
TolFun        = inf ;
% Na = 'testfunc';
localnum = 3 ;
glocal   = 0 ;
% cont = num2str(1);
% fitnessfunc = [Na, cont];
plots      = 1   ;
numofruns  = 100 ;
numofdims  = 18  ;
numofballs = 50  ; 
   
Xmininit   = [0 0 0 0   0   0   1e-10 1e-10 1e-10 1e-10 1e-10 1e-10 1e-10 1e-10 1e-10 1e-10 1e-10 1e-10] ;  %%%% Define lowband
Xmaxinit   = [1 1 1 100 100 100 1     1     1     1     1     1     1     1     1     1     1     1    ] ;  %%%% Define upperband
% Xmininit       = repmat(1e-10, 1, numofdims)     
% Xmaxinit       = repmat(100, 1, numofdims)

%% Initialization
% fitnessfunc = str2func(fitnessfunc);
bestfit = Inf ; % stores previous total best
Neval   = 0   ; % number of evaluating fitness function

% expanding Xmin, Xmax to cover all particles
Xmin = repmat(Xmininit, numofballs, 1) ;
Xmax = repmat(Xmaxinit, numofballs, 1) ;

% generating initial particles
% an option to generate custom initial particles can be added later
X = Xmin + (Xmax - Xmin) .* rand(numofballs, numofdims) ;

% initializing particles acceleration
A = zeros(numofballs, numofdims);

% initializes some variables for displaying the results
meanfits = zeros(numofruns, 1) ;
bests    = zeros(numofruns, 1) ;
worsts   = zeros(numofruns, 1) ;

heights                     = fitness1_ipo(X)     ;
[tmpbestfit, tmpbestfitidx] = min(heights)        ;
bestfit                     = tmpbestfit          ;
bestpop                     = X(tmpbestfitidx, :) ;

%% Main loop
for t = 1:numofruns
    % calculating the acceleration for each particle
    A(:, :) = 0;
    for i = 1:numofballs
        for j = 1:numofballs
            dheight = heights(j) - heights(i);
            
            % uses better particles to estimate the slope and calculate the
            % acceleration. In addition, it ensures (X(i, :) - X(j, :)) > 0
            % for all dimensions.
            if dheight < 0
                A(i, :) = A(i, :) + sin(atan(dheight ./ (X(i, :) - X(j, :))));
            end
        end
    end
    
    % sigmoid method for changing coefficient:
    % higher c1: faster convergence in first steps, worst local search
    % lower c1: slower convergence and better global search in first steps,
    % better local search
    % c2 results to better local search
%     k1 = c1 ./ (1 + exp((t - shift1) .* scale1));
    k1 = k1damp*( (numofruns - t) / numofruns);             

%     k2 = c2 ./ (1 + exp(-(t - shift2) .* scale2));
    k2 = k2damp*( t / numofruns);
    
    % updating particles
    besttoX = repmat(bestpop, numofballs, 1) - X;
    X = X + k1 .* rand(numofballs, numofdims) .* A + ...
        k2 .* rand(numofballs, numofdims) .* besttoX;

    % ensures that all particles lie in the problem's boundaries
    tmpmaxchk = X > Xmax;
    tmpminchk = X < Xmin;
    X = X .* ~(tmpmaxchk | tmpminchk) + Xmax .* tmpmaxchk + Xmin .* tmpminchk;
    
    % evaluates fitness of each particle
    heights = fitness1_ipo(X);
    Neval = Neval + numofballs;

    % finding and storing the global best particle and its fitness
    [tmpbestfit, tmpbestfitidx] = min(heights);
    if tmpbestfit < bestfit
        bestfit = tmpbestfit;
        bestpop = X(tmpbestfitidx, :);
    end
    
    % updating variables for displaying the results
    meanfits(t) = mean(heights);
    bests(t) = bestfit;
    worsts(t) = max(heights);
   t 
end
%% Implementation of  *******************************

disp([ ' Best Solution = '  num2str(bestpop)])
disp([ ' Best Fitness = '  num2str(bests(t-1))])
disp([ ' Time = '  num2str(toc)])
Time = toc/3600
figure(1);
plot(bests,'r','LineWidth',2);
hold on
plot(meanfits,'b','LineWidth',1);
legend('best','mean')
xlabel('Iteration')
ylabel('Fitness')
title('IPO');
hold off

fitness2(bestpop)








