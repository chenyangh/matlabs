function [P,F] = policyEvaluation(policy, data, learningrate, lambda, delta)

   if(policy.type==3)
        global N gamma
               
        % NUMBER OF STEPS
        numSteps = max(size(data(1).u));
        
        % Initial Values
        M    = max(size([-0.5*mix(data(1).x(:,1)*data(1).x(:,1)') 0.5]')); 
        b    = zeros(M, 1);
        Binv = inv(delta*eye(M,M));
        A    = zeros(M,M);
        z    = zeros(M,1);
        pars = zeros(M,1);
        
        % DETERMINE PARAMETERS  
        for Steps = 1 : (numSteps-1)
           % COMPUTE STEP PARAMETERS 
           x    = data(1).x(:,Steps); 
           xn   = data(1).x(:,Steps+1);
           rew  = data(1).r(Steps);

           phi  = [-0.5*mix(x*x')   -0.5]';
           phin = [-0.5*mix(xn*xn') -0.5]';
           
           % COMPUTE \lambda-LSPE PARAMETERS
           Binv = Binv - (Binv*phin*phin'*Binv) / (1 + phin'*Binv*phin);
           z    = gamma*lambda*z + phin;
           A    = A + z*(gamma*phin' - phi');
           b    = b + z*rew;
           
           % COMPUTE VALUE FUNCTION PARAMETERS
           pars = pars + learningrate*Binv*(A*pars+b);
        end;                
   end;      
   F = pars(max(size(pars)));
   P = demix(pars(1:(max(size(pars))-1)));
   
       
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
     
      
   

