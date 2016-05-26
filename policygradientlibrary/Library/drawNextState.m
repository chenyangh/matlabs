function xn = drawNextState(x,u);
% Programmed by Jan Peters. 
%
% xn = drawNextState(x,u) draws the next state from the transition
% function given state x and action u. The LQR next state is deterministic
% and can be determined by xn=Ax+bu; the discrete next state has to
% be drawn from the transition table. Do not forget to initialize 
% the problem beforehand.
%
% Related: initializeLQRProblem, initializeDiscreteProblem, 
%          drawStartState

	global problemType

	if(problemType==1)
            global p
      
            probTable = p(x,u,:);
            xn = drawFromTable(probTable);       
	elseif(problemType==2)   
            global A b N

            if(size(x,2)==length(x)) 
                y(1:N,1)=x(1,1:N)'; 
                x=y; 
            end;

            xn = A*x + b*u;   	      
        else
            disp('ERROR: initialize problem.');
	end;      