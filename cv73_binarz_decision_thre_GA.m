clc
clear

% Input attributes
x1 = [0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1];
x2 = [0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1];
x3 = [0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1];
x4 = [0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1];
% Output
y = [0,1,0,1,1,1,1,1,0,0,1,0,0,0,1,0];

% Set up genetic algorithm parameters
dept_tree = 3;
pop_size = 100;
num_generations = 10;

% Set up initial population
pop = randi([0 1], pop_size, 2^dept_tree-1);

% Main genetic algorithm loop
for gen = 1:num_generations
    % Evaluate fitness of each individual
    fitness = zeros(pop_size, 1);
    %for i = 1:pop_size
        % Decode binary decision tree and evaluate missclassification ratio
     %   tree = bin2tree(pop(i,:), dept_tree);
    %    y_pred = evaluate_tree(tree, x1, x2, x3, x4);
   %     fitness(i) = sum(y_pred ~= y) / length(y);
  %  end
    
    % Select parents for crossover (just choose randomly)
    parents = pop(randi(pop_size, 1, pop_size/2), :);
    
    % Perform crossover
    children = zeros(size(parents));
    for i = 1:2:pop_size-1
        parent1 = parents(i,:);
        parent2 = parents(i+1,:);
        crossover_pt = randi(length(parent1));
        child1 = [parent1(1:crossover_pt), parent2(crossover_pt+1:end)];
        child2 = [parent2(1:crossover_pt), parent1(crossover_pt+1:end)];
        children(i,:) = child1;
        children(i+1,:) = child2;
    end
    
    % Replace old population with new generation
    pop = children;
    
    % Print best fitness in generation
    fprintf('Generation %d')
end