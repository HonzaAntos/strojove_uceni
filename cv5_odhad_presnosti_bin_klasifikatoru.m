clc
close all
clear

%seminko
rng(220962);
data = [0.6.*rand(1,50) 0.6.*rand(1,50)+0.4;rand(1,100);zeros(1,50) ones(1,50)];
x11=data(1,:);
x1min=min(x11)
x1max=max(x11)

x22=data(2,:);
x2min=min(x22)
x2max=max(x22)

x1norm=zeros(1);
x2norm=zeros(1);

for i =1:100
    x1norm(i)=(x11(i)-x1min)/(x1max-x1min);
    x2norm(i)=(x22(i)-x2min)/(x2max-x2min);
end

%rast 100x100
dataNormalized = [x1norm.*100;x2norm.*100;data(3,:)];

%trida + = 0
%trida x = 1

subplot(1,3,1)
gscatter(dataNormalized(1,:),dataNormalized(2,:),data(3,:),'br','+x')
xlabel("X1")
ylabel("X2")
title("Vstupní data")
% 3NN
tic
%inicializace
map3 = zeros(100,100,3);
maphelper3 = zeros(100,100,1);
TP3=0;
FP3=0;
TN3=0;
FN3=0;
x33=dataNormalized(3,:);
for x23 = 1:100
    for x13 = 1:100
        %max dist
        nearestDistance3(1:3) = 100*sqrt(2);
        nearestClass3(1:3) = 0;
        actual3 = [x13 x23];
        %nejblizsi classa
        for i3 = 1:100
            memory3 = [dataNormalized(1,i3) dataNormalized(2,i3)];
            distance3 = norm(actual3 - memory3);
            
            if(distance3 < nearestDistance3(1))
                nearestDistance3(3) = nearestDistance3(2);
                nearestClass3(3) = nearestClass3(2);
                
                nearestDistance3(2) = nearestDistance3(1);
                nearestClass3(2) = nearestClass3(1);
                
                nearestDistance3(1) = distance3;
                nearestClass3(1) = dataNormalized(3,i3);
            
            elseif(distance3 < nearestDistance3(2))
                nearestDistance3(3) = nearestDistance3(2);
                nearestClass3(3) = nearestClass3(2);
                
                nearestDistance3(2) = distance3;
                nearestClass3(2) = dataNormalized(3,i3);

            elseif(distance3 < nearestDistance3(3))
                nearestDistance3(3) = distance3;
                nearestClass3(3) = dataNormalized(3,i3);
            end   
        end
        
        if(mean(nearestClass3) < 0.5)
            map3(x23,x13,:) = [0 1 0];
            maphelper3(x23,x13,:) = 0;

        elseif(mean(nearestClass3) >= 0.5)
            map3(x23,x13,:) = [0.8 0 0];
            maphelper3(x23,x13,:) = 1;
        end 
    end
end

for k3 =1:100
    ground_truth3=dataNormalized(:,k3);
    truth_x13=round(ground_truth3(1));
    truth_x23=round(ground_truth3(2));
    if truth_x23==0
       truth_x23=1;
    end
    if truth_x13==0
       truth_x13=1;
    end
    z3=ground_truth3(3);
    compare_map3=maphelper3(truth_x23,truth_x13);
        if(z3==true && compare_map3== 1)
            TP3=TP3+1;
        elseif(z3==false && compare_map3 == 1)
            FP3=FP3+1;
        elseif(z3==true && compare_map3 == 0)
            FN3=FN3+1;
        elseif(z3==false && compare_map3 == 0)
            TN3=TN3+1;
        end
     train3(k3)=compare_map3;   
end
resubErr=(FP3+FN3)/length(dataNormalized(1,:));
elapsed_time_resub=toc;
T3=(TP3+TN3);%skutecne pozitivni
F3=(FP3+FN3);%skutecne negativni
acc3=T3/(T3+F3);%celkova sporavnost
err3=F3/(T3+F3);%chyba
precision3=TP3/(FN3+TN3);%presnost
TPR3=TP3/(TP3+FN3);
FPR3=(FP3/(FP3+TN3));
subplot(2,3,2)
cm3=confusionchart(x33,train3);
cm3.Title = 'Confusion Matrix for 3NN';
subplot (2,3,3)
imagesc(gca,map3,[0 255])
set(gca,'YDir','normal');
axis([0 100 0 100]);
hold on
gscatter(dataNormalized(1,:),dataNormalized(2,:),data(3,:),'rb','+x')
xlim([0 100])
ylim([0 100])

xlabel("X1")
ylabel("X2")
title("3NN")

%% CROSS VALIDATION K=10

tic 
map_cv = zeros(100,100,3);
maphelper_cv = zeros(100,100,1);
% Get the size of the first dimension (number of rows)
num_rows = size(dataNormalized, 1);

%num of fold in varib
K=5;
% Calculate the number of columns in each partition
num_cols = size(dataNormalized, 2) / K;

% Reshape the data array into ten partitions
partitions = reshape(dataNormalized, num_rows, num_cols, K);

% Load your data partitions, assuming it is stored in a 3x10x10 matrix called "partitions"
num_folds = size(partitions, 3); % number of folds

% Pre-allocate variables to store the accuracy or error rate for each fold
accuracy = zeros(num_folds, 1);
error_rate = zeros(num_folds, 1);
var=(length(partitions)*(K-1));

% Loop over the folds
for i = 1:num_folds
    % Select the i-th partition as the test set
    test_data = partitions(:, :, i);
    % Concatenate the remaining 9 partitions to form the training set
    train_data = partitions(:, :, [1:i-1 i+1:end]);
    train_data = reshape(train_data, 3,var);
    
    for x23 = 1:100
        for x13 = 1:100
            %max dist
            nearestDistance3(1:3) = 100*sqrt(2);
            nearestClass3(1:3) = 0;
            actual3 = [x13 x23];
            %nejblizsi classa
            for i3 = 1:var
                memory3 = [train_data(1,i3) train_data(2,i3)];
                distance3 = norm(actual3 - memory3);
                
                if(distance3 < nearestDistance3(1))
                    nearestDistance3(3) = nearestDistance3(2);
                    nearestClass3(3) = nearestClass3(2);
                    
                    nearestDistance3(2) = nearestDistance3(1);
                    nearestClass3(2) = nearestClass3(1);
                    
                    nearestDistance3(1) = distance3;
                    nearestClass3(1) = train_data(3,i3);
                
                elseif(distance3 < nearestDistance3(2))
                    nearestDistance3(3) = nearestDistance3(2);
                    nearestClass3(3) = nearestClass3(2);
                    
                    nearestDistance3(2) = distance3;
                    nearestClass3(2) = train_data(3,i3);
    
                elseif(distance3 < nearestDistance3(3))
                    nearestDistance3(3) = distance3;
                    nearestClass3(3) = train_data(3,i3);
                end   
            end
            
            if(mean(nearestClass3) < 0.5)
                map_cv(x23,x13,:) = [0 1 0];
                maphelper_cv(x23,x13,:) = 0;
    
            elseif(mean(nearestClass3) >= 0.5)
                map_cv(x23,x13,:) = [0.8 0 0];
                maphelper_cv(x23,x13,:) = 1;
            end 
        end
    end
    
    for k3 =1:length(test_data)
        ground_truth3=test_data(:,k3);
        truth_x13=round(ground_truth3(1));
        truth_x23=round(ground_truth3(2));
        if truth_x23==0
           truth_x23=1;
        end
        if truth_x13==0
           truth_x13=1;
        end
        z3=ground_truth3(3);
        compare_map3=maphelper_cv(truth_x23,truth_x13);
            if(z3==true && compare_map3== 1)
                TP3=TP3+1;
            elseif(z3==false && compare_map3 == 1)
                FP3=FP3+1;
            elseif(z3==true && compare_map3 == 0)
                FN3=FN3+1;
            elseif(z3==false && compare_map3 == 0)
                TN3=TN3+1;
            end
         train33(k3)=compare_map3;   
    end
    figure(1+i)
    subplot(1,4,3)
    imagesc(gca,map_cv,[0 255])
    set(gca,'YDir','normal');
    axis([0 100 0 100]);
    hold on
    gscatter(test_data(1,:),test_data(2,:),test_data(3,:),'br','+x')
    xlim([0 100])
    ylim([0 100])
    subplot(1,4,1)
    gscatter(test_data(1,:),test_data(2,:),test_data(3,:),'br','+x')
    xlim([0 100])
    ylim([0 100])
    xlabel("X1")
    ylabel("X2")
    title("Test data")
    subplot(1,4,2)
    gscatter(train_data(1,:),train_data(2,:),train_data(3,:),'br','+x')
    xlim([0 100])
    ylim([0 100])
    xlabel("X1")
    ylabel("X2")
    title("Train Data")
    % Calculate the classification accuracy or error rate for the current fold
    accuracy(i) = mean(train33 == test_data(3, :));
    error_rate(i) = 1 - accuracy(i);
    subplot(1,4,4)
    cm=confusionchart(train33,test_data(3,:));
    cm.Title = 'Confusion Matrix for 3NN ' ;
end

% Compute the average classification accuracy or error rate across all 10 folds
avg_accuracy = mean(accuracy);
avg_error_rate = mean(error_rate);

fprintf('Average accuracy: %.2f%%\n', avg_accuracy * 100);
fprintf('Average cross validation error: %.2f%%\n', avg_error_rate * 100);
fprintf('Error train: %.2f%%\n', resubErr * 100);
elapsed_time_cv=toc;
fprintf('Elapsed time for Cross Validation = %f seconds\n', elapsed_time_cv);
fprintf('Elapsed time for Resubstitution error = %f seconds\n', elapsed_time_resub);
figure(1)
subplot(2,3,5)
gscatter(test_data(1,:),test_data(2,:),test_data(3,:),'br','+x')
xlabel("X1")
ylabel("X2")
title("Vstupní data")









