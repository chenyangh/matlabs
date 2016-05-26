function reval = findIPD( myStrategy )
%parpool(4)
memoryDepth = 3;
codingLength = ( 4 ^ (memoryDepth + 1 ) - 1 ) / 3;
% 0 stands for defect ; 1 stands for cooperate
%% compare to ALL-C
    ALLCStrategy = zeros(1,codingLength);
    scoreVersusALLC = fightWithStrategy(myStrategy,ALLCStrategy);
%% compare to ALL-D  
    ALLDStrategy = ones(1,codingLength);
    scoreVersusALLD = fightWithStrategy(myStrategy,ALLDStrategy);
%% compare to Random Strategy
%     randSum = 0;
%     timesOfRand = 20;
%     for i = 1 : timesOfRand 
%         RandStrategy = randi([0 1], 1, codingLength);
%         randSum = randSum + ...
%              fightWithStrategy(myStrategy,RandStrategy);   
%     end
%     scoresVersusRand = randSum / timesOfRand;
%%  compare to TFT
    scoresVersusTFT =  fightWithTFT(myStrategy);  
%% Sum of all strategies
    reval = - ( scoreVersusALLC + scoreVersusALLD + ...
         scoresVersusTFT ) / 3 ;
end