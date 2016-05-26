function V = VFnc(policy, xv)
% Programmed by Jan Peters (jrpeters@usc.edu).
%
% V = VFnc(policy, x, u) returns the value of state x.
%
% If the called as V = VFnc(policy) for discrete problems, it returns
% the matrix of advantages; V(x) would then give the same value as
% calling VFnc(policy, x).
%
% Related: QFnc, AFnc

   global M N gamma r 

   if(policy.type == 1 | policy.type == 2) % Discrete...   
        for x=1:N
            Rvec(x) = 0;
            for u=1:M
                Rvec(x) = Rvec(x) + pi_theta(policy, x,u)*r(x,u);
            end;
        end;	      
      
        K = oneStepTransitionKernel(policy);
      
        if(gamma==1)   
            J_pi = stationaryDistribution(policy)*Rvec'; 
            RR = (Rvec' - ones(N,1)*J_pi);
            V  = RR;
            for iter=1:(200*N)
                V = RR + K*V;
            end;    
        else
            V = inv(eye(N)-gamma*K)*Rvec';
        end;         	   
      
        if(nargin==2)
            V = V(xv);
        end;   
   elseif(policy.type == 3) % Gaussian Policy 
        global R b gamma
        global A b Q R
      
        sigma = policy.theta.sigma;      
        P = ricatti(policy);
      
        if(gamma==1)
            V = -0.5*xv'*P*xv;   
   	else
            V = -0.5*xv'*P*xv - 0.5*(R+gamma*b'*P*b)*sigma^2/(1-gamma);
   	end;                     
    end;