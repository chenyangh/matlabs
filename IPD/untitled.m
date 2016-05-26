function [x,fval,exitflag,output,population,score] = untitled
%% This is an auto generated MATLAB file from Optimization Tool.

%% Start with the default options
options = gaoptimset;
%% Modify options setting
options = gaoptimset(options,'PopulationType', 'bitstring');
options = gaoptimset(options,'MutationFcn', {  @mutationuniform 0.01 });
options = gaoptimset(options,'Display', 'off');
[x,fval,exitflag,output,population,score] = ...
ga([],[],[],[],[],[],[],[],[],[],options);
