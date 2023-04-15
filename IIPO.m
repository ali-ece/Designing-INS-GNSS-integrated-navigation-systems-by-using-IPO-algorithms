% Ali Mohammadi_INS/GNSS
%% Iteration-baed IPO (IIPO) algorithm for INS/GPS navigation

clc       ;
clear all ;
close all ;
% format shortg

prompt   = {'Please enter the number of run:'}       ;
title    = 'IIPO Algorithm'                          ;
dims     = [1 45]                                    ;
nline    = 1                                         ;
definput = {'1','a'}                                 ;
answer   = inputdlg(prompt,title,dims,definput)      ;
Run_Num  = answer(1,:)                               ;
Run_Num  = str2num(Run_Num{:})                       ;

prompt   = {'maxt','npop' ,'F','Beta','c','m_Ratio'}  ;
title    = 'IIPO parameters'                          ;
nline    = 1                                          ;
dims     = [1 45]                                     ;
definput = {'500','50' '1','2','1.75','0','a'}           ;
answer   = inputdlg(prompt,title,dims,definput)       ;
maxt     = answer(1,:); maxt    = str2num(maxt{:})    ;
npop     = answer(2,:); npop    = str2num(npop{:})    ;
F        = answer(3,:); F       = str2num(F{:})       ;
Beta     = answer(4,:); Beta    = str2num(Beta{:})    ;
c        = answer(5,:); c       = str2num(c{:})       ;
m_Ratio  = answer(6,:); m_Ratio = str2num(m_Ratio{:}) ;

n         = 0                          ;
Bests     = zeros(1       , Run_Num )  ; 
BestsPop  = zeros(Run_Num , 18       ) ; %varaible number
BestsCnvg = zeros(Run_Num , 500     )  ; % numofruns
RunTime   = zeros(1       , Run_Num )  ;
NoU_index = zeros(Run_Num , 1       )  ;
Stable    = 0                          ;
NoU       = 0                          ; % Number of Unstable filters

for n = 1:Run_Num
tic
n

%%
% Function_name               = 'F8'
% [lb,ub,dim,fobj]            = Get_Functions_details(Function_name);
% costfunction                = fobj;     

nvar    = 18       ; 
varsize = [1 nvar] ;
varmin = [0 0 0 0   0   0   1e-10 1e-10 1e-10 1e-10 1e-10 1e-10 1e-10 1e-10 1e-10 1e-10 1e-10 1e-10] ;  %%%% Define lowband
varmax = [1 1 1 100 100 100 1     1     1     1     1     1     1     1     1     1     1     1    ] ;  %%%% Define upperband
% varmin  = -1.2     ;
% varmax  = +1.2     ;

%% IIPO parameters
% npop    = 50;
% maxt    = 200;
%%
empty_ball.position     = [] ;
empty_ball.cost         = [] ;
empty_ball.velocity     = [] ;
empty_ball.acceleration = [] ;

ball             = repmat(empty_ball,npop,1) ;
globalbest.cost  = inf                       ;

for i = 1:npop
  
    
    ball(i).position       = unifrnd(varmin,varmax);
    ball(i).velocity       = zeros(varsize);
    ball(i).Acceleration   = zeros(varsize);
    ball(i).sbetter        = zeros(varsize);
    ball(i).mean           = zeros(varsize);
    ball(i).cost           = fitness1(ball(i).position);
    if ball(i).cost < globalbest.cost
       globalbest.position = ball(i).position;
       globalbest.cost     = ball(i).cost;    
   end
end

bests = zeros(maxt,1);
T     = m_Ratio.*maxt;  
%% 
for t = 1:maxt
     
    sumcost = 0;
    s       = 1;
    for i= 1:npop
        ball(i).sbetter = ball(i).position;
            for j= 1:npop
            df = ball(j).cost - ball(i).cost;
            if df < 0
               ball(i).sbetter = ball(i).sbetter + ball(j).position;
               s               = s+1;
            end
        end
        ball(i).mean         = ((ball(i).sbetter) ./ s);
       
        
        P_MEAN = F.*(maxt./t);          
        k1     = (1./t)^(Beta) ;             
        k2     = c ./ (1 + exp( - (t-T)));   
        
        ball(i).velocity    = globalbest.position-ball(i).position;      
        ball(i).Acceleration = P_MEAN .* ball(i).mean - ball(i).position; 
           
        ball(i).position = ball(i).position + ...
                          k1 .* (ball(i).Acceleration) .* rand(varsize)+...
                          k2 .* ball(i).velocity .* rand(varsize); 
        
        ball(i).position = min(max(ball(i).position,varmin),varmax);
        ball(i).cost     = fitness1(ball(i).position);
      
        if ball(i).cost < globalbest.cost
           globalbest.position  = ball(i).position;
           globalbest.cost      = ball(i).cost; 
        end
       bests(t) = globalbest.cost; 
       sumcost   = sumcost+ball(i).cost;
    end
    
disp(['Iteration' num2str(t) ':bestcost=' num2str(bests(t))]);
meanfits(t) = sumcost/npop;
t
end

BestsCnvg(n,:)      = bests               ;
Bests(n)            = bests(t-1)          ; 
BestsPop(n,:)       = globalbest.position ;
RunTime(n)          = toc                 ;

end
%         disp([' ']);
        disp([' ']);
        disp(['                   IIPO                         ']);
        disp(['-----------------------------------------------']);
        disp(['Number of run     = ' num2str(Run_Num)]);
        disp([' ']);
        disp([' ']);
        disp(['****************    Statistical indexes : Time    ****************']);
        disp(['------------------------------------------------']);
        disp(['Per run            = ' num2str(RunTime)]);
        disp(['Average            = ' num2str(mean(RunTime))]);
        disp(['Standard deviation = ' num2str(std(RunTime))]);
        disp(['Maximum            = ' num2str(max(RunTime))]);
        disp(['Minimum            = ' num2str(min(RunTime))]);
        
   
%         disp([' ']);
        disp([' ']);
        disp(['*****************   Statistical indexes : Fitness    ****************']);
        disp(['-----------------------------------------------']);
        disp(['Number of run      = ' num2str(Run_Num)]);
        disp(['Best cost per run  = ' num2str(Bests)]);
        disp(['Average            = ' num2str(mean(Bests))]);
        disp(['Standard deviation = ' num2str(std(Bests))]);
        disp(['Maximum            = ' num2str(max(Bests))]);
        disp(['Minimum            = ' num2str(min(Bests))]);       
       
%% IIPO *******************************

[minimum index] = min(Bests);
disp([ ' Best Solution = '  num2str(BestsPop(index,:))])

figure(1);
plot(BestsCnvg(index,:),'.b','LineWidth',1);
legend('Bests_IIPO')
xlabel('Iteration')
ylabel('Fitness')

fitness2(BestsPop(index,:))
legend('Bests_IIPO')