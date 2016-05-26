function w = naturalActorCritic(policy, data)
      global N M gamma

      basis = [1,0; 0,1];
      Np = min(size(basis));
      
      % OBTAIN VALUE FUNCTION
      i = 1;      
        for Trials = 1 : max(size(data))
         for Steps = 1 : max(size(data(Trials).u))
            x = data(Trials).x(Steps); u = data(Trials).u(Steps); xn = data(Trials).x(Steps+1);

            der(1,1:2)  = DlogPiDTheta(policy, x,u)';
            Phi(i,1:(2+Np))  = [der,basis(x,:)];
            Phin(i,1:(2+Np)) = [zeros(size(der)),basis(xn,:)];            
            r(i,1) = data(Trials).r(Steps);
            
            i = i+1;
          end; 
      end;      
      if(gamma==1) J=mean(Vec); else J=0; end;
      
      Mat = Phi'*(Phi-gamma*Phin);
      Vec = Phi'*r;
      w = inv(Mat)*Vec;
      w = w(1:2);            
