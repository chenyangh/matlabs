function dJdtheta = AllActionGradient(policy, data)

	AA       = estimateAllActionMatrix(policy, data);
   w        = ActorCritic(policy, data);
	dJdtheta = AA*w;