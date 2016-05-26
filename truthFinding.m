figure
hold on
a1 = plot(1:length(avg_log), avg_log);
a2 = plot(1:length(cosine), cosine);
a3 = plot(1:length(investment), investment);
a4 = plot(1:length(pooled_investment), pooled_investment);
a5 = plot(1:length(sum), sum);
a6 = plot(1:length(truth_finder), truth_finder);
a7 = plot(1:length(two_estimate), two_estimate);
l1 = 'Average log';
l2 = 'Cosine';
l3 = 'Investment';
l4 = 'Pooled Investment';
l5 = 'Sum';
l6 = 'Truth Finder';
l7 = '2 Estimate';
legend([a1; a2; a3; a4; a5; a6; a7],l1, l2, l3, l4, l5, l6, l7);
