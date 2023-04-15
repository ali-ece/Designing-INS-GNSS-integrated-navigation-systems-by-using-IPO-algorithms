% Ali Mohammadi_INS/GNSS
%%%%%%%% Genetic Algorithm %%%%%%%%%%
clc
clear
%close all
tic
format shortG

%% parameters setting

nvar = 18                 ;

lb = [0 0 0 0   0   0   1e-10 1e-10 1e-10 1e-10 1e-10 1e-10 1e-10 1e-10 1e-10 1e-10 1e-10 1e-10] ;  %%%% Define lowband
ub = [1 1 1 100 100 100 1     1     1     1     1     1     1     1     1     1     1     1    ] ;  %%%% Define upperband

popsize = 50  ;          %%%% Define Initialize Population
maxiter = 100 ;          %%%% Maximum Of Iteration(Repeats)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pc     = 0.95                    ; %%%% Probability Of Cross Over
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ncross = 2*round((popsize*pc)/2) ; %% Define Number Of gene For Cross Over
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pm     = 0.05                    ; %%%% Probability Of Mutation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nmut   = round(popsize*pm)       ; %% Define Number Of gene For Mutation

%% initial population algorithm

emp.var = [] ;
emp.fit = [] ;

pop     = repmat(emp,popsize,1) ; %%Define a structure with 50 array to population

for i=1:popsize
  
    pop(i).var = lb+rand(1,nvar).*(ub-lb) ; %%Random Initialize Variable Of Population 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    pop(i).fit = fitness1(pop(i).var)     ;
    
end

[value,index] = min([pop.fit]) ;    %% Save Best Fitness In Global Population
gpop          = pop(index)     ;

%% main loop algorithm

BEST = zeros(maxiter,1) ;             %% Build Best Matrix For All Iteration

for iter = 1:maxiter

   % crossover
   crosspop = repmat(emp,ncross,1)           ;
   crosspop = crossover(crosspop,pop,ncross) ;%Doing Cross OverToFunction
   
   
   % mutation
   mutpop   = repmat(emp,nmut,1)                           ;   %% Doing Mutation To Function
   mutpop   = mutation(mutpop,pop,nvar,nmut,popsize,lb,ub) ;
  
  
   [pop]    = [pop;crosspop;mutpop] ; 
   
   [value,index] = sort([pop.fit]) ; 
   pop           = pop(index)      ;
   gpop          = pop(1)          ;
   pop           = pop(1:popsize)  ; 
    
   
BEST(iter)       = gpop.fit ;

disp([' Iter = ' num2str(iter)  ' BEST = ' num2str(BEST(iter))]);
% iter
end

%% results algorithm

disp([ ' Best Solution = '  num2str(gpop.var)])
disp([ ' Best Fitness = '  num2str(gpop.fit)])
Time = toc/3600
% time = disp([ ' Time = '  num2str(toc)])
figure(1)
plot(BEST,'m','LineWidth',2)
hold on
xlabel('Iteration')
ylabel('Fitness')
legend('BEST (GA) - Black Color')
title('GA-Continuous')
display(BEST(iter))

fitness2(gpop.var)
gpop.var
