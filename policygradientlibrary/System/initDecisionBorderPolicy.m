function policy = initDecisionBorderPolicy
% Programmed by Jan Peters (jrpeters@usc.edu).
%
% policy = initDecisionBorderPolicy returns an initialized decision border
% policy for the given discrete problem.
%
% Related: initEpsGreedyGibbsPolicy, initGaussPolicy

	global N M

	% Set policy type
   policy.type  = 1;
   
   % Initialize policy parameters
   policy.theta = [];
   for i=1:N
      thetas = rand(M,1);
      thetas = thetas / sum(thetas);
      policy.theta = [policy.theta thetas(1:(M-1))];
   end;   