function AA = estimateAllActionMatrix(policy, data)

	if(policy.type==1 | policy.type==2)
   	global N M gamma
      
      % OBTAIN ALL ACTION MATRIX
      for x=1:N
         Fisher(x).mat = zeros(size(DlogPiDTheta(policy, 1,1)*DlogPiDTheta(policy,1,1)'));
         for u=1:M
            Fisher(x).mat = Fisher(x).mat + pi_theta(policy,x,u)*DlogPiDTheta(policy,x,u)*DlogPiDTheta(policy,x,u)';
			end;
      end;            
      
      % OBTAIN GRADIENTS
      AA = zeros(size(Fisher(1).mat));
      i = 0;
		for Trials = 1 : max(size(data))   
         for Steps = 1 : max(size(data(Trials).u))
            x  = data(Trials).x(Steps);             
            AA = AA + gamma^(Steps-1)*Fisher(x).mat;
            i  = i + 1;
	      end;             
      end;    
   elseif(policy.type==3)
      global N gamma
      AA = zeros(N+1,N+1);
      i = 0;
		for Trials = 1 : max(size(data))   
         for Steps = 1 : max(size(data(Trials).u))
            x  = data(Trials).x(Steps);             
            FisherMat = [x*x' zeros(N,1); zeros(1,N) 2]*(1/policy.theta.sigma^2);
            AA = AA + gamma^(Steps-1)*FisherMat;
            i  = i + 1;
	      end;             
      end;    
   end;  
   
   if(gamma==1)
  	   AA = AA / i;
	else      
      AA = (1-gamma)*AA / max(size(data));
	end;          
   