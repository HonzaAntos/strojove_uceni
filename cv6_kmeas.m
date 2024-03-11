clc
clear

ID = 220962;

%% Data generator

tmp = sqrt(3)/2;
tmpp=1+tmp;
rng(ID);
%Normalni rozlozeni dat
% means - X1 - [1 2 1.5], X2 - [1 1 sqrt(3)/2]
% deviation - X1 - [1 1 2], X2 - [1 1 1]
data(1,:) = [normrnd(1,1,1,100) normrnd(2,1,1,100) normrnd(1.5,2,1,100)];
data(2,:) = [normrnd(1,1,1,100) normrnd(1,1,1,100) normrnd(tmpp,1,1,100)];
data(3,:) = [ones(1,100) ones(1,100)+1 ones(1,100)+2];


%data(1,:) = [normrnd(1,0.001,1,100) normrnd(2,0.001,1,100) normrnd(1.5,0.001,1,100)];
%data(2,:) = [normrnd(1,0.001,1,100) normrnd(1,0.001,1,100) normrnd(tmpp,0.001,1,100)];
%data(3,:) = [ones(1,100) ones(1,100)+1 ones(1,100)+2];

%Normalizace dat do rozsahu <0:1>
dataNorm(1,:) = (data(1,:)-min(data(1,:)))/(max(data(1,:))-min(data(1,:)));
dataNorm(2,:) = (data(2,:)-min(data(2,:)))/(max(data(2,:))-min(data(2,:)));
dataNorm(3,:) = data(3,:);

subplot(2,3,1)
scatter(data(1,:),data(2,:))
xlabel("X1")
ylabel("X2")
title("Neklasifikovana vstupni data")

subplot(2,3,2)
gscatter(dataNorm(1,:),dataNorm(2,:),dataNorm(3,:))
xlabel("X1")
ylabel("X2")
title("Skutecna vstupni data")

%% k-Means, K = 3
%nahodne vybrane stredy(centroid)
newCentroids = [dataNorm(1,1:3);dataNorm(2,1:3)];

cluster1 = [1;1];
cluster2 = [1;1];
cluster3 = [1;1];
deviation1 = [1;1];
deviation2 = [1;1];
deviation3 = [1;1];
observation = zeros(1,300);

%proces uceni
for cycles = 1:100
    %reset 
    cluster1 = [1;1];
    cluster2 = [1;1];
    cluster3 = [1;1];
    deviation1 = [1];
    deviation2 = [1];
    deviation3 = [1]; 
    
    %spocitani novych pozorovani
    for i = 1:300
        %which centroid is data closest to
        centroids = newCentroids;
        position = [dataNorm(1,i) dataNorm(2,i)];
        dst(1) = norm(position - [centroids(1,1) centroids(2,1)]);
        dst(2) = norm(position - [centroids(1,2) centroids(2,2)]);
        dst(3) = norm(position - [centroids(1,3) centroids(2,3)]);
        [minimun,pos] = min(dst);
        observation(i) = pos;

        %serazeni podle clustru
        if pos == 1
            cluster1(1,end+1) = dataNorm(1,i);
            cluster1(2,end) = dataNorm(2,i);
            deviation1(end+1) = dst(1);
        elseif pos == 2
            cluster2(1,end+1) = dataNorm(1,i);
            cluster2(2,end) = dataNorm(2,i);
            deviation2(end+1) = dst(2);
        elseif pos == 3
            cluster3(1,end+1) = dataNorm(1,i);
            cluster3(2,end) = dataNorm(2,i);
            deviation3(end+1) = dst(3);
        end
    end
    %get rid of first position in cluster - code purpose
    cluster1(:,1) = [];
    cluster2(:,1) = [];
    cluster3(:,1) = [];
    deviation1(:,1) = [];
    deviation2(:,1) = [];  
    deviation3(:,1) = [];

    %spocitani novych stredu
    newCentroids = [mean(cluster1(1,:)) mean(cluster2(1,:)) mean(cluster3(1,:));
                    mean(cluster1(2,:)) mean(cluster2(2,:)) mean(cluster3(2,:))];
    
    %vypocet chyby pro kazdy cyklus
    deviation = (sum(deviation1.^2)+sum(deviation2.^2)+sum(deviation3.^2))/300;
    deviation1sum=sum(deviation1.^2)/100;
    deviation2sum=sum(deviation2.^2)/100;
    deviation3sum=sum(deviation3.^2)/100;

    fprintf("Chybova funkce J v "+cycles+". iteraci je: "+ deviation+"\n")
         
    J1(cycles)=deviation1sum;
    J2(cycles)=deviation2sum;
    J3(cycles)=deviation3sum;

    %exit statement
    if centroids == newCentroids
        break
    end
end

subplot(2,3,3)
% figure(3)
gscatter(dataNorm(1,:),dataNorm(2,:),observation)
xlabel("X1")
ylabel("X2")
title("KLasifikovana prislusnost")

subplot(2,3,4:6)
plot(J1)
hold on
plot(J2)
hold on 
plot(J3)
grid on
title("Chybove funkce")
legend("J1","J2","J3")

