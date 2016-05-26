function drawDirectedGraph(myStrategy, againstStrategy)
%DRAWDIRECTEDGRAPH draw the graph whil two stragegies compete with each
%other

%% Generate a path stored in posQueue
checkCircle = java.util.HashSet(); % java method of hash set
posQueue = []; 
maxRounds = 85;
posOfStrategy = 1;
scores = 0;
fightHist = [];     % a queue

for i = 1 : maxRounds
    checkCircle.add(posOfStrategy);
    posQueue(end+1) = posOfStrategy;
    % Give a socre based on cuured strategy
    currentCaseSum = 3 - myStrategy(posOfStrategy) * 2  -  ... 
        againstStrategy(posOfStrategy) * 1;

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
   
    if( checkCircle.contains(posOfStrategy) )
        fprintf('%d\n',i);
        posQueue(end+1) = posOfStrategy;
        break;
    end
   
end
%% Generage cm
pathLength = length(posQueue);
posQueue
cm = zeros(pathLength -1, pathLength -1 );
IDS = {};
for i = 1:pathLength - 2
    fromPos = i;
    toPos = i+1;
    cm(fromPos, toPos) = 1;
end
cm(pathLength-1,  find( posQueue(1:end-1) == posQueue(end) ) ) = 1;
cm(fromPos, toPos)
for i = 1:pathLength - 1
    IDS(end+1) = {strcat( getStragetyString(posQueue(i)) ,'' )  };
end

 %% Draw graph based on cm
  
  bg=biograph(cm,IDS);
  set(bg.nodes,'shape','circle','color',[1,1,1],'lineColor',[0,0,0]);
  set(bg,'layoutType','radial');
  bg.showWeights='off';
  set(bg.nodes,'textColor',[0,0,0],'lineWidth',2,'fontsize',9);
  set(bg,'arrowSize',12,'edgeFontSize',9);
  set(bg,'LayoutType', 'equilibrium');
  %get(bg.nodes,'position')
  view(bg);

end

%% Subfunction
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