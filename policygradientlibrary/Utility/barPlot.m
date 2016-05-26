function barPlot(data1, data2, noTrials, noPoints, colour, sampling)

% barPlot(data1, data2, noTrials, maxUpdates, colour)
%
% Makes an error plot of a time sequence of noPoints obtained during
% noTrials. data1 has the summed up data and data2 has the squared
% summed up data. It uses color colour!
%
mue  = data1/noTrials;
EX2  = data2/noTrials;
std  = sqrt(EX2 - mue.^2);
updates = 1:sampling:noPoints;
errorbar(updates-1, mue(updates), std(updates), colour); hold on;
