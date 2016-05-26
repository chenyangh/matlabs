function [V,Q,J,P,F] = learnValueFunction(policy, data)

    if(policy.type==1 | policy.type==2)
    global N M gamma
      
      % OBTAIN VALUE FUNCTION
      i = 1;      
      Phi(1, 1:N) = 0;
      PPhi(1, 1:N) = 0;
      for Trials = 1 : max(size(data))
         for Steps = 1 : max(size(data(Trials).u))
            Phi(i,data(Trials).x(Steps))    = 1;
            PPhi(i,data(Trials).x(Steps+1)) = 1;            
            rr(i)                                 = data(Trials).r(Steps);
            i = i+1;
          end; 
      end;      
      if(gamma==1) J=mean(rr); else J=0; end;
      VF = inv(Phi'*(Phi-gamma*PPhi)+10^-8*eye(N)*(gamma==1))*Phi'*(rr'-J);            
      
      i = 1;
      for Trials = 1 : max(size(data))
         for Steps = 1 : max(size(data(Trials).u))
            x = data(Trials).x(:,Steps); u = data(Trials).u(Steps);
            xn = data(Trials).x(:,Steps+1); rew = data(Trials).r(Steps);
            
            Mat(i, 1:(N*M))       = 0;
            Mat(i, selGibbs(x,u)) = 1;            
            Vec(i,1) = rew + gamma*VF(xn);
            i = i+1;
          end; 
      end;      
      QF = pinv(Mat)*Vec;
      
      for Trials = 1 : max(size(data))
         for Steps = 1 : max(size(data(Trials).x))
            x = data(Trials).x(Steps); 
            V(Trials, Steps) = VF(x);
            Q(Trials, Steps) = QF(selGibbs(x,u));
         end;                
      end;             
   elseif(policy.type==3)
          global N gamma
          
        % DETERMINE PARAMETERS  
        i = 1;  
        if(gamma==1) Fb=[]; else Fb=-0.5; end;  
          for Trials = 1 : max(size(data))
             for Steps = 1 : max(size(data(Trials).u))
               x = data(Trials).x(:,Steps); xn = data(Trials).x(:,Steps+1);
               Phi(i,1:(0.5*N*(N+1)+1))  = [-0.5*mix(x*x') Fb];
               PPhi(i,1:(0.5*N*(N+1)+1)) = [-0.5*mix(xn*xn') Fb];
               Phi(i,:)  = [-0.5*x'.^2 Fb];
               PPhi(i,:) = [-0.5*xn'.^2 Fb];
               
               rr(i)                     = data(Trials).r(Steps);
               i = i+1;
             end;                
          end;        
        if(gamma==1) J=mean(rr); else J=0; end;
        pars = inv((Phi-gamma*PPhi)'*(Phi-gamma*PPhi)+10^-8*eye(size(Phi'*Phi))*(gamma==1))*(Phi-gamma*PPhi)'*(rr'-J);
        F = pars(max(size(pars)));
        P = demix(pars(1:(max(size(pars))-1)));
        
        % DETERMINE VALUES
          for Trials = 1 : max(size(data))
             for Steps = 1 : max(size(data(Trials).u))
                x = data(Trials).x(:,Steps); u = data(Trials).u(Steps);
                xn = data(Trials).x(:,Steps+1); rew = data(Trials).r(Steps);
                V(Trials, Steps) = -0.5*x'*P*x - 0.5*F;
                Q(Trials, Steps) = rew + gamma*(-0.5*xn'*P*xn - 0.5*F);
             end;   
             x = data(Trials).x(:,Steps+1);
             V(Trials, Steps+1) = -0.5*x'*P*x - 0.5*F;             
          end;                        
   end;      
       
function vP = mix(mP)
    % Generates a vector from a matrix
    n = length(mP);
        
    c=0;    
    for i=1:n
        for j=1:i
            c=c+1;
            vP(c)=mP(i,j);
        end;            
    end;    
    
function mP = demix(vP)
    % Generates a vector usable for least squares
    m = max(size(vP));
    n = ceil(0.5*(sqrt(8*m+1)-1));
        
    c=0;    
    for i=1:n
        for j=1:i
            c=c+1;
            if(i==j)
               mP(i,i) = vP(c);
            else
               mP(i,j) = 0.5*vP(c);
               mP(j,i) = 0.5*vP(c);
            end;   
        end;            
    end;    
     
      
   
