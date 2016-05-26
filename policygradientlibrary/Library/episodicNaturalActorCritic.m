function w = episodicNaturalActorCritic(policy, data)

	 global gamma N

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
       Mat(i,:) = [zeros(size(DlogPiDTheta(policy, data(Trials).x(:,1),data(Trials).u(1))')) 1];
	   Vec(i,1) = 0;       

       for Steps = 1 : max(size(data(Trials).u))
            x = data(Trials).x(:,Steps); u = data(Trials).u(Steps); 
            
            Mat(i,:) = Mat(i,:) + gamma^(Steps-1)*[DlogPiDTheta(policy, x,u)' 0];
            Vec(i,1) = Vec(i,1) + gamma^(Steps-1)*(data(Trials).r(Steps)-J);
       end; 
       i = i+1;  
    end;            
    cond(Mat) 
    
    Nrm = diag([1./std(Mat(:,1:(N+1)),0,1),1]);
    w = Nrm*inv(Nrm*Mat'*Mat*Nrm)*Nrm*Mat'*Vec;
    w = w(1:(max(size(w)-1)));