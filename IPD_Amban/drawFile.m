B = reshape(temp,50,[]);
B(B==-1) = 0;
max(B);
[sortedValues,sortIndex] = sort(B,'ascend'); 
maxRow = sortedValues(50,:);
[sortedValues,sortIndex] = sort(maxRow,'descend'); 
maxColumnsUWant = 5;
newB = B(:,sortIndex(1:maxColumnsUWant));
newB = B(:,1:5);
hold on
for i = 1 : maxColumnsUWant
    toPlot = newB(:,i);
    toPlot = toPlot(toPlot > 0);
    plot(toPlot);
end


ylim([-1 11]);
xlabel('Number of Rounds');
ylabel('Number of Agents with Average Score of 3.0');


%% 

uniVal = unique(temp);
freq = histc(temp,uniVal) ;
bar( uniVal, freq );

