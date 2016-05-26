function num = drawFromTable(probabilityTable)
% Programmed by Jan Peters. 
%
% num = drawFromTable(probabilityTable) draws a random number
% from the table of probabilities probabilityTable.

for h=1:length(probabilityTable)
   roundRobin(h) = sum(probabilityTable(1:h));
end;

numRnd = rand(1);

h=1;
while(numRnd>roundRobin(h)) 
   h=h+1; 
end;

num = h;
