function initializeLQRProblem;
% Programmed by Jan Peters. 
%
% initializeLQRProblem verifies that all data on the linear quadratic regulation  
% problem is correctly specified, and initializes the problem. It is an absolute
% requirement for the correct functioning of most scripts in the library.
%
% Related: drawStartState, drawNextState, rewardFnc, 

  global problemType N A b Q R gamma my0 S0

  if(isempty(who('N')))
     disp('ERROR: specify number of states N. Or did you forget `global N?`');
  elseif(isempty(who('A')))
     disp('ERROR: the state transfer matrix A must be in the format N x N. Or did you forget `global A`?');     
  elseif(size(A,1)~=N | size(A,2)~=N) 
     disp('ERROR: the state transfer matrix A must be in the format N x N. Or did you forget `global A`?');
  elseif(isempty(who('b')))
     disp('ERROR: the incoupling matrix b must be in the format N x 1. Or did you forget `global b`?');          
  elseif(size(b,1)~=N | size(b,2)~=1)
     disp('ERROR: the incoupling matrix b must be in the format N x 1. Or did you forget `global b`?');     
  elseif(isempty(who('Q')))     
     disp('ERROR: the state-reward matrix Q must be in the format N x 1. Or did you forget `global Q`?');               
  elseif(find(Q<0))
     disp('ERROR: the state-reward matrix Q must have all entries Q(i,j)>=0.');
  elseif(isempty(who('R')))
     disp('ERROR: the action-reward matrix R must be in the format N x 1. Or did you forget `global R`?');                    
  elseif(find(R<0))
     disp('ERROR: the state-reward matrix R must have all entries R(i,j)>=0.');     
  elseif(isempty(who('my0')))     
     disp('ERROR: expected initial state my0 not defined. Or did you forget `global my0`?');     
  elseif(isempty(who('S0')))
     disp('ERROR: variance S0 around expected initial state my0 not defined. Or did you forget `global S0`?');
  elseif(1<gamma & gamma<0)   
      disp('ERROR: specify discount factor gamma. Or did you forget `global gamma`?');  
  else
      problemType = 2; % Initialize problem to be an LQR Problem.
      % It is now verified 
  end;   
