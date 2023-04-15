% Ali Mohammadi_INS/GNSS
% for Rep = 1:100

clc       ;
clear all ;
close all ;
tic       ;

npop = 50 ;
nvar = 18 ;
w    = 1  ;

maxit = 400     ;
wdamp = 0.99     ;
c1    = 2        ;
c2    = 2        ;
xmin = [0 0 0 0   0   0   1e-10 1e-10 1e-10 1e-10 1e-10 1e-10 1e-10 1e-10 1e-10 1e-10 1e-10 1e-10] ;  %%%% Define lowband
xmax = [1 1 1 100 100 100 1     1     1     1     1     1     1     1     1     1     1     1    ] ;  %%%% Define upperband
dx    = xmax - xmin ;
vmax  = 0.1*dx      ;
empty_particle.position  = [] ;
empty_particle.velocity  = [] ;
empty_particle.cost      = [] ;
empty_particle.pbest     = [] ;
empty_particle.pbestcost = [] ;

particle  = repmat(empty_particle,npop,1) ;
gbest     = zeros(maxit,nvar)             ;
gbestcost = zeros(maxit,1)                ;
for it = 1:maxit
    if it == 1
        gbestcost(1) = inf ;
        for i = 1:npop
            particle(i).velocity = zeros(1,nvar)                 ;
            particle(i).position = xmin+(xmax-xmin).*rand(1,nvar) ;
            %%%%%%%%%%%%%%%%%%%%
           particle(i).cost = fitness1(particle(i).position)     ;
            %%%%%%%%%%%%%%%%%%%%
            particle(i).pbest     = particle(i).position         ;
            particle(i).pbestcost = particle(i).cost             ;
            
            if particle(i).pbestcost<gbestcost(it)
                gbest(it,:)   = particle(i).pbest                ;
                gbestcost(it) = particle(i).pbestcost            ;
            end
        end
    else
        gbest(it,:)   = gbest(it-1,:)   ;
        gbestcost(it) = gbestcost(it-1) ;
        for i=1:npop
            particle(i).velocity = w*particle(i).velocity...
                                +c1*rand*(particle(i).pbest-particle(i).position)...
                                +c2*rand*(gbest(it,:)-particle(i).position)  ;
                            
            particle(i).velocity = min(max(particle(i).velocity,-vmax),vmax) ;
            
            particle(i).position = particle(i).position+particle(i).velocity ;
            
            particle(i).position = min(max(particle(i).position,xmin),xmax)  ;
          %%%%%%%%%%%%%%%%%%% 
          particle(i).cost       = fitness1(particle(i).position)            ;
          %%%%%%%%%%%%%%%%%%%
            if particle(i).cost<particle(i).pbestcost
                particle(i).pbest     = particle(i).position                 ;
                particle(i).pbestcost = particle(i).cost                     ;

                if particle(i).pbestcost<gbestcost(it)
                    gbest(it,:)   = particle(i).pbest                        ;
                    gbestcost(it) = particle(i).pbestcost                    ;
                end
            end
        end
    end
  
    disp(['Iter= ' num2str(it) ' // Best Cost = ' num2str(gbestcost(it))])   ;
        
    w = w*wdamp ;
    it
end

disp([ ' Best Solution = '  num2str(gbest(it,:))])
disp([ ' Best Fitness = '  num2str(gbestcost(it))])
Time = toc/3600

% gbest(it,:)
% figure(1)                         ;
% plot(gbestcost,'r','LineWidth',2) ;
% legend('PSO')
% hold on

fitness2(gbest(it,:))
gbest(it,:)




