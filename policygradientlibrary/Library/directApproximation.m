function w = directApproximation(policy, data)

	 global gamma

 	 % OBTAIN EXPECTED RETURN
	 J = 0;
	 if(gamma==1)
	    for Trials = 1 : max(size(data))   
   	    J = J + sum(data(Trials).r)/max(size(data(Trials).r));
	    end   
   	 J = J / max(size(data));
    end;
    
    % OBTAIN GRADIENTS
    i=1;  
    for Trials = 1 : max(size(data))   
       ende = max(size(data(Trials).u));
       for Steps = 1 : ende
            x = data(Trials).x(:,Steps); u = data(Trials).u(Steps); i = i+1;
            
            Mat(i,:) = DlogPiDTheta(policy, x,u)';
            %Vec(i,1) = QFnc(policy,x,u);
            Vec(i,1) = sum((gamma.^(0:(ende-Steps))).*data(Trials).r(Steps:ende))-J*(ende-Steps+1);
	    end;             
    end;            
    
    w = pinv(Mat)*Vec;
