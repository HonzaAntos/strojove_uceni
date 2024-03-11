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

for i3 =1:100
    x1norm(i3)=(x11(i3)-x1min)/(x1max-x1min);
    x2norm(i3)=(x22(i3)-x2min)/(x2max-x2min);
end

%rast 100x100
%dataNormalized = [data(1,:).*100;data(2,:).*100;data(3,:)];
dataNormalized = [x1norm.*100;x2norm.*100;data(3,:)];

%trida + = 0
%trida x = 1

subplot(2,3,1)
gscatter(dataNormalized(1,:),dataNormalized(2,:),data(3,:),'br','+x')
xlabel("X1")
ylabel("X2")
title("Vstupní data")
subplot(2,3,4)
gscatter(dataNormalized(1,:),dataNormalized(2,:),data(3,:),'br','+x')
xlabel("X1")
ylabel("X2")
title("Vstupní data")

% 3NN

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
% 5 knn

%inicializace
map = zeros(100,100,3);
maphelper = zeros(100,100,1);
TP=0;
FP=0;
TN=0;
FN=0;
x3=dataNormalized(3,:);
for x2 = 1:100
    for x1 = 1:100
        %max dist
        nearestDistance(1:5) = 100*sqrt(2);
        nearestClass(1:5) = 0;
        actual = [x1 x2];
        %nejblizsi classa
        for i = 1:100
            memory = [dataNormalized(1,i) dataNormalized(2,i)];
            distance = norm(actual - memory);
            
            if(distance < nearestDistance(1))
                nearestDistance(5) = nearestDistance(4);
                nearestClass(5) = nearestClass(4);

                nearestDistance(4) = nearestDistance(3);
                nearestClass(4) = nearestClass(3);

                nearestDistance(3) = nearestDistance(2);
                nearestClass(3) = nearestClass(2);
                
                nearestDistance(2) = nearestDistance(1);
                nearestClass(2) = nearestClass(1);
                
                nearestDistance(1) = distance;
                nearestClass(1) = dataNormalized(3,i);
            
            elseif(distance < nearestDistance(2))
                nearestDistance(5) = nearestDistance(4);
                nearestClass(5) = nearestClass(4);

                nearestDistance(4) = nearestDistance(3);
                nearestClass(4) = nearestClass(3);

                nearestDistance(3) = nearestDistance(2);
                nearestClass(3) = nearestClass(2);
                
                nearestDistance(2) = distance;
                nearestClass(2) = dataNormalized(3,i);

            elseif(distance < nearestDistance(3))
                nearestDistance(5) = nearestDistance(4);
                nearestClass(5) = nearestClass(4);

                nearestDistance(4) = nearestDistance(3);
                nearestClass(4) = nearestClass(3);

                nearestDistance(3) = distance;
                nearestClass(3) = dataNormalized(3,i);

           elseif(distance < nearestDistance(4))
                nearestDistance(5) = nearestDistance(4);
                nearestClass(5) = nearestClass(4);

                nearestDistance(4) = nearestDistance(3);
                nearestClass(4) = dataNormalized(3,i);
            elseif(distance < nearestDistance(5))
                nearestDistance(5) = nearestDistance(4);
                nearestClass(5) =  dataNormalized(3,i);
            end 
        end
        
        if(mean(nearestClass) < 0.5)
            map(x2,x1,:) = [0 1 0];
            maphelper(x2,x1,:) = 0;

        elseif(mean(nearestClass) >= 0.5)
            map(x2,x1,:) = [0.8 0 0];
            maphelper(x2,x1,:) = 1;
        end 
    end
end

for k =1:100
    ground_truth=dataNormalized(:,k);
    truth_x1=round(ground_truth(1));
    truth_x2=round(ground_truth(2));
    if truth_x2==0
       truth_x2=1;
    end
    if truth_x1==0
       truth_x1=1;
    end
    z=ground_truth(3);
    compare_map=maphelper(truth_x2,truth_x1);
        if(z==1 && compare_map== 1)
            TP=TP+1;
        elseif(z==0 && compare_map == 1)
            FP=FP+1;
        elseif(z==1 && compare_map == 0)
            FN=FN+1;
        elseif(z==0 && compare_map == 0)
            TN=TN+1;
        end
     train(k)=compare_map;   
end
T=(TP+TN);%skutecne pozitivni
F=(FP+FN);%skutecne negativni
acc=T/(T+F);%celkova sporavnost
err=F/(T+F);%chyba
precision=TP/(FN+TN);%presnost
TPR=TP/(TP+FN);
FPR=(FP/(FP+TN));
subplot(2,3,5)
cm=confusionchart(x3,train);
cm.Title = 'Confusion Matrix for 5NN';
subplot (2,3,6)
imagesc(gca,map,[0 255])
set(gca,'YDir','normal');
axis([0 100 0 100]);
hold on
gscatter(dataNormalized(1,:),dataNormalized(2,:),data(3,:),'rb','+x')
xlim([0 100])
ylim([0 100])

xlabel("X1")
ylabel("X2")
title("5NN")

figure(2)
hold on
plot(FPR3,TPR3,'r*')
hold on
plot(FPR,TPR,'b*')
hold on
plot(0,1,'g*')
hold on
plot([0,1],[0,1], '- yellow')
hold on
area([0,1],[0,1])
grid on
xlim([0 1])
ylim([0 1])
xlabel("FPR")
ylabel("TPR")
legend('3NN','5NN','1NN','nahodily jev', 'spatne klasifikovany')
title("ROC")