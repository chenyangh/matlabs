function w = advantageTDLearning(policy, data)

    if(policy.type==1 | policy.type==2)
    global N M gamma
      
      % OBTAIN VALUE FUNCTION
      i = 1;      
        for Trials = 1 : max(size(data))
         for Steps = 1 : max(size(data(Trials).u))
            x = data(Trials).x(Steps); u = data(Trials).u(Steps); xn = data(Trials).x(Steps+1);
            
            Phi          = zeros(N,1);
            Phi(x,1)  = 1;
            Phi(xn,1) = Phi(xn,1)-gamma;            
            der      = DlogPiDTheta(policy, x,u);
            
            Mat(i,:)     = [Phi' der'];
            Vec(i,1)  = data(Trials).r(Steps);
            i = i+1;
          end; 
      end;      
      if(gamma==1) J=mean(Vec); else J=0; end;
      w = pinv(Mat)*(Vec-J);
      w = w((N+1):max(size(w)));            
   elseif(policy.type==3)
          global N gamma Mat
          
        % DETERMINE PARAMETERS  
        i = 1;  
        if(gamma==1) Fb=[]; else Fb=-0.5; end;  
          for Trials = 1 : max(size(data))
             for Steps = 1 : max(size(data(Trials).u))
                x(1:N,1) = data(Trials).x(1:N,Steps); 
                u = data(Trials).u(Steps); 
                xn(1:N,1) = data(Trials).x(1:N,Steps+1);%+normrnd(0,0.1);
                der  = DlogPiDTheta(policy, x,u);
                
                Phi   = [-0.5*mix(x*x')+gamma*0.5*mix(xn*xn') (-1+gamma) der'];
                Mat(i,:) = Phi;
                Vec(i,1) = data(Trials).r(Steps);
                i = i+1;
              end;                
          end;        
          if(gamma==1) J=mean(rr); else J=0; end;
          pars = ridge(Vec-J, Mat, 10^-9);
        w = pars((max(size(pars)) - max(size(der)-1)):max(size(pars)));
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
