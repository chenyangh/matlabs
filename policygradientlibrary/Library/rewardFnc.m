function rew = rewardFnc(x, u)
% Programmed by Jan Peters. 
%
% rew = rewardFnc(x, u) returns the reward of action u taken in state x for
% the given problem.

	global problemType

	if(problemType==1)
            global r
            rew = r(x,u);
        elseif(problemType==2)
            global Q R 
            rew = -0.5*x'*Q*x - 0.5*u'*R*u;
        end;   
      