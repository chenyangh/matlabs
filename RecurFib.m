function [i ,j ] = RecurFib(k)
if k == 1 
    i = 0 ; j = 1;
    return
else
    [i,j] = RecurFib(k-1);
    k = i + j ;
    i = j;
    j = k;
    return 
end
    
end