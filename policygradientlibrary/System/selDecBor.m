function num = selDecBor(x,u)
% Programmed by Jan Peters (jrpeters@usc.edu).
%
% num = selDecBor(x,u) determined the number of the policy parameter (x,u)
% in the associated decision border policy.
	global N M   
	num = (x-1)*(M-1) + u;