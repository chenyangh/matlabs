function K = resolvantKernel(policy);   
% Programmed by Jan Peters (jrpeters@usc.edu).
%
% K = resolvantKernel(policy) returns the resolvant 
% kernel matrix for this policy and discrete problems.
%
% Related: oneStepTransitionKernel, transitionKernel, showKernel

	global gamma N
   if(policy.type ~= 1 & policy.type ~= 2) % Undefined for other policies
      disp('Error: The resolvant kernel only be determined emperically.');
   elseif(gamma==1)
      disp('Error: The resolvant kernel requires 0<=gamma<1.');
	else
      % Calculate One-Step Transition Kernel
      K1 = oneStepTransitionKernel(policy);
      
      K = (1-gamma)*inv(eye(N)-gamma*K1);
   end;         
