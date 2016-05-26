fid = fopen('NewLabel.txt');

tline = fgetl(fid);
i = 1;
while ischar(tline)
    words{i} = tline;
    i = i + 1 ;
       
    tline = fgetl(fid);
end


fclose(fid);

%%
fid1 =fopen('10labelLabel.txt','w');
fid2 =fopen('10labelPreds.txt','w');

for i = 1 : 144
    fprintf(fid1, '%s \n' , words{labelVec(i)} );
    fprintf(fid2, '%s \n' , words{truePreds(i)} );
end

fclose(fid1);
fclose(fid2);
%% 
tmpIn = accuracy(indoor);
tmpIn(tmpIn==0) = [];
tmpOut = accuracy(outdoor);
tmpOut(tmpOut==0) = [];



%%
inAcy = mean(tmpIn);
outAcy = mean(tmpOut);

%% GRAPH 
while (ture)
    N = 10;
    tmpPerm = randperm(397);
    choose = tmpPerm(1:N);
    trueLabel = [];
    for i = 1 : N
       trueLabel = [ trueLabel; find( label == choose(i)) ];
    end

    truePreds = [];
    for i = 1 : length(trueLabel)
        truePreds = [ truePreds ; preds( trueLabel(i) ) ];
    end

    truePreds = sort( unique(truePreds) );
      
end


%% 
for i = 1 : 20
   disp( words{I(i)} );
end
        


