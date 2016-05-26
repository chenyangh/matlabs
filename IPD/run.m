%function [x,fval,exitflag,output,population,score] = run(nvars,PopulationSize_Data)
%% This is an auto generated MATLAB file from Optimization Tool.

%% Start with the default options
options = gaoptimset;
%% Modify options setting
options = gaoptimset(options,'PopulationType', 'bitstring');
options = gaoptimset(options,'PopulationSize', 150 );
options = gaoptimset(options,'MutationFcn', {  @mutationuniform 0.02 });
options = gaoptimset(options,'Display', 'off');
options = gaoptimset(options,'PlotFcns', {  @gaplotbestf @gaplotbestindiv });
[x,fval,exitflag,output,population,score] = ...
ga(@findIPD,85,[],[],[],[],[],[],[],[],options);
