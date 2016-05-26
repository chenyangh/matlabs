function num = selGibbs(x,u)
% Programmed by Jan Peters (jrpeters@usc.edu).
%
% num = selGibbs(x,u) determined the number of the policy parameter (x,u)
% in the associated eps-greedy Gibbs policy.

	global N M
	num = (x-1)*M + u;      
