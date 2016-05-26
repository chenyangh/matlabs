function K = transitionKernel(policy, n, x0, x);   
% Programmed by Jan Peters (jrpeters@usc.edu).
%
% K = transitionKernel(policy, n) returns the n-step transition
% kernel matrix for this policy an discrete problems.
%
% K = transitionKernel(policy, n, x0, x) returns the n-step transition
% probability from state x to state y.
%
% Related: oneStepTransitionKernel, resolvantKernel, showKernel

	if(policy.type == 1 | policy.type == 2) % Undefined for other policies
      global N M p0 % For discrete problems
      
      % Calculate One-Step Transition Kernel
      K1 = oneStepTransitionKernel(policy);
      
      % Calculate n-Step Transition Kernel      
      K = K1^n;   
      
      if(nargin==4)
         K = K(x0,x)
      end;   
   elseif(policy.type == 3) % Gaussian Policy    
   	global N my0 S0 A b gamma % For LQR problems
            
      % Initialization
		S   = 0*eye(N);      
      my  = x0;
      
      % Abbreviate policy parameters
      k     = policy.theta.k;
      sigma = policy.theta.sigma;
      
      for t=1:n
         S   = (A'*S*A + A'*S*b*k' + k*b'*S*A + b*b'*sigma^2 + k*b'*S*b*k'); 
         my  = (A + b*k')*my;         
      end;      
      
      if(det(S)==0)
         K = inf*(x==my);
      else   
			K = exp(-0.5*(x-my)*pinv(S)*(x-my)) / ((2*pi)^(N/2)*sqrt(det(S)));            
      end;            
	end;