function [P,F] = ricatti(policy)
% Programmed by Jan Peters. 
%
% P = ricatti(policy) returns the P matrix of the stochastic Ricatti equation.
% It is only applicable for LQR problems. 
%
% BEWARE: DON'T USE THE GLOBAL VARIABLE backupPolicy. If the policy
% does not change, the value from backupPolicy is reused!!!
%
% Related: AFnc, VFnc, QFnc, expectedReward
	global A b Q R gamma N backupPolicy
         
   if(policy.type == 3) % Gaussian policy
     if(policy.theta.k==backupPolicy.theta.k & backupPolicy.g==gamma & ~isempty(backupPolicy.P))
         P = backupPolicy.P;
         if(gamma<1)
            F = (R+gamma*b'*P*b)*policy.theta.sigma^2/(1-gamma);
         else
            F = 0;
        end;   
     else        
      	k = policy.theta.k';
      	g = gamma;
      	%REquires Control Toolbox: [kk P]=dlqr(A,b,Q,R);
        P  = Q;
      	PP = zeros(N);
      	while(max(max((PP-P).^2))>10^-9)      
            % for t=1:100
            PP = P;
         	% P = Q + g*A'*P*A + g*k'*b'*P*A + g*A'*P*b*k + g*k'*b'*P*b*k + k'*R*k; 
            P = (Q + k'*R*k) + g*(A+b*k)'*P*(A+b*k);
         end;
         
         if(gamma<1)
            F = (R+gamma*b'*P*b)*policy.theta.sigma^2/(1-gamma);
         else
            F = 0;
        end;   
         backupPolicy = policy;
         backupPolicy.P = P;
         backupPolicy.g = g;
       end;         
   else
      disp('ERROR: Ricatti is limited to LQR problems.');
   end;   