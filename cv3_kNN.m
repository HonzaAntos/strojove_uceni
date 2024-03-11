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
%dataNormalized = [data(1,:).*100;data(2,:).*100;data(3,:)];
dataNormalized = [x1norm.*100;x2norm.*100;data(3,:)];

%trida + = 0
%trida x = 1

subplot(1,3,1)
gscatter(dataNormalized(1,:),dataNormalized(2,:),data(3,:),'br','+x')
xlabel("X1")
ylabel("X2")
title("Vstupn� data")

%% 1NN

%inicializace 
map = zeros(100,100,3);

for x2 = 1:100
    for x1 = 1:100
        %maximalni vzdalenost leveh. doln.bodu k
        %prav.horni.bodu...nastaveni jako max moznou hodnotu
        nearest = sqrt(2)*100;
        actual = [x1 x2];
        %nejblizsi clasa
        for i = 1:100
            %prohledavani, ktery bod je nejblize
            memory = [dataNormalized(1,i) dataNormalized(2,i)];
            %vypocet vzdalenosti
            distance = norm(memory-actual);%euklidovska norma L2   
            
            %novy nearest
            if(distance < nearest)
                nearest = distance;
                nearestClass = dataNormalized(3,i);
            end
        end
        
        if(nearestClass == 0)
            map(x2,x1,:) = [0 1 0];%RGB
        elseif(nearestClass == 1)
            map(x2,x1,:) = [1 0 0];
        end
    end
end

subplot (1,3,2)
hold on
imagesc(map)
hold on
gscatter(dataNormalized(1,:),dataNormalized(2,:),data(3,:),'rb','+x')
xlim([0 100])
ylim([0 100])

xlabel("X1")
ylabel("X2")
title("1NN")

%% 3NN

%inicializace
map = zeros(100,100,3);

for x2 = 1:100
    for x1 = 1:100
        %max dist
        nearestDistance(1:3) = 100*sqrt(2);
        nearestClass(1:3) = 0;
        actual = [x1 x2];
        %nejblizsi classa
        for i = 1:100
            memory = [dataNormalized(1,i) dataNormalized(2,i)];
            distance = norm(actual - memory);
            
            if(distance < nearestDistance(1))
                nearestDistance(3) = nearestDistance(2);
                nearestClass(3) = nearestClass(2);
                
                nearestDistance(2) = nearestDistance(1);
                nearestClass(2) = nearestClass(1);
                
                nearestDistance(1) = distance;
                nearestClass(1) = dataNormalized(3,i);
            
            elseif(distance < nearestDistance(2))
                nearestDistance(3) = nearestDistance(2);
                nearestClass(3) = nearestClass(2);
                
                nearestDistance(2) = distance;
                nearestClass(2) = dataNormalized(3,i);

            elseif(distance < nearestDistance(3))
                nearestDistance(3) = distance;
                nearestClass(3) = dataNormalized(3,i);
            end                
        end
        
        if(mean(nearestClass) < 0.5)
            map(x2,x1,:) = [0 1 0];
        elseif(mean(nearestClass) >= 0.5)
            map(x2,x1,:) = [0.8 0 0];
        end
    end
end

subplot (1,3,3)
imagesc(gca,map,[0 255])
set(gca,'YDir','normal');
axis([0 100 0 100]);
hold on
gscatter(dataNormalized(1,:),dataNormalized(2,:),data(3,:),'rb','+x')
xlim([0 100])
ylim([0 100])

xlabel("X1")
ylabel("X2")
title("3NN")
