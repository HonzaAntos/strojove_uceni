clc
clear

ID = 220962;
% Vstupní data
% Binary decision tree with genetic algorithm
rng(ID)
% Input attributes
x1 = [0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1];
x2 = [0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1];
x3 = [0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1];
x4 = [0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1];
% Output
y = [0,1,0,1,1,1,1,1,0,0,1,0,0,0,1,0];

x1t=x1.';
x2t=x2.';
x3t=x3.';
x4t=x4.';
yt=y.';

table = [x1t, x2t, x3t, x4t, yt];
% Define the maximum depth of the decision tree
max_depth = 2;

% Define the population size
population_size = 100;

% Define the number of generations
num_generations = 10;

% Define the crossover probability
crossover_prob = 1;

% Define the mutation probability
mutation_prob = 0;

% Create the initial population
for o=1:population_size
    % Generate a 4x1 array with randomly assigned 0s and 1s
    population(:,o) = randi([0, 1], 7, 1);
end

new_gen_data=randi([1,4],7,100);
test=new_gen_data;

% Run the genetic algorithm
for i = 1:num_generations

    index=randi([1,6],1);
    indexes(i)=index;

    for j=1:2:population_size-1
        parent1=new_gen_data(:,j);
        parent2=new_gen_data(:,j+1);
        %simple crossover metoda krizeni        
        %crop data from parents on index
        crop_parent11=parent1(1:index);
        crop_parent12=parent1(index+1:end);
        crop_parent21=parent2(1:index);
        crop_parent22=parent2(index+1:end);
        child1=cat(1,crop_parent11, crop_parent22);
        child2=cat(1,crop_parent12, crop_parent21);
        %store in children in array
        new_gen= [child1 child2];
        %add children to future parents
        new_gen_data(:,j:j+1)=new_gen;
    end
    all_data(:,:,i)=new_gen_data;
end

%classification 
%porovnavani hodnot z jedince se zadanou pravdivostni tabulkou ...pokud se
%to neshoduje incrementujeme missclass. po skonceni jedince se spocita
%missclass jedinec(n)=> avg_miss_class_per_generation ...spociame primernou
%chzbu na generaci a ulozime si ji do pole pro vzkresleni pres scatter
for m=1:num_generations
    for n=1:population_size
        jedinec=all_data(:,n,m);
        missclass=0;
        for k=1:16
            if table(k,jedinec(1))==1%uzel 1
                if table(k,jedinec(2))==1%uzel 2
                    if table(k,jedinec(4))~=table(k,5)%uzel 4
                        missclass=missclass+1;
                    end
                end
                if table(k,jedinec(2))==0% uzel 2
                    if table(k,jedinec(5))~=table(k,5) %uzel 5
                        missclass=missclass+1;
                    end
                end
            end
            if table(k,jedinec(1))==0%uzel 1
                if table(k,jedinec(3))==1%uzel 3
                    if table(k,jedinec(6))~=table(k,5)%uzel 6
                        missclass=missclass+1;
                    end
                end
                if table(k,jedinec(3))==0% uzel3
                    if table(k,jedinec(7))~=table(k,5) %uzel 7
                        missclass=missclass+1;        
                    end
                end
            end
        end
        missclassjedinec(n)=(missclass/16)*100;
    end
    for inc=1:100
        sum_of_one_generation=sum(missclassjedinec(inc));
    end
    min_miss_clas_per_gen(m)=min(missclassjedinec);
    max_miss_clas_per_gen(m)=max(missclassjedinec);
    avg_miss_class_per_gen(m)=(sum_of_one_generation);
end

figure(1)
scatter(1:num_generations,avg_miss_class_per_gen)
hold on
scatter(1:num_generations,min_miss_clas_per_gen)
hold on
scatter(1:num_generations,max_miss_clas_per_gen)
ylim([0 100])
xlabel("Generation")
ylabel("MissClassRatio [%]")
title("MissClassificationRatio thru 10 generation")
legend("Avg","Min","Max")
