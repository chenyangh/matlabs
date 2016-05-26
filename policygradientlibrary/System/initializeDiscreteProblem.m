function initializeDiscreteProblem;
% Programmed by Jan Peters. 
%
% initializeDiscreteProblem verifies that all data on the discrete problem is 
% correctly specified, and initializes the problem. It is an absolute
% requirement for the correct functioning of most scripts in the library.
%
% Related: drawStartState, drawNextState, rewardFnc, 

	global problemType N M p0 p r gamma
      
   if(isempty(who('N')))
      disp('ERROR: specify number of states N. Or did you forget `global N?`');
   elseif(isempty(who('M')))
      disp('ERROR: specify number of actions M. Or did you forget `global M`?');
   elseif(length(p0)==0)
      disp('ERROR: initial states table must be in the format N x 1. Or did you forget `global p0`?');      
   elseif(max(size(p0))~=N | min(size(p0))~=1 ) 
      disp('ERROR: initial states table must be in the format N x 1. Or did you forget `global p0`?');
   elseif(sum(p0)~=1) 
      disp('ERROR: p0 contains non-probabilities.')      
   elseif(length(p)==0)
      disp('ERROR: transition probabilities table p has to be filled completely. Or did you forget `global p`?');      
   elseif(size(p,1)~=N | size(p,2)~=M | size(p,3)~=N )
      disp('ERROR: transition probabilities table p has to be filled completely. Or did you forget `global p`?');
   elseif(max(max(p))>1 | min(min(p))<0) 
      disp('ERROR: p contains non-probabilities.')
   elseif(~isempty(find(sum(p,2)~=1))) 
      disp('ERROR: p contains non-probabilities.')      
   elseif(max(max(p0))>1 | min(min(p0))<0) 
      disp('ERROR: p0 contains non-probabilities.')      
   elseif(length(r)==0)
      disp('ERROR: reward table r has to be filled completely. Or did you forget `global r`?');      
   elseif(size(r,1)~=N | size(r,2)~=M )
      disp('ERROR: reward table r has to be filled completely. Or did you forget `global r`?');
	elseif(isempty(who('gamma')))
      disp('ERROR: specify correct discount factor gamma. Or did you forget `global gamma`?');        
  elseif(1<gamma & gamma<0)   
      disp('ERROR: specify correct discount factor gamma. Or did you forget `global gamma`?');  
   else
	   problemType = 1; % Initialize problem to be discrete.
      % It is now verified 
   end;   
   
   
