pol.theta.sigma = 0.1;
J = expectedReward(pol);

% Show Results
figure(16); clf; sampling = 1;%maxUpdates/1;
subplot(1,2,1);
%plot(1:maxUpdates, -log(abs(-data.pg.J)), 'r'); hold on;
%plot(1:maxUpdates, -log(abs(-data.ng.J)), 'b'); hold on;
%plot(1:maxUpdates, repmat(-log(abs(-J)), maxUpdates, 1), 'b--');
barPlot(data.pg.J, data.pg.vJ, noTrials, maxUpdates, 'r', sampling);
barPlot(data.ng.J, data.ng.vJ, noTrials, maxUpdates, 'b', sampling);
plot(0:(maxUpdates-1), repmat(((J)), maxUpdates, 1), 'b--');

title('Expected return J(\pi_\theta) vs Updates');
xlabel('Updates');
ylabel('Expected return');

subplot(5,2,2);
title('Parameters vs Updates');

% Show Exploration
barPlot(data.pg.sigma, data.pg.vsigma, noTrials, maxUpdates, 'r', sampling);
barPlot(data.ng.sigma, data.ng.vsigma, noTrials, maxUpdates, 'b', sampling);
plot(0:(maxUpdates-1), pol.theta.sigma, 'b--');
ylabel(['Variance \sigma']);

% Show Gains
for i=1:N
    subplot(5,2,2+2*i);
    barPlot(data.pg.theta(:,i), data.pg.vtheta(:,i), noTrials, maxUpdates, 'r', sampling);
    barPlot(data.ng.theta(:,i), data.ng.vtheta(:,i), noTrials, maxUpdates, 'b', sampling);
    plot(0:(maxUpdates-1), repmat(pol.theta.k(i),1,maxUpdates), 'b--');
    ylabel(['Gain k_' num2str(i)]);
end;

xlabel('Updates');