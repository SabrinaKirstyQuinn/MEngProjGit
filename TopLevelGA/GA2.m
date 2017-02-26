function [] = GA2(popSize, generations, chromsomeSize, numParents, numMutations)
%% CHECK INPUTS AGAINST CONSTRAINTS MADE
if popSize < numParents
    error('to many parents compared to population size')  
end
if numMutations > chromsomeSize
    error('number of mutations in chromosome is to big compared to the chromosomeSize') 
end

%% CREATE TARGET SOLUTION = (Bit string full of ones)
solutionTarget = ones(chromsomeSize,1)

%% GENERATE RANDOM POPULATION
 
%Initialise population with all zeros just for debugging clarity for now 
population = zeros(chromsomeSize +1,popSize);
 
for n = 1:popSize
     
    % Create random bit string
    population(:,n) = round(rand(chromsomeSize+1,1));
     
end    
 
% print population for debuggin purposes
population

%% LOOP THROUGH GENERATIONS 

currentGeneration = 1;
TARGET_FITNESS = 0;
bestFitness = 12;
fittnessPoint = 0;

%Run through generations until target solution is found or a certain number
%of generations have been executed
while (bestFitness ~= TARGET_FITNESS)&&(currentGeneration <= generations)
totalFitness=0;
largestFitness =0

sprintf('Generation: %d', currentGeneration)

% Calculating fitness
    %Stepping through each chrosome in the poulation
    for n = 1:popSize
        fitnessSum = 0;
        allelePop = 0;
        alleleTarget = 0;
        %Stepping through each allele
        for a = 1:chromsomeSize
            allelePop = population(a,n);
            alleleTarget = solutionTarget(a,1);
            %Comparing to target solution 
            switch allelePop
                case alleleTarget
                    fittnessPoint = 1; 
                case ~alleleTarget
                    fittnessPoint = 0;
            end
            %Creating fitness value for that chromsome and adding offset to
            %avoid a zero fitness value, to ensure all chromosomes are
            %given a probability in the roulette wheel
            fitnessSum = fitnessSum + fittnessPoint;

        end
        
        %Offset needed for roulette wheel 
        fitnessSum = fitnessSum + 1
        
        %Fittest individual
        if (n) ~= (1)
            prevIndividual = n - 1
            accessfitnessValues = chromsomeSize+1;
            PrevFittness = population(accessfitnessValues,prevIndividual)
            if (fitnessSum) >= (PrevFittness)
                largestFitness= fitnessSum
            end
        end   
        totalFitness = totalFitness + fitnessSum
        
        %Saving fitness value 
        population(chromsomeSize+1,n) = fitnessSum
          
    end
     averageFitness(currentGeneration) = totalFitness/popSize 
     largestFitnessGenerational(currentGeneration) = largestFitness 
     

    
% Selection - Creating Roulette Wheel
    %Offset of 0.1 given to make it easier to define random number range
    prevNumRange =0.1;
    numberRange =0;
    for n = 1:popSize        
        selectProbability = 0;
        %Calculating individuals probabilities of selection 
        selectProbability = population((chromsomeSize+1),n)/(totalFitness);
        %these popbabilities will always sum to a range of 0-1. 
        numberRange = prevNumRange + selectProbability;
        population((chromsomeSize+1),n) = numberRange; 
        prevNumRange = numberRange;
    end 
   
% Selecting parents using roulette wheel
    currentIndividualRange =0;
    parentsSelectedIndexNumbers = zeros(numParents,1);
    for n = 1:numParents
        %remember offset so range is 0.1 to 1.1
        randomNumber = 0.1 + rand*(1.1-0.1);
        individual = 1;
        while (individual <= popSize)
            currentIndividualRange = population((chromsomeSize+1),individual);
            if (currentIndividualRange) > (randomNumber);
                newParent = individual - 1 ;
                if ~(ismember(parentsSelectedIndexNumbers, newParent))
                    parentsSelectedIndexNumbers(n,1) = newParent;
                    %Get the selected parents genes and put them in array
                    selectedGenes(1:chromsomeSize,n) = population(1:chromsomeSize,parentsSelectedIndexNumbers(n,1));
                    individual = popSize + 1;
                end
            end
            individual = individual + 1;
             
        end 
    end
    
% Crossover  
    crossoverNum = popSize/numParents;
    remainder = mod(popSize,numParents);
    intermediatePositionEnd = 0;
    intermediatePositionStart = 1;
    offspringSize = 0; 
    
    for c = 1:crossoverNum
        %Create random locus within range
        randLocusPoint = round(rand*(chromsomeSize-2)) +1;
        %For however many number of parents we are using, cycle through
        for n = 1:numParents 
            %ensure all genes used correctly
            if n == numParents
                mate = 1;
            else
                mate = n +1;
            end
            offspring(1:randLocusPoint,n) = selectedGenes(1:randLocusPoint,n);
            offspring(randLocusPoint+1:chromsomeSize,n) = selectedGenes(randLocusPoint+1:chromsomeSize,mate);
            offspringSize = offspringSize +1;
        end      
        %Storing offspring in intermediate population       
        intermediatePositionEnd = intermediatePositionEnd + numParents;
        intermediatePop(:, intermediatePositionStart:intermediatePositionEnd) = offspring(:,1:numParents);
        intermediatePositionStart = intermediatePositionStart + numParents;
    end
     

% Mutation 
    for p = 1:offspringSize
        for n = 1:numMutations
            bitFlip = round(rand*(chromsomeSize-1)) +1;
            alleleToFlip = intermediatePop(bitFlip,p);
            alleleFlipped = ~alleleToFlip;
            intermediatePop(bitFlip,p) = alleleFlipped;
        end       
    end 
%     
    %check
%     population    
%     totalFitness
%     parentsSelectedIndexNumbers
%     randLocusPoint
%     selectedGenes
%     offspring

   population = intermediatePop
   %Generation count
   currentGeneration = currentGeneration +1 ;

end

figure
p1 = plot(1:generations,averageFitness(1:generations), '-o');

titleString = sprintf('GA2: EA Generations Vs Average Fitness of Population, (Population size = %d, Generations = %d, Chromosome size = %d, No. of parents = %d, No. of mutations = %d)' ,popSize, generations, chromsomeSize, numParents, numMutations');
title(titleString);
hold on ;
ylabel('Average Fitness of Population');
xlabel('EA Generation');
grid on
p2 = plot(1:generations,largestFitnessGenerational(1:generations), '-ogr');
lgd = legend([p1 p2],'Average Fitness of population','Largest Fitness of population','Location','northoutside');
title(lgd,'Key:')



end





% %% DEFINE CONSTANTS
% POPULATION_SIZE = 10; % Size of the initial population consisting of chromosomes
% CHROMOSOME_SIZE = 3;  % Size of the bit strings used for the chromosomes
% TARGET_FITNESS = 0;   % Smaller the fitness value the better
% NUMBER_OF_PARENTS = 8;% Number of parents used to generate offspring (For now..
% % this is best as an even number due to how i have written the crossover)  
% 
% %% CREATE TARGET SOLUTION 
% solutionAim = ones(CHROMOSOME_SIZE,1)
% 
% %% QUICK CONFIG CHECKS
% if POPULATION_SIZE<NUMBER_OF_PARENTS
%     error('to many parents compared to population size')    
% end
% 
% %% GENERATE RANDOM POPULATION
% 
% %Initialise population with all zeros just for debugging clarity for now 
% population = zeros(CHROMOSOME_SIZE,POPULATION_SIZE);
% 
% for n = 1:15
%     
%     % Create random bit string
%     population(:,n) = round(rand(CHROMOSOME_SIZE,1));
%     
% end    
% 
% % print population for debuggin purposes
% population
% 
% %% LOOP THROUGH GENERATIONS 
% 
% %Initalise fitness value to value to the lowest fitness value that can occur
% bestFitness = CHROMOSOME_SIZE;
% %Initialise selected array to zero for clarity
% selected = zeros(1,NUMBER_OF_PARENTS)
% %Initialise number of generations
% generation = 0;
% 
% %Run through generations until target solution is found or a certain number
% %of generations have been executed
% while (bestFitness ~= TARGET_FITNESS)&&(generation < 10)
% 
%     
% 
%     generation = generation +1 ;
%     sprintf('Generation: %d', generation)
% 
% end
