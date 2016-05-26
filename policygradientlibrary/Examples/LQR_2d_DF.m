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

% Select initial policy
policy.theta.k     = -0.5; % Set controller gains...
policy.theta.sigma =  0.1; % Set controller variance...

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3. Obtaining the Foundations
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

% Determine optimal policy
optimalPolicy = optimalSolution(policy); 

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 4. Obtaining the Gradients
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Used Algorithms
nrAlgorithms  = 12; 

% Policy Gradient Estimators
titel(1).name = 'True Policy Gradient \partialJ(\pi_\theta)/\partial\theta';
titel(2).name = 'Non-episodic REINFORCE';
titel(3).name = 'Episodic REINFORCE';
titel(4).name = 'GPOMDP';
titel(5).name = 'Policy Gradient Theorem Estimator';
titel(6).name = 'All-Action Gradient Estimator';

% Natural Policy Gradient Estimators
titel(7).name  = 'True Natural Policy Gradient';
titel(8).name  = 'Direct Approximation';
titel(9).name  = 'Actor-Critic Method';
titel(10).name = 'Advantage TD Learning';
titel(11).name = 'Sample Path Learning';
titel(12).name = 'SARSA';

% Draw expected reward landscape
figure(1); clf; figure(2); clf;
for plotNr=1:nrAlgorithms
   if(plotNr<7) figure(1); else figure(2); end;
   subplot(2,3,mod(plotNr-1,6)+1);
   contour(-1.7:(+1.6/10):-0.1, 0:(1/10):1, J_pi, 20);
	colormap lines; hold on;
	ylabel('Controller variance \theta_2=\sigma');
	xlabel('Controller gain \theta_1=k');
	title(titel(plotNr).name);
	plot(optimalPolicy.theta.k, optimalPolicy.theta.sigma, 'w*');
	plot(optimalPolicy.theta.k, optimalPolicy.theta.sigma, 'ks');
end;

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
    
    % Policy Gradients in Figure 1    
    figure(1);
    
    % Calculate true Policy Gradient
    dJdtheta = policyGradient(policy);
    subplot(2,3,1); hold on; arrow(theta, l_arrows*dJdtheta/sqrt(0.00001+sum(dJdtheta.^2)), 'r');
      
	 % Non-Episodic REINFORCE        
    dJdtheta = nonepisodicREINFORCE(policy, data);
    subplot(2,3,2); hold on; arrow(theta, l_arrows*dJdtheta/sqrt(0.00001+sum(dJdtheta.^2)), 'r');    
    
	 % Episodic REINFORCE        
    dJdtheta = episodicREINFORCE(policy, data);
    subplot(2,3,3); hold on; arrow(theta, l_arrows*dJdtheta/sqrt(0.00001+sum(dJdtheta.^2)), 'r');    
        
	 % GPOMDP       
    dJdtheta = GPOMDP(policy, data);
    subplot(2,3,4); hold on; arrow(theta, l_arrows*dJdtheta/sqrt(0.00001+sum(dJdtheta.^2)), 'r');      
  
    % Sample Based Policy Gradient Theorem
    dJdtheta = SampleBasedGradient(policy, data);
    subplot(2,3,5); hold on; arrow(theta, l_arrows*dJdtheta/sqrt(0.00001+sum(dJdtheta.^2)), 'r');                      
    
    % All-Action Gradient, Sample-Based
    dJdtheta = AllActionGradient(policy, data);
    subplot(2,3,6); hold on; arrow(theta, l_arrows*dJdtheta/sqrt(0.00001+sum(dJdtheta.^2)), 'r');                              

    
    % Natural Policy Gradients in Figure 2
    figure(2);
    
    % Calculate true Natural Policy Gradient
    w = naturalPolicyGradient(policy);
    subplot(2,3,1); hold on; arrow(theta, l_arrows*w/sqrt(0.00001+sum(w.^2)), 'r');    
    
    % Direct Approximation
    w = directApproximation(policy,data);
    subplot(2,3,2); hold on; arrow(theta, l_arrows*w/sqrt(0.00001+sum(w.^2)), 'r');    
    
    % Actor-Critic Learning
    w = ActorCritic(policy,data);
    subplot(2,3,3); hold on; arrow(theta, l_arrows*w/sqrt(0.00001+sum(w.^2)), 'r');
    
    % Advantage TD Learning
    w = advantageTDLearning(policy, data);
    subplot(2,3,4); hold on; arrow(theta, l_arrows*w/sqrt(0.00001+sum(w.^2)), 'r');    
    
    % Sample Path Learning
    w = samplePathLearning(policy, data);
    subplot(2,3,5); hold on; arrow(theta, l_arrows*w/sqrt(0.00001+sum(w.^2)), 'r');    
    
    % SARSA
    w = newMethod(policy, data);
    subplot(2,3,6); hold on; arrow(theta, l_arrows*w/sqrt(0.00001+sum(w.^2)), 'r');            
    
  end;
end;

