function QV = QFnc(policy, x, u)
% Programmed by Jan Peters (jrpeters@usc.edu).
%
% Q = QFnc(policy, x, u) returns the value of taking action u in state x.
%
% If the called as Q = QFnc(policy) for discrete problems, it returns
% the matrix of advantages; Q(x,u) would then give the same value as
% calling QFnc(policy, x, u).
%
% Related: VFnc, AFnc, showFnc

	if(policy.type == 1 | policy.type == 2) % Discrete...   
   	global M N gamma r p

      for xi=1:N
         Rvec(xi) = 0;
         for ui=1:M
				Rvec(xi) = Rvec(xi) + pi_theta(policy, xi,ui)*r(xi,ui);
   		end;
      end;	      
      
      V = VFnc(policy);
      J_pi = stationaryDistribution(policy)*Rvec';                 
       
      if(nargin==3)
      	if(gamma==1)
         	sumV = 0;
         	for xt=1:N
            	sumV = sumV + p(x,u,xt)*V(xt);
         	end;   
         	QV = r(x,u) - J_pi + sumV;
      	else
         	sumV = 0;
         	for xt=1:N
            	sumV = sumV + p(x,u,xt)*V(xt);
         	end;   
         	QV = r(x,u) + gamma*sumV;         
         end;   
      else % Determine all Q values
         for x=1:N
            for u=1:M
      			if(gamma==1)
                    p2 = permute(p, [3 2 1]);
         			sumV = p2(:,u,x)'*V(:);
         			QV(x,u) = r(x,u) - J_pi + sumV;
      			else
                    p2 = permute(p, [3 2 1]);
         			sumV = p2(:,u,x)'*V(:);
         			QV(x,u) = r(x,u) + gamma*sumV;         
         		end;   
            end;
         end;
		end;         
   elseif(policy.type == 3) % Gaussian Policy 
      global A b gamma 
      if(gamma<1)
         QV = rewardFnc(x, u) + gamma*VFnc(policy, A*x+b*u);
      else
         QV = rewardFnc(x, u) - expectedReward(policy) + VFnc(policy, A*x+b*u);
      end;   
	end;   
