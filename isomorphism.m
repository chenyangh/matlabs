%% GRAPH 
while (true)
    N = 10;
    tmpPerm = randperm(397);
    choose = tmpPerm(1:N);
    trueLabel = [];
    for i = 1 : N
       trueLabel = [ trueLabel; find( label == choose(i)) ];
       
    end

    truePreds = [];
    labelVec = [];
    for i = 1 : length(trueLabel)
        truePreds = [ truePreds ; preds( trueLabel(i) ) ];
        labelVec = [ labelVec ; label(trueLabel(i))];
    end

    truePreds = sort( unique(truePreds) );
    if ( length(truePreds) < 40 )
        break;
    end
    length(truePreds)
end
