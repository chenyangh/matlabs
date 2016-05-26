function w = SARSA(policy, data)

	 global gamma

    % OBTAIN VALUE FUNCTION
    [V,Q,J] = learnValueFunction(policy, data);
      
    % OBTAIN GRADIENTS
    i=1;  
    for Trials = 1 : max(size(data))   
       for Steps = 1 : max(size(data(Trials).u)-1)
            x = data(Trials).x(Steps); u = data(Trials).u(Steps); i = i+1;
            
            Mat(i,:) = DlogPiDTheta(policy, x,u)';
            Vec(i,1) = (data(Trials).r(Steps)-J+gamma*Q(Trials,Steps+1) - Q(Trials, Steps));
	    end;             
    end;            
    
    w = pinv(Mat)*Vec;
