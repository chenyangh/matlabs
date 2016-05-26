% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%            LQR Problems Library: 1-d Example
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Programmed by Jan Peters. Requires Matlab 5.3.0 and higher. If 
% the results used in any publication, a reference to the paper
% would be highly appreciated.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Problem settings:
% - Discounted reward formulation
% - Gaussian policy
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%clear all;

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. Encoding the Problem
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
gamma = 0.95;

initializeLQRProblem;

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2. Encoding the Policy
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Select a Gauss policy
policy = initGaussPolicy;

% Select initial policy
policy.theta.k     = -0.5; % Set controller gains...
policy.theta.sigma =  0.1; % Set controller variance...

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3. Obtaining the Foundations
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Stationary and Discounted Distribution
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Get state distributions...
for index=1:81
    x(index) = 0.5*(index - 41) / 40;
    dstat(index) = stationaryDistribution(policy, x(index));
    ddisc(index) = discountedDistribution(policy, x(index));
end;

% Show state distributions...
figure(1); clf;
subplot(1,2,1); plot(x, dstat);
title('Stationary Distribution d^{\pi_\theta}(x)');
xlabel('State x'); ylabel('d^{\pi_\theta}(x)');
subplot(1,2,2); plot(x, ddisc);
title('Discounted Distribution d^{\pi_\theta}_\gamma(x|N(\mu_0=0.3, \Sigma_0=10^{-3})');
xlabel('State x'); ylabel('d^{\pi_\theta}_\gamma(x|N(\mu_0=0.3, \Sigma_0=10^{-3})');

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Expected return
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Value and advantage function
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Select initial policy
policy.theta.k     = -0.5; % Set controller gains...
policy.theta.sigma =  0.1; % Set controller variance...

% Calculate Value Functions
for indexX=1:81
    x(indexX) = -5+10*(indexX-1) / 80;
   
    VT(indexX) = VFnc(policy, x(indexX));
    for indexU=1:81
        u(indexU)        = -5+10*(indexU-1)/80;
       
        QT(indexX,indexU) = QFnc(policy, x(indexX), u(indexU));
        AT(indexX,indexU) = AFnc(policy, x(indexX), u(indexU));
    end;
end;

% Plot the Value/Advantage Functions
figure(3); clf; colormap hot;
subplot(1,3,1); plot(x, VT);
title('State Value Function V^\pi(x)');
ylabel('V^\pi(x)'); xlabel('State x');
subplot(2,3,2); contourf(x,u,QT');
title('State-Action Value Function Q^\pi(x,u)');
ylabel('Action u'); xlabel('State x');
subplot(2,3,5); surf(x,u,QT');
title('State-Action Value Function Q^\pi(x,u)');
ylabel('Action u'); xlabel('State x'); zlabel('Q^\pi(x,u)');
subplot(2,3,3); contourf(x,u,AT');
title('Advantage Function A^\pi(x,u)');
ylabel('Action u'); xlabel('State x');
subplot(2,3,6); surf(x,u,AT');
title('Advantage Function A^\pi(x,u)');
zlabel('A^\pi(x,u)'); ylabel('Action u'); xlabel('State x');

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 4. Obtaining the Gradients
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Draw expected reward landscape
figure(4); clf;
subplot(1,2,1);
contour(-1.7:(+1.6/10):-0.1, 0:(1/10):1, J_pi, 20);
colormap lines; hold on;
xlabel('Controller variance \theta_2=\sigma');
ylabel('Controller gain \theta_1=k');
title('Policy Gradient \partialJ(\pi_\theta)/\partial\theta');
subplot(1,2,2);
contour(-1.7:(+1.6/10):-0.1, 0:(1/10):1, J_pi, 20);
colormap lines; hold on;
xlabel('Controller variance \theta_2=\sigma');
ylabel('Controller gain \theta_1=k');
title('Natural Policy Gradient w_\theta');

% Calculate and draw the gradients
n_arrows = 10; l_arrows = 1/n_arrows;
for i=0:n_arrows
  % Set controller gain
  policy.theta.k = -2*(n_arrows-i)/n_arrows;

  for j=0:n_arrows
    policy.theta.sigma = j/n_arrows;    
    theta = [policy.theta.k policy.theta.sigma];
    
    theta = [policy.theta.k policy.theta.sigma];

    % Calculate Policy Gradient
    dJdtheta = policyGradient(policy);

    % Show Policy Gradient
    subplot(1,2,1);
    arrow(theta, l_arrows*...
         dJdtheta/sqrt(0.00001+sum(dJdtheta.^2)), 'r');

    % Calculate Natural Gradient
    w = naturalPolicyGradient(policy);

    % Show Policy Gradient
    subplot(1,2,2);
    arrow(theta,l_arrows*w/sqrt(0.00001^2+sum(w.^2)),'r');
  end;
end;

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 5. Following the Gradients
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Select initial policy
policy.theta.k     = -0.1; % Set controller gains...
policy.theta.sigma =  0.9; % Set controller variance...

% Create two more policies
policy1 = policy;
policy2 = policy;

subplot(1,2,1); 

% Simulate learning process for policy1 with the policy gradient
while(policy1.theta.sigma>=0.1)
      % Calculate Policy Gradient
      dJdtheta = policyGradient(policy1);                        
      
      % Show desired update
      arrow([policy1.theta.k policy1.theta.sigma], 0.025*dJdtheta, 'b');      
      
   	%Update policy   
      policy1.theta.k = policy1.theta.k + 0.025*dJdtheta(1:N);                                          
      policy1.theta.sigma = policy1.theta.sigma + 0.025*dJdtheta(N+1);                                                
 end;	      
 
subplot(1,2,2);  
 
% Simulate learning process for policy2 with the policy gradient
while(policy2.theta.sigma>=0.1)
      % Calculate Policy Gradient
      w = naturalPolicyGradient(policy2);                        
      
      % Show desired update
      arrow([policy2.theta.k policy2.theta.sigma], 0.025*w, 'm');      
      
   	%Update policy   
      policy2.theta.k = policy2.theta.k + 0.025*w(1:N);                                         
      policy2.theta.sigma = policy2.theta.sigma + 0.025*w(N+1);   
 end;	      