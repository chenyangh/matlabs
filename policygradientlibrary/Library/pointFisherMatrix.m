function Amat = pointFisherMatrix(inPolicy, x);

% Programmed by Jan Peters (jrpeters@usc.edu).
%
% w = naturalPolicyGradient(policy) returns the natural gradient of the
% expected reward for the specified problem and policy.
%
% Related: policyGradient, expectedReward
   policy = inPolicy;
   
   if(policy.type == 1 | policy.type == 2) % Discrete...   
      global N M gamma
      if(policy.type == 1) 
         G=M-1; 
         policy.theta = admissable(policy.theta);
      else 
         G=M; 
      end;
      
      Amat = zeros(G*N,G*N);
      for u=1:M
         Amat = Amat + pi_theta(policy,x,u)*DlogPiDTheta(policy, x,u)*DlogPiDTheta(policy, x,u)';            
      end;      
   elseif(policy.type == 3) % Gaussian Policy 
      global N gamma
                        
      Amat = [(x*x') zeros(N,1); zeros(1,N) 2]./max(policy.theta.sigma^2,0.0001);      
   end;
	   