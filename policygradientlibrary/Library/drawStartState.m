function x0 = drawStartState;
% Programmed by Jan Peters. 
%
% x0 = drawStartState draws a start-state from the start-state 
% distribution. This is specified in the table p0 for discrete
% problems, and given in form of a Gaussian distribution N(my0,S0)
% for LQR problems. Do not forget to initialize the problem
% beforehand.
%
% Related: initializeLQRProblem, initializeDiscreteProblem, 
%          drawNextState, rewardFnc, 

	global problemType N

	if(problemType==1)
   	global p0
   	probTable = p0;
      x0 = drawFromTable(probTable);        
   elseif(problemType==2)  
      global my0 S0
      if(S0==zeros(N))
         x0 = my0;
      else   
         x0 = mvnrnd(my0, S0, 1);
      end;   
   else
      disp('ERROR: initialize problem.');
	end;      