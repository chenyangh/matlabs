function policy = initEpsGreedyGibbsPolicy(eps)
% Programmed by Jan Peters (jrpeters@usc.edu).
%
% policy = initEpsGreedyGibbsPolicy(eps) returns an initialized 
% eps-greedy Gibbs policy for the given discrete problem.
%
% Related: initDecisionBorderPolicy, initGaussPolicy

   global N M

   % Set policy type
   policy.type  = 2;
   
   % Save Eps-Parameters
   policy.eps   = eps;
   
   % Initialize policy parameters
   policy.theta = rand(N*M,1);
