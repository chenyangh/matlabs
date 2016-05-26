randSum = 0;
tic;
timesOfRand = 1000;
for j = 1: 10
randVals = zeros(1,timesOfRand);
for i = 1 : timesOfRand 
    RandStrategy = randi([0 1], 1, 85);
    randVals(i) = fightWithTFT(RandStrategy)/100;   
end
end
mean(randVals);
toc;