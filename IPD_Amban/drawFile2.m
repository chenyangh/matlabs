av_files = dir('*.txt');
A = zeros(500,length(av_files));
for i = 1: length(av_files)
    fileName = av_files(i).name;
    A(:,i) = textread(fileName, '%f','delimiter', '\n');
    
end

hold on
figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1);
hold(axes1,'all');

% Create multiple lines using matrix input to plot
plot1 = plot(A,'Parent',axes1);
set(plot1(1),'LineWidth',0.8,'Color','k','DisplayName',av_files(2).name(1:end-4));
set(plot1(2),'LineWidth',1.5,'Color','r','DisplayName',av_files(1).name(1:end-4));
%set(plot1(3),'LineWidth',3.0,'Color','r','DisplayName',av_files(3).name(1:end-4));
%set(plot1(4),'LineWidth',0.8,'Color','g','DisplayName',av_files(4).name(1:end-4));
pbaspect([16,9,1])
ylim([0,4])
% Create legend
legend(axes1,'show');