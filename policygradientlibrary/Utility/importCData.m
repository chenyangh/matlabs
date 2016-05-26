% test_shit
global N M gamma
N=2; M=2; gamma = 0.9;

clear dat

load data.dat

for i=1:size(data,1)
    dat(data(i,5)).x(data(i,6)) = data(i,1);
    dat(data(i,5)).u(data(i,6)) = data(i,2);
    dat(data(i,5)).r(data(i,6)) = data(i,4);
    dat(data(i,5)).x(data(i,6)+1) = data(i,3);
end;

policy.theta = [0.43 0.67];
policy.type  = 1;

disp('Non-episodic REINFORCE');
%dJdtheta = nonepisodicREINFORCE(policy, dat)

disp('Episodic REINFORCE');
%dJdtheta = episodicREINFORCE(policy, dat)

disp('G(PO)MDP');
%dJdtheta = GPOMDP(policy, dat)

disp('Actor Critic');
%dJdtheta = ActorCritic(policy,dat)

disp('Sample Path Learning');
dJdtheta = samplePathLearning(policy,dat)