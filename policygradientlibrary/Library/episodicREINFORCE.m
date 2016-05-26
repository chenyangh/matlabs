function dJdtheta = episodicREINFORCE(policy, data)

	global N gamma
   
   dJdtheta = zeros(size(DlogPiDTheta(policy,1,1)));

	for Trials = 1 : max(size(data))
		dSumPi = zeros(size(DlogPiDTheta(policy,1,1)));
		sumR   = 0;
   
      for Steps = 1 : max(size(data(Trials).u))
         dSumPi = dSumPi + DlogPiDTheta(policy, data(Trials).x(Steps), data(Trials).u(Steps));
         sumR   = sumR   + gamma^(Steps-1)*data(Trials).r(Steps);
      end; 
      
      dJdtheta = dJdtheta + dSumPi * sumR;
   end;
   
   
   if(gamma==1)
      dJdtheta = dJdtheta / i;
	else      
      dJdtheta = (1-gamma)*dJdtheta / max(size(data));
	end;    