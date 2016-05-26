function J_pi = expectedReturn(policy);
% Programmed by Jan Peters (jrpeters@usc.edu).
%
% J_pi = expectedReward(policy) returns the expected reward for the
% specified problem and policy.
%
% Related: policyGradient, naturalPolicyGradient
   
   if(policy.type == 1 | policy.type == 2) % Discrete...   
      global gamma r N M

      for x=1:N
         Rvec(x) = 0;
         for u=1:M
				Rvec(x) = Rvec(x) + pi_theta(policy, x,u)*r(x,u);
    	 end;
      end;	    
		if(gamma==1)
			J_pi = stationaryDistribution(policy)*Rvec';   
   	    else
      	    J_pi = discountedDistribution(policy)*Rvec';
   	    end;         
   elseif(policy.type == 3) % Gaussian Policy 
      global R b S0 my0 gamma
      
      sigma = policy.theta.sigma;
      
      [P,F] = ricatti(policy);
      P,F
	  if(gamma==1)
			J_pi = -0.5*(R+b'*P*b)*sigma^2;   
   	  else
      	%J_pi = -0.5*(R+b'*P*b)*sigma^2 - 0.5*(1-gamma)*(Trace(P*S0) + my0'*P*my0);
        J_pi = - 0.5*(1-gamma)*(Trace(P*S0') + my0'*P*my0 + F);
   	  end;
   end;         
   %end;
   
function val = Trace(mat)

val = 0;
for i=1:min(size(mat))
    val = val + mat(i,i);
end;    