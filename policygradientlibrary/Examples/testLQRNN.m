% Declare global variables 
global N A b Q R my0 S0 gamma  

% Set problem size 
N = 1;  % Set the dimensionality of the states 

% Start state distribution
my0 = 0.3*ones(N,1);
S0  = 0.0001*eye(N);

% Transition matrix A and coupling vector b
A = eye(N);
b = ones(N,1); 

% Reward matrix Q and scalar R 
Q = 1;
R = 0.1;

% Discounted reward formulation
gamma = 1;

initializeLQRProblem;

% Select a Gauss policy
policy = initGaussPolicy;

% Select initial policy
policy.theta.k     = -0.5; % Set controller gains...
policy.theta.sigma =  0.1; % Set controller variance...

% Obtain Data
data  = obtainData(policy, 100, 1);

w = naturalPolicyGradient(policy)

%function w = estimateNG(policy, data)
    sigma = std(data(1).x);
    i = 1;
    for trial=1:max(size(data))
        for time = 1:max(size(data(1).r))
            x = data(trial).x(:,time);
            u = data(trial).u(time);
            
            % P = DlogPI DlogDPI 
            %der(1,1) = (x-0)/(sigma^2);
            der(1,1) = ((x-0)^2-sigma^2)/(sigma^3);      
            
            P(i,:) = [DlogPiDTheta(policy, x,u);der;1]';  
            r(i,1) = data(trial).r(time);
            
            i = i+1;            
        end;
    end;
   
    w = inv(P'*P)*P'*r