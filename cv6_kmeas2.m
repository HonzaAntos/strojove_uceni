clc
clear

ID = 220962;

%% Data generator

tmp = sqrt(3)/2;
rng(ID);
%Normalni rozlozeni dat

data(1,:) = [normrnd(1,1,1,100) normrnd(2,1,1,100) normrnd(1.5,2,1,100)];
data(2,:) = [normrnd(1,1,1,100) normrnd(1,1,1,100) normrnd(tmp,1,1,100)];
data(3,:) = [ones(1,100) ones(1,100)+1 ones(1,100)+2];

%Normalizace dat do rozsahu <0:1>
dataNorm(1,:) = (data(1,:)-min(data(1,:)))/(max(data(1,:))-min(data(1,:)));
dataNorm(2,:) = (data(2,:)-min(data(2,:)))/(max(data(2,:))-min(data(2,:)));
dataNorm(3,:) = data(3,:);

subplot(1,3,1)
scatter(data(1,:),data(2,:))
xlabel("X1")
ylabel("X2")
title("Vstupni dataset")

subplot(1,3,2)
gscatter(dataNorm(1,:),dataNorm(2,:),dataNorm(3,:))
xlabel("X1")
ylabel("X2")
title("True membership")

%% k-Means, K = 3
%nahodne vzbranz stred(centroid)
newCentroids = [dataNorm(1,1:3);dataNorm(2,1:3)];

%temp variables - code purpose
cluster1 = [1;1];
cluster2 = [1;1];
cluster3 = [1;1];
observation = zeros(1,300);

%uceni
for cycles = 1:100
    %reset clusters
    cluster1 = [1;1];
    cluster2 = [1;1];
    cluster3 = [1;1];
    %calculate new observations
    for i = 1:300
        %which centroid is data closest to
        centroids = newCentroids;
        position = [dataNorm(1,i) dataNorm(2,i)];
        dst(1) = norm(position - [centroids(1,1) centroids(2,1)]);
        dst(2) = norm(position - [centroids(1,2) centroids(2,2)]);
        dst(3) = norm(position - [centroids(1,3) centroids(2,3)]);
        [minimun,I] = min(dst);
        observation(i) = I;

        %sort by cluster
        if I == 1
            cluster1(1,end+1) = dataNorm(1,i);
            cluster1(2,end) = dataNorm(2,i);
        elseif I == 2
            cluster2(1,end+1) = dataNorm(1,i);
            cluster2(2,end) = dataNorm(2,i);
        elseif I == 3
            cluster3(1,end+1) = dataNorm(1,i);
            cluster3(2,end) = dataNorm(2,i);
        end
    end
    %get rid of first position in cluster - code purpose
    cluster1(:,1) = [];
    cluster2(:,1) = [];
    cluster3(:,1) = [];
    %calculate new centroids
    newCentroids = [mean(cluster1(1,:)) mean(cluster2(1,:)) mean(cluster3(1,:));
                    mean(cluster1(2,:)) mean(cluster2(2,:)) mean(cluster3(2,:))];
    %exit statement
    if centroids == newCentroids
        break
    end
end

subplot(1,3,3)
% figure(3)
gscatter(dataNorm(1,:),dataNorm(2,:),observation)
xlabel("X1")
ylabel("X2")
title("Classified in: "+cycles+" cycles")

