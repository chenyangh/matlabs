function A = AFnc(policy, x, u)
% Programmed by Jan Peters (jrpeters@usc.edu).
%
% A = AFnc(policy, x, u) returns the advantage of action u in state x
% over the rest of all other actions in that particular state.
%
% If the called as A = AFnc(policy) for discrete problems, it returns
% the matrix of advantages; A(x,u) would then give the same value as
% calling AFnc(policy, x, u).
%
% Related: VFnc, QFnc, showFnc
	global M N p r gamma

   if(nargin==3)
      A = QFnc(policy, x, u) - VFnc(policy, x);
   elseif(policy.type~=3) 
         V(:,1) = VFnc(policy);
         QV     = QFnc(policy);
         A      = QV - repmat(V,1,M);
   else
      disp('ERROR: not implemented')
   end;   
