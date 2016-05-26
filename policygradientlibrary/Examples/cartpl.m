clear all;

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
gamma = 0.9;

initializeLQRProblem;

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2. Encoding the Policy
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Select a Gauss policy
policy = initGaussPolicy;

% Calculate and draw the gradients
n_arrows = 5; l_arrows = 1/n_arrows;
for i=0:n_arrows
  % Set controller gain
  policy.theta.k = -0.1 - 1.6*(n_arrows-i)/n_arrows;
  
  for j=0:n_arrows
    % Set controller parameters
    policy.theta.sigma = 0.1+j/n_arrows;    
    theta = [policy.theta.k policy.theta.sigma];
    
    % Obtain Data
    data  = obtainData(policy, 50, 6);
      
    % Natural Policy Gradients in Figure 2
    figure(2);
    
    % Calculate true Natural Policy Gradient
    w = naturalPolicyGradient(policy);
    hold on; arrow(theta, l_arrows*w/sqrt(0.00001+sum(w.^2)), 'r');    
    
    % Advantage TD Learning
    w = PTLSTD(policy, data);
    hold on; arrow(theta, l_arrows*w/sqrt(0.00001+sum(w.^2)), 'b');
  end;
end;

