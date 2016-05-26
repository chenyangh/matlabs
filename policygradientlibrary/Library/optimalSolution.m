function newPolicy = optimalSolution(policy)
% Programmed by Jan Peters (jrpeters@usc.edu).
%
% newPolicy = optimalSolution(policy) returns the optimal policy 
% determined by value iteration. The initial policy is given only
% in order to make sure that the returned policy will be of the 
% same type.   
   newPolicy = policy;
   if(policy.type == 1 | policy.type == 2) % Discrete...      
      global N M p p0 r gamma
   
      delta    = 100;
      maxDelta = 10^-2;
      
      newQ      = r; % QFnc(newPolicy);
      
      iter      = 0;
      pp = permute(p, [3 2 1]);      
      % VALUE ITERATION
      while((delta>maxDelta) & (iter<N*10))
         iter=iter+1; 
         Q   = newQ;         
         [Vopt Uopt] = max(Q');
         newQ = r; 
         for x=1:N
             for u=1:M
                newQ(x,u) = newQ(x,u) + gamma*Vopt(1,:)*pp(:,u, x);
            end;
         end;
         delta = max(max((newQ-Q).^2));         
      end;   
            
      
      % DERIVE OPTIMAL GIBBS POLICY
      newPolicy.theta(:,1) = -1000;
      
      if(policy.type==2)
        for i=1:N
            newPolicy.theta(selGibbs(i,Uopt(i)), 1) = +1000;
        end;
      end;  
   elseif(policy.type == 3) % Gaussian Policy 
      global Q R b A gamma
      %Requires Control Toolbox: [k P]=dlqr(A,b,Q,R);
      k = policy.theta.k';
      P = Q;      
      g = gamma;
%A,b,Q,R,gamma   
      for iter=1:200
         P = Q + g*A'*P*A + g*k'*b'*P*A + g*A'*P*b*k + g*k'*b'*P*b*k + k'*R*k;
         %newPolicy.theta.k     = k';
         %newPolicy.theta.sigma = 0;         
         %P = ricatti(newPolicy);
         k = (-inv(R+g*b'*P*b)*g*A'*P*b)';      
      end;         
      
      newPolicy.theta.k     = k';
      newPolicy.theta.sigma = 0;
   end;
   
function newPolicy = greedyStep(policy, Q)
    global N M   
   if(policy.type == 1)
      newPolicy = policy;
      newPolicy.theta = zeros(N*(M-1),1);
      for x=1:N
         [i j]   = max(Q(x,:));
         if(j<M)
            newPolicy.theta(selDecBor(x,j)) = 1; 
         end;   
      end;   
   elseif(policy.type == 2)
      newPolicy = policy;
      newPolicy.theta = ones(N*M,1)*(-10^3);
      for x=1:N
         [i j]   = max(Q(x,:));
         newPolicy.theta(selGibbs(x,j),1) = +10^3; 
      end;         
   end;      