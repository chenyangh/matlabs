function data = obtainData(policy, L, H);
% Programmed by Jan Peters. 
%
% data = obtainData(policy, L, H) obtains H trajectories of 
% length L using policy and returns them in the correct data
% format.
%
% data = obtainData(policy, L) obtains 1 trajectory of 
% length L using policy and returns them in the correct data
% format.
%
% Related: initializeLQRProblem, initializeDiscreteProblem, 
%          drawNextState, rewardFnc, 

	if(nargin==2)
      H=1;
   end;   
   
	% Perform H episodes
   for trials=1:H
      % Save associated policy
      data(trials).policy = policy;
      
   	% Draw the first state
	   data(trials).x(:,1) = drawStartState;

   	% Perform a trial of length L
	   for steps=1:L 
         % Draw an action from the policy
      	data(trials).u(steps)   = drawAction(policy, data(trials).x(:,steps));
      
      	% Obtain the reward from the 
      	data(trials).r(steps)   = rewardFnc(data(trials).x(:,steps), data(trials).u(steps));   

			% Draw next state from environment      
   	   data(trials).x(:,steps+1) = drawNextState(data(trials).x(:,steps)', data(trials).u(steps));   
   	end;
	end;   
      