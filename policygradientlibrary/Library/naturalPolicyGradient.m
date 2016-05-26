function w = naturalPolicyGradient(policy);

% Programmed by Jan Peters (jrpeters@usc.edu).
%
% w = naturalPolicyGradient(policy) returns the natural gradient of the
% expected reward for the specified problem and policy.
%
% Related: policyGradient, expectedReward
	
   
   if(policy.type == 1) % Decision border policy
      global N M
      A = AFnc(policy);
      for x=1:N
         for u=1:M-1
            w(selDecBor(x,u),1) = A(x,u)*policy.theta(selDecBor(x,u));
         end;
      end;   
   elseif(policy.type == 2) % Gaussian Policy 
      global N M
      A = AFnc(policy);
      for x=1:N
         for u=1:M
            w(selGibbs(x,u),1) = policy.eps*A(x, u);
         end;
      end;            
   elseif(policy.type == 3) % Gaussian Policy 
      global N A b Q R gamma
           
      g = gamma;
      k = policy.theta.k;
      s = policy.theta.sigma;
      
      P = ricatti(policy);
      
	  w(1:N,1) = (-k*(R+g*b'*P*b) - g*A'*P*b)*(s^2);
      w(N+1,1) = -0.5*(R+g*b'*P*b)*(s^3);      
   end;
	   