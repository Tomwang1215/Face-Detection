
tic
Accuracy = [];
wb = waitbar(0,'Training...');
for i = -10:10
    step = i+10;
    C = 2^i;
    ac = [];
    for j = 1:5
        label = TrainLabel;
        instance_matrix = TrainData;
        label(j:5:length(TrainData(:,1)),:) = [];
        instance_matrix(j:5:length(TrainData(:,1)),:) = [];
        linear_model = svmtrain(label,instance_matrix,sprintf('-t 0 -c %d -h 0',C));
        [~, a, ~] = svmpredict(TrainLabel(j:5:length(TrainData(:,1)),:), TrainData(j:5:length(TrainData(:,1)),:), linear_model);
        ac = [ac,a];
        o = step/21 + (j/5)*(1/21);
        waitbar(o)
    end
    Accuracy = [Accuracy, [i;mean(ac(1,:))]];
    
end
close(wb);
plot(Accuracy(1,:),Accuracy(2,:))
toc

tic
C = 2^-4;
linear_model = svmtrain(TrainLabel,TrainData,sprintf('-t 0 -c %d',C));
toc