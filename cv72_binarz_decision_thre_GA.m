clc
clear 

% Define the problem parameters
n_vars = 4; % Number of variables in the decision tree
n_pop = 100; % Size of the population
n_gen = 10; % Number of generations
X = [0 0; 0 1; 1 0; 1 1]; % Input data
y = [0 1 1 0]'; % Output data

% Initialize the population
pop = rand(n_pop, n_vars) > 0.5; % Binary decision trees
fitness = zeros(n_pop, 1); % Fitness values

% Evaluate the initial population
for i = 1:n_pop
    fitness(i) = evaluate_tree(pop(i,:), X, y);
end

% Main loop
for gen = 1:n_gen
    % Select parents using tournament selection
    parents = zeros(n_pop, n_vars);
    for i = 1:n_pop
        idx = randperm(n_pop, 2);
        if fitness(idx(1)) > fitness(idx(2))
            parents(i,:) = pop(idx(1),:);
        else
            parents(i,:) = pop(idx(2),:);
        end
    end
    
    % Apply crossover and mutation operators
    offspring = zeros(n_pop, n_vars);
    for i = 1:2:n_pop
        % Crossover
        if rand < 0.8
            crossover_point = randi(n_vars-1);
            offspring(i,:) = [parents(i,1:crossover_point) parents(i+1,crossover_point+1:end)];
            offspring(i+1,:) = [parents(i+1,1:crossover_point) parents(i,crossover_point+1:end)];
        else
            offspring(i,:) = parents(i,:);
            offspring(i+1,:) = parents(i+1,:);
        end
        
        % Mutation
        for j = 1:n_vars
            if rand < 0.1
                offspring(i,j) = ~offspring(i,j);
            end
            if rand < 0.1
                offspring(i+1,j) = ~offspring(i+1,j);
            end
        end
    end
    
    % Evaluate the offspring
    offspring_fitness = zeros(n_pop, 1);
    for i = 1:n_pop
        offspring_fitness(i) = evaluate_tree(offspring(i,:), X, y);
    end
    
    % Replace the population with the offspring
    pop = offspring;
    fitness = offspring_fitness;
    
    % Print the best fitness in the current generation
    fprintf('Generation %d: Best fitness = %f\n', gen, max(fitness));
end

% Find the best individual in the final population
[~, idx] = max(fitness);
best_individual = pop(idx,:);
best_fitness = fitness(idx);

% Evaluate the best individual on the input data
output = evaluate_tree(best_individual, X, y);
fprintf('Best individual: %s\n', mat2str(best_individual));
fprintf('Best fitness: %f\n', best_fitness);
fprintf('Output: %s\n', mat2str(output));

function fitness = evaluate_tree(individual, X, y)
% Evaluate a binary decision tree on the input data
n_samples = size(X, 1);
n_correct = 0;
for i = 1:n_samples
    if evaluate_node(individual, 1, X(i,:)) == y(i)
         n_correct = n_correct + 1;
    end
end
fitness = n_correct / n_samples;
end

function output = evaluate_node(individual, node_idx, x)
    % Evaluate a node in the binary decision tree
    if node_idx <= 3 % Internal node
    feature_idx = 2 * node_idx - 1;
        if x(feature_idx) == 0
        child_idx = node_idx * 2;
        else
        child_idx = node_idx * 2 - 1;
        end
    output = evaluate_node(individual, child_idx, x);
    else % Leaf node
    output = individual(node_idx-3);
    end
end