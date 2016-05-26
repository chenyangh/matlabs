function w = learnThroughValueFunction(policy, data)

     global gamma

    % OBTAIN VALUE FUNCTION
    [V,Q,J] = learnValueFunction(policy, data);
      
    % OBTAIN GRADIENTS
    i=1;  
    for Trials = 1 : max(size(data))   
       for Steps = 1 : max(size(data(Trials).u))
            x = data(Trials).x(:,Steps); u = data(Trials).u(Steps); i = i+1;
            
            Mat(i,:) = DlogPiDTheta(policy, x,u)';
            Vec(i,1) = (data(Trials).r(Steps)-J+gamma*V(Trials,Steps+1) - V(Trials, Steps));
        end;             
    end;    
    
    w = inv(Mat'*Mat)*Mat'*Vec;

    
    
