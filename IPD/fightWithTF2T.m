function scores = fightWithTF2T (myStrategy )
%FIGHTWITHSTRATEGY  give scores based on ( myStrategy, againstStrategy )
%   0 stands for defect ; 1 stands for cooperate
%% SET UP 
maxRounds = 100;    % set up the maxRounds 100 by default
%% 
posOfStrategy = 1;
scores = 0;
curretTat = 1;
fightHist = [];     % a queue
for i = 1 : maxRounds
    % Give a socre based on cuured strategy
    currentCaseSum = 3 - myStrategy(posOfStrategy) * 2  -  ... 
        curretTat * 1;
    curretTat = myStrategy(posOfStrategy);
    if ( currentCaseSum == 3 ) % D D
        scores = scores + 1;
    elseif ( currentCaseSum == 1 ) % C D
        scores = scores + 0;
    elseif ( currentCaseSum == 2 ) % D C
        scores = scores + 5;
    elseif ( currentCaseSum == 0) % C C 
        scores = scores + 3;
    end
    % manage history queue
    [histSum,fightHist] = pushHist(fightHist,currentCaseSum);
        
    % jump to pos?
    if ( posOfStrategy == 1 ) % fist round
        posOfStrategy = 5 - histSum ;
    elseif ( posOfStrategy <= 5 ) 
        posOfStrategy = 21 - histSum;
    elseif ( posOfStrategy <= 21 )
        posOfStrategy = 85 - histSum;
    elseif ( posOfStrategy <= 85 )
        posOfStrategy = 85 - histSum;
    end
    
   
end


scores = scores / maxRounds;

    function [histSum,fightHist] = pushHist( fightHist , toPush )
        
        if ( length(fightHist) < 3 ) 
            fightHist = [ fightHist toPush ];
        else
            fightHist = [ fightHist(2:3)  toPush ];
        end
        % Quaternary numeral system
        QNMVec = [ 16 ; 4 ; 1 ];
        histSum = fightHist * QNMVec( 4-length(fightHist) : 3 ) ; 
    end
end

