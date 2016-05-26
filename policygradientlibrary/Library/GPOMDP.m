function dJdtheta = GPOMDP(policy, data)

	global N gamma
   
    i = 0; j = 0;
    dJdtheta = zeros(size(DlogPiDTheta(policy,data(1).x(:,1),1)));
	for Trials = 1 : max(size(data))
		dSumPi = zeros(size(DlogPiDTheta(policy,data(1).x(:,1),1)));
		sumR   = 0;
   
      for Steps = 1 : max(size(data(Trials).u))
         dSumPi = dSumPi + DlogPiDTheta(policy, data(Trials).x(:,Steps), data(Trials).u(Steps));
         rew    = gamma^(Steps-1)*data(Trials).r(Steps);
         dJdtheta = dJdtheta + dSumPi * rew;   
         j = j + 1;
      end;       
      i = i + 1;
   end;
      
   if(gamma==1)
      dJdtheta = dJdtheta / j;
	else      
      dJdtheta = (1-gamma)*dJdtheta / i;
	end;    