function policy = initGaussPolicy
% Programmed by Jan Peters (jrpeters@usc.edu).
%
% policy = initGaussPolicy returns an initialized 
% Gauss policy for the given linear quadratic regulation problem. 
%
% Related: initDecisionBorderPolicy, initEpsGreedyGibbsPolicy

	global N backupPolicy

	% Set policy type
   policy.type  = 3;
      
   % Initialize policy parameters
   policy.theta.k = rand(N,1);
   policy.theta.sigma = rand(1,1);
   
   % Generate a backup policy
   backupPolicy.theta.k = rand(N,1);
   backupPolicy.g = 100;
   backupPolicy.P = rand(N,N);