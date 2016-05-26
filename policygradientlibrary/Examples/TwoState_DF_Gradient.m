% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%            Discrete Problems Library: Two-State Example
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Programmed by Jan Peters. Requires Matlab 5.3.0 and higher. If 
% the results used in any publication, a reference to the paper
% would be highly appreciated.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Problem settings:
% - Discounted reward formulation
% - Decision border policy
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. Encoding the Problem
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This part encodes the size of the problem, the transition tables, 
% the reward tables, and the discount factor (so implicitly also the
% usage of the discounted formulation.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global N M p p0 r gamma

% Set problem size
N = 2;  % Set number of states 
M = 2;  % Set number of actions   

% Start state distribution
p0(1) = 0.5;
p0(2) = 0.5;

% Transition table p(x, u, x') -> [0, 1]
p(1,1,1) = 1; p(1,2,1) = 0;
p(1,2,2) = 1; p(1,1,2) = 0;

p(2,1,1) = 1; p(2,2,1) = 0; 
p(2,2,2) = 1; p(2,1,2) = 0; 

% Reward table r(x, u) -> IR
r(1,1) = 2;   r(1,2) = 0; 
r(2,1) = 0;   r(2,2) = 1; 

% Discounted reward formulation
gamma=0.9;

% Initialize problem
initializeDiscreteProblem;

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2. Encoding the Policy
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This part selects the stochastic policy; we have specified a 
% decision border border policy and some initial parameterization.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Select a decision border policy
policy = initDecisionBorderPolicy;

% Select initial policy
policy.theta = [0.43 0.67];

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3. Obtaining the Foundations
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This part demonstrates the usage of stationary and discounted 
% distributions; it draws the map of the expected reward and marks
% the optimal solution in it; you can also obtain value and 
% advantage functions.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Expected Reward

% Calculate the map of average rewards ... 
for i=0:10
   for j=0:10
      % Set policy parameters
      policy.theta = [i/10 j/10];
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

policy.theta = [0.43 0.67];
data  = obtainData(policy, 50, 6);
q=1;
disp(titel(q).name); q = q + 1; 
    dJdtheta = policyGradient(policy) 
disp(titel(q).name); q = q + 1; 
    dJdtheta = nonepisodicREINFORCE(policy, data)
disp(titel(q).name); q = q + 1;
    dJdtheta = episodicREINFORCE(policy, data)
disp(titel(q).name); q = q + 1;
    dJdtheta = GPOMDP(policy, data)
disp(titel(q).name); q = q + 1;
    dJdtheta = SampleBasedGradient(policy, data)
disp(titel(q).name); q = q + 1;
    dJdtheta = AllActionGradient(policy, data)
disp(titel(q).name); q = q + 1;
    w = naturalPolicyGradient(policy)
disp(titel(q).name); q = q + 1;
    w = directApproximation(policy,data)
disp(titel(q).name); q = q + 1;
    w = ActorCritic(policy,data)
disp(titel(q).name); q = q + 1;
    w = advantageTDLearning(policy, data)
disp(titel(q).name); q = q + 1;
    w = samplePathLearning(policy, data)
disp(titel(q).name); q = q + 1;
    w = SARSA(policy, data)
    
% Draw expected reward landscape
figure(1); clf; figure(2); clf;
for plotNr=1:nrAlgorithms
   if(plotNr<7) figure(1); else figure(2); end;
	subplot(2,3,mod(plotNr-1,6)+1);
	contour(0:0.1:1, 0:0.1:1, J_pi, 6, 'k');
	colormap lines; hold on;
	xlabel('Parameter \theta_2');
	ylabel('Parameter \theta_1');
	title(titel(plotNr).name);
	plot(optimalPolicy.theta(1), optimalPolicy.theta(2), 'w*');
	plot(optimalPolicy.theta(1), optimalPolicy.theta(2), 'ks');
end;

% Calculate and draw the gradients
n_arrows = 5; l_arrows = 0.5/n_arrows;
for i=1:n_arrows
  for j=1:n_arrows
    policy.theta = [admissable(i/(n_arrows+1)) admissable(j/(n_arrows+1))];
    
    % Obtain Data
    data  = obtainData(policy, 50, 6);
    
    % Policy Gradients in Figure 1    
    figure(1);
    
    % Calculate true Policy Gradient
    dJdtheta = policyGradient(policy);
    subplot(2,3,1); hold on; arrow(policy.theta, l_arrows*dJdtheta, 'r');
    
	 % Non-Episodic REINFORCE        
    dJdtheta = nonepisodicREINFORCE(policy, data);
    subplot(2,3,2); hold on; arrow(policy.theta, l_arrows*dJdtheta, 'r');   
        
	 % Episodic REINFORCE        
    dJdtheta = episodicREINFORCE(policy, data);
    subplot(2,3,3); hold on; arrow(policy.theta, l_arrows*dJdtheta, 'r');
        
	 % GPOMDP       
    dJdtheta = GPOMDP(policy, data);
    subplot(2,3,4); hold on; arrow(policy.theta, l_arrows*dJdtheta, 'r');                  
    
	 % Sample Based Policy Gradient Theorem
    dJdtheta = SampleBasedGradient(policy, data);
    subplot(2,3,5); hold on; arrow(policy.theta, l_arrows*dJdtheta, 'r');                      
    
    % All-Action Gradient, Sample-Based
    dJdtheta = AllActionGradient(policy, data);
    subplot(2,3,6); hold on; arrow(policy.theta, l_arrows*dJdtheta, 'r');                              
    
    % Natural Policy Gradients in Figure 2
    figure(2);
    
    % Calculate true Natural Policy Gradient
    w = naturalPolicyGradient(policy);
    subplot(2,3,1); hold on; arrow(policy.theta, l_arrows*w, 'r');
    
    % Direct Approximation
    w = directApproximation(policy,data);
    subplot(2,3,2); hold on; arrow(policy.theta, l_arrows*w, 'r');    
    
    % Actor-Critic Learning
    w = ActorCritic(policy,data);
    subplot(2,3,3); hold on; arrow(policy.theta, l_arrows*w, 'r');
    
    % Advantage TD Learning
    w = advantageTDLearning(policy, data);
    subplot(2,3,4); hold on; arrow(policy.theta, l_arrows*w, 'r');    
    
    % Sample Path Learning
    w = samplePathLearning(policy, data);
    subplot(2,3,5); hold on; arrow(policy.theta, l_arrows*w, 'r');    
    
    % SARSA
    w = SARSA(policy, data);
    subplot(2,3,6); hold on; arrow(policy.theta, l_arrows*w, 'r');            
  end;
end;
