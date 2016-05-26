function u = drawAction(policy, x);
% Programmed by Jan Peters. 
%
% u = drawAction(policy, x) draws the action from the policy 
% given state x.
%
% Related: initializeLQRProblem, initializeDiscreteProblem, 
%          drawStartState, drawNextState

	global problemType

   if(policy.type==1 | policy.type==2)
   	probTable = pi_theta(policy, x);
        u = drawFromTable(probTable);     
   elseif(policy.type==3)
      u = normrnd(policy.theta.k'*x, policy.theta.sigma, 1, 1);
   else
      disp('ERROR: take a correct policy.');
	end;      