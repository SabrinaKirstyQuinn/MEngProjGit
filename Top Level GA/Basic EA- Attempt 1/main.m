


%% DEFINE CONSTANTS
POPULATION_SIZE = 10; % Size of the initial population consisting of chromosomes
CHROMOSOME_SIZE = 3;  % Size of the bit strings used for the chromosomes
TARGET_FITNESS = 0;   % Smaller the fitness value the better
NUMBER_OF_PARENTS = 8;% Number of parents used to generate offspring (For now..
% this is best as an even number due to how i have written the crossover)  

%% CREATE TARGET SOLUTION 
solutionAim = ones(CHROMOSOME_SIZE,1)

%% QUICK CONFIG CHECKS
if POPULATION_SIZE<NUMBER_OF_PARENTS
    error('to many parents compared to population size')    
end

%% GENERATE RANDOM POPULATION

%Initialise population with all zeros just for debugging clarity for now 
population = zeros(CHROMOSOME_SIZE,POPULATION_SIZE);

for n = 1:15
    
    % Create random bit string
    population(:,n) = round(rand(CHROMOSOME_SIZE,1));
    
end    

% print population for debuggin purposes
population

%% LOOP THROUGH GENERATIONS 

%Initalise fitness value to value to the lowest fitness value that can occur
bestFitness = CHROMOSOME_SIZE;
%Initialise selected array to zero for clarity
selected = zeros(1,NUMBER_OF_PARENTS)
%Initialise number of generations
generation = 0;

%Run through generations until target solution is find or a certain number
%of generations have been executed
while (bestFitness ~= TARGET_FITNESS)&&(generation < 10)

    %Find fitness of the population 
    populationFitness = fitnessFunction(population, solutionAim, CHROMOSOME_SIZE, POPULATION_SIZE);
    
    for n = 1:NUMBER_OF_PARENTS
        
        % Desifer the fittest value
        bestFitness = min(populationFitness)
        
        selected(n) = selection(populationFitness,bestFitness);
        populationFitness(selected(n))= CHROMOSOME_SIZE+1
    
    end
    
    
    curentPopulation = crossover(selected,population,CHROMOSOME_SIZE,NUMBER_OF_PARENTS);
    population = curentPopulation
    

    generation = generation +1 ;
    sprintf('Generation: %d', generation)

end
 

