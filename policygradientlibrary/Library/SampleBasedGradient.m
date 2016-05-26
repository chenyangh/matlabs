function dJdtheta = SampleBasedGradient(policy, data)

 	 global N M gamma
      
    % OBTAIN VALUE FUNCTION
    [V,Q,J] = learnValueFunction(policy, data);
      
    % OBTAIN GRADIENTS
    dJdtheta = zeros(size(DlogPiDTheta(policy, 1, 1))); i=0;
    for Trials = 1 : max(size(data))   
       for Steps = 1 : max(size(data(Trials).u))
            x = data(Trials).x(Steps); u = data(Trials).u(Steps); i = i+1;
            
				dlogpidtheta = DlogPiDTheta(policy, x,u);
            rew      = (data(Trials).r(Steps)-J+gamma*V(Trials,Steps+1) - V(Trials, Steps));
         	dJdtheta = dJdtheta + gamma^(Steps-1)*dlogpidtheta* rew;
	    end;             
    end;            
       
	 if(gamma==1)
   	   dJdtheta = dJdtheta / i;
	 else      
   	   dJdtheta = (1-gamma)*dJdtheta / max(size(data));
	 end;          
      
   