function [stat,S,my] = stationaryDistribution(policy, x, maxLength)
% Programmed by Jan Peters (jrpeters@usc.edu).
%
% disc = stationaryDistribution(policy, x) returns the stationary distribution for
% state x. This distribution does only exist for stable linear quadratic regulation 
% problems but for all discrete problems.
%
% disc = stationaryDistribution(policy) returns a vector with all discounted
% probabilities in the discrete case.
%
% Related: discountedDistribution
   
   if(policy.type == 1 | policy.type == 2) % Discrete... 
		global N M p0 % For discrete problems      
      
      K     = transitionKernel(policy, 1);
      mat   = eye(N) - K';
      vec1  = ones(1,N);
      vec2  = [zeros(N-1,1); 1];
      if(det([mat(1:(N-1),:); vec1])==0)
         stat = ones(N,1)'/N;
      else   
         stat  = (inv([mat(1:(N-1),:); vec1])*vec2)';      
      end;   
      %VERIFICATION: stat = p0*transitionKernel(policy, 10^20)     
      
      if(nargin>1)
         stat=stat(x);
      end;               
   elseif(policy.type == 3) % Gaussian Policy 
		global N my0 S0 A b backupPolicy% For LQR problems
      
 %     if(policy.theta.k==backupPolicy.theta.k)
 %        my = backupPolicy.my;
 %        S = backupPolicy.S;
 %        Sinv = backupPolicy.Sinv;         
 %     else
       if(1)
         if(nargin<3) maxLength = 10^5; end;
         
      	% Initialization
		S   = S0;      
      	my  = my0;
         
      	% Abbreviate policy parameters
      	k     = policy.theta.k';
         sig   = policy.theta.sigma^2;
         
         mymy = my+ones(N,1);
         SS   = S+ones(N,N);
         iter = 0;
         
         while(((max(max(abs(mymy-my)))>10^-10) | (max(max(abs(SS-S)))>10^-10)) & iter<maxLength)       
            mymy = my;
            SS   = S;
            iter = iter + 1;
            
            my  = (A+b*k)*my;                        
            %S   = A*S*A' + b*b'*sigma^2 + (b*k')*S*A'  + A*S*(b*k')' +  (b*k')*S*(b*k')';                           
            S   = A*S*A' + b*sig*b' + (b*k)*S*A'  + A*S*(k'*b') +  (b*k)*S*(k'*b');                               
         end;  
         Sinv = inv(S);

         %policy.g = backupPolicy.g;
         %policy.P = backupPolicy.P;

         %backupPolicy = policy;
         backupPolicy.S = S;
         backupPolicy.my = my;         
         backupPolicy.Sinv = Sinv;  
		end;       
            
      if(det(S)==0)
         stat= inf*(x==my);
      else   
   		stat = exp(-0.5*(x-my)'*Sinv*(x-my)) / ((2*pi)^(N/2)*sqrt(abs(det(S))));     
      end;
   end;   
