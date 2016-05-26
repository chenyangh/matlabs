function prob = pi_theta(policy, x, u)
% Programmed by Jan Peters (jrpeters@usc.edu).
%
% prob = pi_theta(policy, x, u) returns the probability of taking action u
% in state x given the policy.
%
% prob = pi_theta(policy, x) returns the table of all probabilities 
% for DISCRETE PROBLEMS.
%
% Related: drawAction

    global N M

    if(policy.type == 1)	% Decision border policy
        if(nargin==3)
            if(u==M)
                prob = 1 - sum(policy.theta(selDecBor(x,1):selDecBor(x,M-1)));
            else
         	prob = policy.theta(selDecBor(x,u));
            end;   
         elseif(nargin==2)
            prob = [policy.theta(selDecBor(x,1):selDecBor(x,M-1)) 1-sum(policy.theta(selDecBor(x,1):selDecBor(x,M-1)))];
        else
            disp('ERROR: wrong arguments.');
        end;         
    elseif(policy.type == 2) % Gibbs policy
      for i=1:M
         vec = zeros(N*M,1);
         vec(selGibbs(x,i)) = 1/policy.eps; 
         prob(i) = exp( min(200, max(-200,policy.theta*vec) ) );
      end;
      
      if(sum(prob)>0)
         prob = prob/sum(prob);       
      else   
         prob = prob;
         disp(['ERROR: Ill-configured policy...' num2str(policy.theta)])
      end;         
      if(nargin==3)
         prob = prob(u);
      end;   
    elseif(policy.type == 3) % Gaussian policy
	prob = exp(-(u-policy.k'*x)^2/policy.s^2)/sqrt(2*pi*policy.s^2)      
    else 
        disp('ERROR: The policy is not defined.')      
    end;
  