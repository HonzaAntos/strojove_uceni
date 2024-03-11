% Nastavení parametrů genetického algoritmu
PopulationSize = 100; % Velikost populace
MaxGenerations = 10; % Maximální počet generací
CrossoverFraction = 1; % Podíl rodičů, kteří se účastní křížení
MutationRate = 0; % Poměr genů v populaci, které jsou mutovány
SelectionFcn = @selectionroulette; % Funkce pro výběr rodičů
CrossoverFcn = @crossovertwopoint; % Funkce pro křížení
MutationFcn = @mutationuniform; % Funkce pro mutaci

% Vstupní data
Data = [1 2 3; 4 5 6; 7 8 9];
Labels = {'Class 1', 'Class 2', 'Class 3'};

% Vytvoření funkce fitness
FitnessFcn = @(x) treeclassifierfitness(x, Data, Labels);

% Vytvoření počáteční populace
Population = cell(PopulationSize, 1);
for i = 1:PopulationSize
    Population{i} = treeclassifiercreator();
end

% Spuštění genetického algoritmu
[BestIndividual, BestFitness] = ga(FitnessFcn, numel(Data), [], [], [], [], ...
    [], [], [], [], Population, SelectionFcn, CrossoverFcn, CrossoverFraction, ...
    MutationFcn, MutationRate, MaxGenerations);

% Vytvoření rozhodovacího stromu z nejlepšího jedince
Tree = treeclassifierdecoder(BestIndividual);

% Testování stromu na nových datech
NewData = [2 3 4; 5 6 7; 8 9 10];
Predictions = predict(Tree, NewData);
disp(Predictions);