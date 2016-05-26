function dJdtheta = nonepisodicREINFORCE(policy, data)

	global N gamma
   
    NN = 1; Npar = max(size(policy.theta));
    if(policy.type == 3) NN = N; Npar = N+1; end;
    
    dJdtheta = zeros(Npar,1); i=0;
	for Trials = 1 : max(size(data))   
      for Steps = 1 : max(size(data(Trials).u))
         dPi      = DlogPiDTheta(policy, data(Trials).x(1:NN,Steps), data(Trials).u(Steps));
         rew      = gamma^(Steps-1)*data(Trials).r(Steps);
         dJdtheta = dJdtheta + dPi * rew;         
      end;             
      i        = i + 1;
   end;
   
   if(gamma==1)
      dJdtheta = dJdtheta / i;
	else      
      dJdtheta = (1-gamma)*dJdtheta / i;
	end;      