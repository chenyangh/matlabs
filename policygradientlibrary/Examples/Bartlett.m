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
p(1,1,1) = 1/3; p(1,2,1) = 2/3;
p(1,2,2) = 1/3; p(1,1,2) = 2/3;

p(2,1,1) = 2/3; p(2,2,1) = 1/3; 
p(2,2,2) = 2/3; p(2,1,2) = 1/3; 

% Reward table r(x, u) -> IR
r(1,1) = 0;   r(1,2) = 0; 
r(2,1) = 1;   r(2,2) = 1; 

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
% Expected Reward

% Calculate the map of average rewards ... 
for i=0:10
   for j=0:10
      % Set policy parameters
      policy.theta = [i/10 j/10];
      J_pi(j+1, i+1) = expectedReturn(policy);                        
   end;
end;   

% Show the map of average rewards ... 
figure(2); clf; colormap hot;
contourf(0:0.1:1, 0:0.1:1, J_pi, 6); hold on;
xlabel('Parameter \theta_2');
ylabel('Parameter \theta_1');
title('Expected reward J(\pi_\theta)');

% Determine optimal policy
optimalPolicy = optimalSolution(policy); 

% Show optimal policy
plot(optimalPolicy.theta(1), optimalPolicy.theta(2), 'w*');
plot(optimalPolicy.theta(1), optimalPolicy.theta(2), 'ks');

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 4. Obtaining the Gradients
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Show the map of average rewards ... reuse old data
figure(4); clf;
if(0)
subplot(1,2,1); contour(0:0.1:1, 0:0.1:1, J_pi, 6); hold on;
title('Policy Gradient \partialJ(\pi_\theta)/\partial\theta');
xlabel('Parameter \theta_2');
ylabel('Parameter \theta_1');
plot(optimalPolicy.theta(1), optimalPolicy.theta(2), 'w*');
plot(optimalPolicy.theta(1), optimalPolicy.theta(2), 'ks');
subplot(1,2,2); 
end;

contour(0:0.1:1, 0:0.1:1, J_pi, 6); hold on;
title('Natural Policy Gradient w_\theta');
xlabel('Parameter \theta_2');
ylabel('Parameter \theta_1');
plot(optimalPolicy.theta(1), optimalPolicy.theta(2), 'w*');
plot(optimalPolicy.theta(1), optimalPolicy.theta(2), 'ks');

% Calculate and draw the gradients...
n_arrows = 5; l_arrows = 1/n_arrows;
for i=0:n_arrows
   for j=0:n_arrows
      % Set admissable policy parameters
      policy.theta = [admissable(i/n_arrows) admissable(j/n_arrows)];
if(0)      
      % Calculate Policy Gradient
      dJdtheta = policyGradient(policy);                        
      
      % Show Policy Gradient
      subplot(1,2,1); 
      arrow(policy.theta, l_arrows*dJdtheta/sqrt(sum(dJdtheta.^2)), 'r');
 %     subplot(1,2,2); 
      
  end;     
      data = obtainData(policy, 100,1);
      w = advantageTDLearning(policy, data);
      arrow(policy.theta, l_arrows*w/sqrt(sum(w.^2)), 'b');      
      
      w = approximateAdvantageTDLearning(policy, data);      
      arrow(policy.theta, l_arrows*w/sqrt(sum(w.^2)), 'g');      
      
  
      % Calculate Natural Gradient
      w = naturalPolicyGradient(policy); 
      arrow(policy.theta, l_arrows*w/sqrt(sum(w.^2)), 'r');      
   end;
end;   


if(0)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 4. Obtaining the Gradients
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Create four more policies
policy.theta = [0.1 0.9];
policy1 = policy;
policy2 = policy;

policy.theta = [0.1 0.5];
policy3 = policy;
policy4 = policy;

subplot(1,2,1); 

% Simulate learning process for policy1 with the policy gradient
while(isempty(find(policy1.theta<=0.005 | policy2.theta>=0.995)))
      % Calculate Policy Gradient
      dJdtheta = policyGradient(policy1);                        
      
      % Show desired update
      arrow(policy1.theta, 0.1*dJdtheta, 'b');      
      
   	%Update policy   
      policy1.theta = policy1.theta + 0.1*dJdtheta';                                          
 end;	      
 
 
% Simulate learning process for policy1 with the policy gradient
while(isempty(find(policy3.theta<=0.005 | policy3.theta>=0.995)))
      % Calculate Policy Gradient
      dJdtheta = policyGradient(policy3);                        
      
      % Show desired update
      arrow(policy3.theta, 0.1*dJdtheta, 'm');      
      
   	%Update policy   
      policy3.theta = policy3.theta + 0.1*dJdtheta';                                          
 end;	      
 
 
 
subplot(1,2,2); 

% Simulate learning process for policy1 with the policy gradient
while(isempty(find(policy2.theta<=0.0001 | policy2.theta>=0.9999)))
      % Calculate Policy Gradient
      w = naturalPolicyGradient(policy2); 
      
      % Show desired update
      arrow(policy2.theta, 0.1*w, 'b');      
      
   	%Update policy   
      policy2.theta = policy2.theta + 0.1*w';                                          
 end;	      
 
 % Simulate learning process for policy1 with the policy gradient
while(isempty(find(policy4.theta<=0.0001 | policy4.theta>=0.9999)))
      % Calculate Policy Gradient
      w = naturalPolicyGradient(policy4); 
      
      % Show desired update
      arrow(policy4.theta, 0.1*w, 'm');      
      
   	%Update policy   
      policy4.theta = policy4.theta + 0.1*w';                                          
 end;	      
end;