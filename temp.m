avg = [];
for i = 1 : 500 : length(sarsa)
    
   avg = [ avg ; mean(sarsa(i :  min( [i + 499, length(sarsa)] ) ) )] ;
    
end