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


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Expected return
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(0)
% Calculate the map of expected rewards ...
for i=0:10
    % Set controller gain
    policy.theta.k = -0.1 - 1.6*(10-i)/10;

    for j=0:10
        % Set controller variance
        policy.theta.sigma = j/10;

        % Obtain expected reward
        J_pi(j+1, i+1) = expectedReturn(policy);
    end;
end;

% Show map of expected rewards...
figure(2);
maxi=max(max(J_pi)); mini=min(min(J_pi));
LineHght = ((0:0.025:1)*(maxi-mini) + mini);
contourf(-1.7:(+1.6/10):-0.1, 0:(1/10):1, J_pi, LineHght);
colormap hot; hold on;
xlabel('Controller variance \theta_2=\sigma');
ylabel('Controller gain \theta_1=k');
title('Expected reward J(\pi_\theta)');

% Determine optimal policy
optimalPolicy = optimalSolution(policy); 

% Show optimal policy
plot(optimalPolicy.theta.k, optimalPolicy.theta.sigma, 'w*');
plot(optimalPolicy.theta.k, optimalPolicy.theta.sigma, 'ks');
end;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Expected return
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Select initial policy
policy.theta.k     = -0.2; % Set controller gains...
policy.theta.sigma =  0.1; % Set controller variance...
alpha = 5; beta = 0.5; w = zeros(2,1); g = w; gn = ones(2,1);

for t=1:20
    g  = gn;                            % Last gradient
    data = obtainData(policy,100,5);
    gn = samplePathLearning(policy,data); % Current gradient    
    
    beta = 0;%(norm(gn,2)/norm(g,2))^2;    % Fletcher-Reeves
    %beta = ((gn-g)'*gn)/(g'*g)
    w = gn + beta*w;
    policy.theta.k     = policy.theta.k + alpha*w(1);
    policy.theta.sigma = policy.theta.sigma + alpha*w(2);
    paramet(:,t) = [policy.theta.k;policy.theta.sigma];
end;

plot(paramet(1,:),paramet(2,:),'k.');