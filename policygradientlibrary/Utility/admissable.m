function p = admissable(pp)
% Programmed by Jan Peters (jrpeters@usc.edu).
%
% Function p = admissable(pp) checks whether the policy parameters pp
% are admissable for calculating the gradient numerically stable. If 
% not they are perturbed by a small number.
%
% Only used by policyGradient and naturalPolicyGradient.

	p = pp;
   p(find(p==1)) = 0.995;
   p(find(p==0)) = 0.005;