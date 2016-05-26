function dJdtheta = policyGradient(policy);
% Programmed by Jan Peters (jrpeters@usc.edu).
%
% dJdtheta = policyGradient(inPolicy) returns the policy gradient of the
% expected reward for the specified problem and policy.
%
% Related: naturalPolicyGradient, expectedReward

	global N M gamma

   poli = policy;
   if(policy.type==3) if(policy.theta.sigma == 0)
      disp('Policy gradient for sigma=0 undefined');
      poli.theta.sigma = 0.001;
   end; end;

   A = allActionMatrix(poli);
   w = naturalPolicyGradient(poli);
   dJdtheta = A*w;
