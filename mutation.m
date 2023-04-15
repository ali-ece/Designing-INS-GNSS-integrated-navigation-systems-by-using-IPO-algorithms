% Ali Mohammadi_INS/GNSS

function  mutpop=mutation(mutpop,pop,nvar,nmut,popsize,lb,ub)

for n=1:nmut
    
i = randi([1 popsize])  ;  

p = pop(i).var          ;

j = randi([1 nvar])     ;

d = ub(j)-lb(j)         ;
d = 0.1*unifrnd(-1,1)*d ;

p(j) = p(j)+d           ;


p    = max(p,lb)        ;
p    = min(p,ub)        ;


mutpop(n).var = p       ;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
mutpop(n).fit = fitness1(p) ;

end

end