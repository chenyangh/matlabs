function [disc,Ssum,mysum] = discountedDistribution(policy, x)
% Programmed by Jan Peters (jrpeters@usc.edu).
%
% disc = discountedDistribution(policy, x) returns the discounted distribution for
% state x. Beware: give the initial distribution a small variance S0 and do not make
% it zero as your discountedDistribution will be infinite in my0 otherwise.
%
% disc = discountedDistribution(policy) returns a vector with all discounted
% probabilities for the discrete case.
%
% Related: stationaryDistribution

   if(policy.type == 1 | policy.type == 2) % Undefined for other policies
  	  global N M p0 % For discrete problems

      disc = p0*resolvantKernel(policy);
      if(nargin>1)
         disc=disc(x);
      end;   
   elseif(policy.type == 3) % Gaussian Policy    
	  global N my0 S0 A b gamma% For LQR problems
            
      % Initialization
	  S   = S0;      
      my  = my0;
      
      % Abbreviate policy parameters
      k     = policy.theta.k';
      sig   = policy.theta.sigma^2;
      
      disc  = 0; mysum=zeros(N,1); Ssum = zeros(N,N);
      for t=0:200
         if(det(S)==0)
            stat = inf*(x==my);
         else               
            stat = exp(-0.5*(x-my)'*pinv(S)*(x-my)) / ((2*pi)^(N/2)*sqrt(abs(det(S))));                  
         end;
         
         disc  = disc + (1-gamma)*gamma^t*stat;
         
         Ssum  = Ssum  + (1-gamma)*gamma^t*S;
         mysum = mysum + (1-gamma)*gamma^t*my;
         
         S   = A*S*A' + b*sig*b' + (b*k)*S*A'  + A*S*(k'*b') +  (b*k)*S*(k'*b');                               
         my  = (A + b*k)*my;         
      end;      		      
	end;