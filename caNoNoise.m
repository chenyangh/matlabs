% Generate pattern
numSteps = 101;
rule = 60;
pattern = elementaryCellularAutomata(rule,numSteps);
[m ,n] = size(pattern);
%% generate input out put
input = [];
target = [];
length_pattern = 3;
for i = 1 : m-1
    for j = 1 : n - 3 + 1
        input = [input;pattern(i,j:j+2)];
        target = [target;pattern(i+1,j+1)];   
    end
end
%% the network trained with 100 hidden neurons
out = zeros(m-1,n);

for i = 1 : 100
    for j = 1 : n - 3 + 1
        out(i,j+1) = out(i,j+1) + myNeuralNetworkFunction2(pattern(i,j:j+2) );
    end
end


%% adjust 
out(:,5:end-4) = out(:,5:end-4)/5;
out(:,4) = out(:,4) / 4; out(:,end - 3) = out(:,end - 3) / 4;
out(:,3) = out(:,3) / 3; out(:,end - 2) = out(:,end - 2) / 3;
out(:,2) = out(:,2) / 2; out(:,end - 1) = out(:,end - 1) / 2;


%% cut imgs
pattern = pattern(:,100:199);
out = out(:,100:199);
%% test threhold
bw = im2bw(out,0.015);
imagesc(bw)
%% plot
figure
subplot(1,2,1);
imagesc(pattern)

subplot(1,2,2);
imagesc(out)



