function K = oneStepTransitionKernel(policy)
% Programmed by Jan Peters (jrpeters@usc.edu).
%
% K = oneStepTransitionKernel(policy) returns the one-step transition 
% kernel matrix for this policy and discrete problems.
%
% Related: resolvantKernel, transitionKernel, showKernel

	global N M p   

   if(policy.type ~= 1 & policy.type ~= 2) % Undefined for other policies
      disp('Error: The discounted distribution can only be determined emperically.')
   else
      for xs=1:N
          for u=1:M
              poli(xs,u)=pi_theta(policy, xs, u);
          end;    
      end; 
      for xs=1:N
    	 for xt=1:N
      	    K(xs,xt) = p(xs, 1:M, xt)*poli(xs, 1:M)';
         end;
      	 K(xs,:) = K(xs,:)/sum(K(xs,:)); %Prevent bad numerics...
      end;  
   end;   
  
