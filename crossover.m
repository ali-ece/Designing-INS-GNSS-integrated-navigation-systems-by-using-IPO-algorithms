function  crosspop=crossover(crosspop,pop,ncross)
% Ali Mohammadi_INS/GNSS
f = [pop.fit]    ;
f = max(f)-f+eps ;
f = f./sum(f)    ;
f = cumsum(f)    ;

for n = 1:2:ncross

    i1 = find(rand<=f,1,'first') ;
    i2 = find(rand<=f,1,'first') ;
    
p1 = pop(i1).var ;
p2 = pop(i2).var ;

R  = rand(size(p1)) ;

o1 = (R.*p1)+((1-R).*p2) ;
o2 = (R.*p2)+((1-R).*p1) ;

crosspop(n).var = o1 ;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
crosspop(n).fit = fitness1(o1) ;

crosspop(n+1).var = o2 ;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
crosspop(n+1).fit = fitness1(o2) ;
end

end



















