function Amat = allActionMatrix(inPolicy);

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
      
      if(gamma==1)
          dstat = stationaryDistribution(policy);
      else    
          disc  = discountedDistribution(policy);
      end; 
      
      Amat = zeros(G*N,G*N);
      for x=1:N
         Rvec = zeros(G*N,G*N)';
         for u=1:M
            der  = DlogPiDTheta(policy, x,u); 
            Rvec = Rvec + pi_theta(policy,x,u)*der*der';            
         end;
         
		 if(gamma==1)
				Amat = Amat + dstat(x)*Rvec;   
   		 else
      		    Amat = Amat + disc(x)*Rvec;
         end;    
	  end;	            
   elseif(policy.type == 3) % Gaussian Policy 
      global N gamma
                        
      if(gamma==1)
         [p,S,my]=stationaryDistribution(policy, zeros(N,1));
      else   
         [p,S,my]=discountedDistribution(policy, zeros(N,1));         
      end;              
      Amat = [(S+my*my') zeros(N,1); zeros(1,N) 2]./max(policy.theta.sigma^2,0.0001);      
   end;
	   