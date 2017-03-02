function [] = GA2(popSize, generations, chromsomeSize, numParents, numMutations,bestFitKeepNo)
%% CHECK INPUTS AGAINST CONSTRAINTS MADE
if popSize < numParents
    error('to many parents compared to population size')  
end
if numMutations > chromsomeSize
    error('number of mutations in chromosome is to big compared to the chromosomeSize') 
end
if generations == 0
    genFlag = 0;
else
    genFlag = 1;
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
runSimulation = 1
currentGeneration = 0;
fittnessPoint = 0;
desiredFitness = chromsomeSize+1;
largestFitness = 0;

%Run through generations until target solution is found or a certain number
%of generations have been executed
while (currentGeneration ~= generations)
    tic
    timerValue = tic;
        toc
    elapsedTime = toc
    toc(timerValue)
    elapsedTime = toc(timerValue)
    
    totalFitness=0;
    largestFitness =0;
    intermediatePop = zeros(chromsomeSize, popSize)

%Generation count
    currentGeneration = currentGeneration +1;
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
        fitnessSum = fitnessSum + 1;       
        %Saving fitness value 
        population(chromsomeSize+1,n) = fitnessSum;        
        %Fittest individual - max value       
        accessfitnessValues = chromsomeSize+1;
        largestFitness = max(population(accessfitnessValues,:));  
        %Minimum fitness
        minFitness  = min(population(accessfitnessValues,:));
        %Calculating total fitness of the population
        totalFitness = totalFitness + fitnessSum;          
    end
    averageFitness(currentGeneration) = totalFitness/popSize;
    largestFitnessGenerational(currentGeneration) = largestFitness;
    minFitnessGenerational(currentGeneration)= minFitness;
     
population
    
% Selection - Creating Roulette Wheel
    %Offset of 0.1 given to make it easier to define random number range
    prevNumRange =0.1;
    numberRange =0;
    for n = 1:popSize             
        %Calculating individuals probabilities of selection 
        selectProbability = population((chromsomeSize+1),n)/(totalFitness);
        %these popbabilities will always sum to a range of 0-1. 
        numberRange = prevNumRange + selectProbability;
        population((chromsomeSize+2),n) = numberRange; 
        prevNumRange = numberRange;
    end 
   
 population 
 
% Selecting parents using roulette wheel
    currentIndividualRange =0;
    parentsSelectedIndexNumbers = zeros(numParents,1);
    for n = 1:numParents
        %remember offset so range is 0.1 to 1.1
        randomNumber = 0.1 + rand*(1.1-0.1);
        individual = 1;
        while (individual <= popSize)
            currentIndividualRange = population((chromsomeSize+2),individual);
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
 
 population   
    
% Crossover  
    crossoverNum = popSize/numParents;
    remainder = mod(popSize,numParents);
    intermediatePositionEnd = 0;
    intermediatePositionStart = 1;
    offspringSize = 0; 
    crossingGenesNo = numParents
    for c = 1:crossoverNum
        %Create random locus within range
        randLocusPoint = round(rand*(chromsomeSize-2)) +2;
        %For however many number of parents we are using, cycle through
        for n = 1:crossingGenesNo 
            %ensure all genes used correctly
            if n == crossingGenesNo
                mate = 1;
            else
                mate = n +1;
            end
            offspring(1:randLocusPoint,n) = selectedGenes(1:randLocusPoint,n);
            offspring(randLocusPoint+1:chromsomeSize,n) = selectedGenes(randLocusPoint+1:chromsomeSize,mate);
            offspringSize = offspringSize +1
            offspring
            
        end      
        %Storing offspring in intermediate population       
        intermediatePositionEnd = intermediatePositionEnd + numParents
        %intermediatePop = [intermediatePop offspring]
        intermediatePop(:,intermediatePositionStart:intermediatePositionEnd) = offspring(:,1:numParents)
        intermediatePositionStart = intermediatePositionStart + numParents
        mate=0;
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
    
    intermediatePop
%Cull old population and all offspring is used as the new population
    
    IndAmoutCarriedOn = 0;
   
    addIndToPop = bestFitKeepNo + remainder
     
        for n = 1:addIndToPop
            sprintf('CCC')
            addIndToPop
            %Take out the fittest from the old population
            [fitValueOldPop,bestValOldPopIndex] = max(population(chromsomeSize+1,:))
            population(chromsomeSize+1,bestValOldPopIndex)=0
            %Replace into the intermediate population 
            if remainder == 0 
                n
                sprintf('AAAA')
                remainder
                intermediatePop(1:chromsomeSize,n)= population(1:chromsomeSize,bestValOldPopIndex)
                IndAmoutCarriedOn = IndAmoutCarriedOn+1
            elseif (remainder > 0) 
                sprintf('BBBBB')
                remainder
                intermediatePop(1:chromsomeSize,popSize) = population(1:chromsomeSize,bestValOldPopIndex)
                IndAmoutCarriedOn = IndAmoutCarriedOn+1
                remainder = remainder -1
                
            end
        end
    population = intermediatePop
    addIndToPop = 0
    
           
  
%Allow for the EA to only stop when it reaches desired fitness   
   if ((genFlag == 1)&&(currentGeneration >= generations))||(desiredFitness == largestFitness)
       runSimulation = 0;
   end
   


end

%% Plot information 
figure
% xlim([1 currentGeneration]);
% ylim([1 desiredFitness]);
p1 = plot(1:currentGeneration,averageFitness(1:currentGeneration), '-o');
titleString = sprintf('GA2: EA Generations Vs Average Fitness of Population, (Population size = %d, Generations = %d, Chromosome size = %d, No. of parents = %d, No. of mutations = %d, StopWatch = %d )' ,popSize, currentGeneration, chromsomeSize, numParents, numMutations, elapsedTime');
title(titleString);
hold on ;
ylabel('Average Fitness of Population');
xlabel('EA Generation');
grid on
p2 = plot(1:currentGeneration,largestFitnessGenerational(1:currentGeneration), '-ogr');
p3 = plot(1:currentGeneration,minFitnessGenerational(1:currentGeneration), '-om');
lgd = legend([p1 p2 p3],'Average Fitness of population','Largest Fitness of population','Minimum Fitness of population','Location','northoutside');
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
