% Ali Mohammadi_INS/GNSS

% for Rep=1:100
clc
clear all
close all
tic
% format long % short % shortg
% format short
%% Initialize Parameters

% glocal         = 0: Global search, 1: Local search
% localdist: maximum distance used for choosing local balls within it
stallgenlimit  = 100       ;
TolFun         = 0          ;
% Na             = 'testfunc' ;
localnum       = 3          ;
glocal         = 0          ;
% cont           = num2str(1) ;
% fitnessfunc    = [Na, cont] ;
plots          = 1          ;
numofruns      = 100       ;
numofdims      = 18         ;      
numofballs     = 50         ;     
        c1     = 0.3893179174                       ;
        c2     = 2.9512227061                       ;
        shift1 = 104.5566231873                     ;
        shift2 = 367.0491333246                     ;
        scale1 = 0.1452857433                       ;
        scale2 = 0.900190043                        ;
Xmininit       = [0 0 0 0   0   0   1e-10 1e-10 1e-10 1e-10 1e-10 1e-10 1e-10 1e-10 1e-10 1e-10 1e-10 1e-10] ;  %%%% Define lowband
Xmaxinit       = [1 1 1 100 100 100 1     1     1     1     1     1     1     1     1     1     1     1    ] ;  %%%% Define upperband
% Xmininit       = repmat(1e-10, 1, numofdims)     
% Xmaxinit       = repmat(100, 1, numofdims)          

%% Loop Main

% fitnessfunc = str2func(fitness1_ipo);
bestfit = Inf ; % stores previous total best
Neval   = 0   ; % number of evaluating fitness function% 
% expanding Xmin, Xmax to cover all balls
Xmin = repmat(Xmininit, numofballs, 1) ;
Xmax = repmat(Xmaxinit, numofballs, 1) ;

% generating initial balls
% an option to generate custom initial balls can be added later
X = Xmin + (Xmax - Xmin) .* rand(numofballs, numofdims) ;

% initializing balls acceleration
A = zeros(numofballs, numofdims) ;

% initializes some variables for displaying the results
meanfits = zeros(numofruns, 1);
bests    = zeros(numofruns, 1);
worsts   = zeros(numofruns, 1);
X;
%%%**********************************************************************
heights  = fitness1_ipo(X);

Neval                       = Neval + numofballs  ;
[tmpbestfit, tmpbestfitidx] = min(heights)        ;
bestfit                     = tmpbestfit          ;
bestpop                     = X(tmpbestfitidx, :) ;
stallgenctrl                = 0                   ;
t                           = 1                   ;

% if plots
%     hold on;
% end
%% Main loop
while ((t <= numofruns) && (stallgenctrl <= stallgenlimit))
    % calculating the acceleration for each ball
    A(:, :) = 0;
    
    % Choosing global or local algorithm
    % glocal = 0: Global search, 1: Local search
    
    if glocal
        % local version
        for i = 1:numofballs
            dists = dist(X(i, :), X');
            [~, localind] = sort(dists);
            localind = localind(2:localnum + 1);
            
            for j = 1:localnum
                dheight = heights(localind(j)) - heights(i);
                
                % uses better balls to estimate the slope and calculate the
                % acceleration. In addition, it ensures (X(i, :) - X(j, :)) > 0
                % for all dimensions.
                if dheight < 0
                    A(i, :) = A(i, :) + sin(atan(dheight ./ (X(i, :) - X(localind(j), :))));
%                     A(i, :) = A(i, :) + sin(abs(dheight)./(sqrt(((dheight).^2)+((X(i, :) - X(j, :)).^2))));
                end
            end
        end
    else
        % global version
        for i = 1:numofballs
            for j = 1:numofballs
                dheight = heights(j) - heights(i);
                
                % uses better balls to estimate the slope and calculate the
                % acceleration. In addition, it ensures (X(i, :) - X(j, :)) > 0
                % for all dimensions.
                if dheight < 0
                    A(i, :) = A(i, :) + sin(atan(dheight ./ (X(i, :) - X(j, :))));
%                     A(i, :) = A(i, :) + sin(abs(dheight)./(sqrt(((dheight).^2)+((X(i, :) - X(j, :)).^2))));
                end
            end
        end
    end
    
    % sigmoid method for changing coefficient:
    % higher c1: faster convergence in first steps, worst local search
    % lower c1: slower convergence and better global search in first steps,
    % better local search
    % c2 results to better local search
    k1 = c1 ./ (1 + exp((t - shift1) .* scale1));
    k2 = c2 ./ (1 + exp(-(t - shift2) .* scale2));

    % updating balls
    besttoX = repmat(bestpop, numofballs, 1) - X;
    X = X + k1 .* rand(numofballs, numofdims) .* A + ...
        k2 .* rand(numofballs, numofdims) .* besttoX;

    % ensures that all balls lie in the problem's boundaries
    tmpmaxchk = X > Xmax;
    tmpminchk = X < Xmin;
    X = X .* ~(tmpmaxchk | tmpminchk) + Xmax .* tmpmaxchk + Xmin .* tmpminchk;
    
    % evaluates fitness of each ball
    
    %%%*******************************************************************
heights = fitness1_ipo(X);
    %%%**********************************************************************
    
    Neval = Neval + numofballs;

    % finding and storing the global best ball and its fitness
    [tmpbestfit, tmpbestfitidx] = min(heights);
    
    if abs(tmpbestfit - bestfit) < TolFun
        stallgenctrl = stallgenctrl + 1;
    else
        stallgenctrl = 0;
    end
    
    if tmpbestfit < bestfit
        bestfit = tmpbestfit;
        bestpop = X(tmpbestfitidx, :);
    end
      
    % updating variables for displaying the results
    meanfits(t) = mean(heights) ;
    bests(t)    = bestfit       ;
    worsts(t)   = max(heights)  ;
     
    %%
    if plots
        disp(['Iteration ' num2str(t) '  :BestCost= ' num2str(bests(t))]);
%         t
%         plot(t, bests(t), '.r','LineWidth',1);
% %       legend('bests - ipo')
%         xlabel('Iteration')
%         ylabel('Fitness')
%         plot(t, meanfits(t), '.b','LineWidth',4);
%         legend('best','mean')
%         xlabel('Iteration')
%         ylabel('Fitness')
% %         plot(t, worsts(t), '.r');
%         figure(gcf);
%         hold on
    end
    t = t+1
end
%% Implementation of  *******************************

disp([ ' Best Solution = '  num2str(bestpop)])
disp([ ' Best Fitness = '  num2str(bests(t-1))])
%disp([ ' Time = '  num2str(toc)])
Time = toc/3600
% figure(1);
% plot(bests,'r','LineWidth',2);
% hold on
% plot(meanfits,'b','LineWidth',1);
% legend('best','mean')
% xlabel('Iteration')
% ylabel('Fitness')
% title('IPO');
% hold off

fitness2(bestpop)
bestpop