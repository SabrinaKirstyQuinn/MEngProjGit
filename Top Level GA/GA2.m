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
%% varibles used for mapping bits
% number bits for integer part of number  
numBitsConvertIntergerPart = 16;
% number bits for decimal part of number
numBitsConvertDecimalPart = 25;

convertedBitNoSize = numBitsConvertIntergerPart + numBitsConvertDecimalPart

%% CREATE TARGET SOLUTION = (Bit string full of ones)

solutionTarget = zeros(chromsomeSize*convertedBitNoSize,1) %minimun

%% GENERATE RANDOM POPULATION
 
%Initialise population with all zeros just for debugging clarity for now 
%population = zeros(chromsomeSize*convertedBitNoSize +1,popSize);

% for n = 1:popSize
%    placement = 1;
%    for c = 1:chromsomeSize
%         %random number between 5 and -5
%         randomNo= -5 + (5+5)*rand()
%         %Stick initial rand interger into a input array 
%         intInput(c,n) = randomNo
%         %convert interger into bits
%         q = quantizer([convertedBitNoSize,3]);
%         convertedBitNo = num2bin(q,randomNo)
%         convertedBitNo(isspace(convertedBitNo)) = ''
%         testUsingSameFunctionToConvertBackToInitialInt = bin2num(q,convertedBitNo)
%         
%         % just for better thought process, invert
%         convertedBitNo = convertedBitNo';
%         for a = 1 : convertedBitNoSize;
%             % Create random bit string
%             str1 = str2num(convertedBitNo(a,1));
%             population(placement,n) = str1;
%             placement = placement + 1;
%         end  
%    end     
% end    

for n = 1:popSize
   placement = 1;
   for c = 1:chromsomeSize
        %random number between 5 and -5, float point number
        randomNo= -5 + (5+5)*rand()
        %Stick initial rand interger into a input array 
        intInput(c,n) = randomNo
        %convert interger into bits
        d2b = fix(rem(randomNo*pow2(-(numBitsConvertIntergerPart-1):numBitsConvertDecimalPart),2))
        % the inverse transformation -testing
        %b2d = d2b*pow2(numBitsConvertIntergerPart-1:-1:-numBitsConvertDecimalPart).'

        convertedBitNo = d2b';
        for a = 1 : convertedBitNoSize;
            % Create random bit string
            population(placement,n) = convertedBitNo(a,1);
            placement = placement + 1;
        end  
   end     
end    

% startPlacement = 1;
% for n = 1:popSize
%     for c = 1:chromsomeSize
%         endPlacement = startPlacement + convertedBitNoSize;
%         it = population(startPlacement:endPlacement,n);
%         it = it';
%         itt = num2str(it)
%         
%         itt(isspace(itt)) = ''
%        
%         interger = bin2num(q,itt)
%         startPlacement = c+convertedBitNoSize;
%     end 
% end


  intInput;
  bitPopSize = size(population)
% print population for debuggin purposes


%% LOOP THROUGH GENERATIONS 
runSimulation = 1
currentGeneration = 0;
fittnessPoint = 0;
desiredFitness = bitPopSize(1,1)+1;

%Run through generations until target solution is found or a certain number
%of generations have been executed
while (runSimulation)
    %timer
    tic
    timerValue = tic;
        toc
    elapsedTime = toc
    toc(timerValue)
    elapsedTime = toc(timerValue)
    
    totalFitness=0;
    largestFitness =0;
    intermediatePop = zeros(bitPopSize(1,1), popSize);

%Generation count
    currentGeneration = currentGeneration +1;
    sprintf('Generation: %d', currentGeneration)

    population
    

% Calculating fitness
    %Stepping through each chromosome in the poulation
    for n = 1:popSize
        fitnessSum = 0;
        allelePop = 0;
        alleleTarget = 0;
        %Stepping through each allele
        for a = 1:bitPopSize(1,1);
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
        indSize = bitPopSize(1,1);
        population(indSize+1,n) = fitnessSum;
        %Fittest individual - max value       
        accessfitnessValues = bitPopSize(1,1)+1;
        largestFitness = max(population(accessfitnessValues,:));
        %Minimum fitness
        minFitness  = min(population(accessfitnessValues,:));
        %Calculating total fitness of the population
        totalFitness = totalFitness + fitnessSum;          
    end
    averageFitness(currentGeneration) = totalFitness/popSize;
    largestFitnessGenerational(currentGeneration) = largestFitness;
    minFitnessGenerational(currentGeneration)= minFitness;
         
% Selection - Creating Roulette Wheel
    %Offset of 0.1 given to make it easier to define random number range
    prevNumRange =0.1;
    numberRange =0;
    for n = 1:popSize             
        %Calculating individuals probabilities of selection 
        selectProbability = population((bitPopSize(1,1)+1),n)/(totalFitness);
        %these popbabilities will always sum to a range of 0-1. 
        numberRange = prevNumRange + selectProbability;
        population((bitPopSize(1,1)+2),n) = numberRange; 
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
            currentIndividualRange = population((bitPopSize(1,1)+2),individual);
            if (currentIndividualRange) > (randomNumber);
                newParent = individual - 1 ;
                if ~(ismember(parentsSelectedIndexNumbers, newParent))
                    parentsSelectedIndexNumbers(n,1) = newParent;
                    %Get the selected parents genes and put them in array
                    selectedGenes(1:bitPopSize(1,1),n) = population(1:bitPopSize(1,1),parentsSelectedIndexNumbers(n,1));
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
    crossingGenesNo = numParents;
    for c = 1:crossoverNum
        %Create random locus within range
        randLocusPoint = round(rand*(bitPopSize(1,1)-2)) +2;
        %For however many number of parents we are using, cycle through
        for n = 1:crossingGenesNo 
            %ensure all genes used correctly
            if n == crossingGenesNo
                mate = 1;
            else
                mate = n +1;
            end
            offspring(1:randLocusPoint,n) = selectedGenes(1:randLocusPoint,n);
            offspring(randLocusPoint+1:bitPopSize(1,1),n) = selectedGenes(randLocusPoint+1:bitPopSize(1,1),mate);
            offspringSize = offspringSize +1;
           
            
        end      
        %Storing offspring in intermediate population       
        intermediatePositionEnd = intermediatePositionEnd + numParents;
        %intermediatePop = [intermediatePop offspring]
        intermediatePop(:,intermediatePositionStart:intermediatePositionEnd) = offspring(:,1:numParents);
        intermediatePositionStart = intermediatePositionStart + numParents;
        mate=0;
    end
     

% Mutation 
    for p = 1:offspringSize
        for n = 1:numMutations
            bitFlip = round(rand*(bitPopSize(1,1)-1)) +1;
            alleleToFlip = intermediatePop(bitFlip,p);
            alleleFlipped = ~alleleToFlip;
            intermediatePop(bitFlip,p) = alleleFlipped;
        end       
    end 
    
%new population
    IndAmoutCarriedOn = 0;
    addIndToPop = bestFitKeepNo + remainder;
     
        for n = 1:addIndToPop
            %Take out the fittest from the old population
            [fitValueOldPop,bestValOldPopIndex] = max(population(bitPopSize(1,1)+1,:));
            population(bitPopSize(1,1)+1,bestValOldPopIndex)=0;
            %Replace into the intermediate population 
            if remainder == 0 
                intermediatePop(1:bitPopSize(1,1),n)= population(1:bitPopSize(1,1),bestValOldPopIndex);
                IndAmoutCarriedOn = IndAmoutCarriedOn+1;
            elseif (remainder > 0) 
                intermediatePop(1:bitPopSize(1,1),popSize) = population(1:bitPopSize(1,1),bestValOldPopIndex);
                IndAmoutCarriedOn = IndAmoutCarriedOn+1;
                remainder = remainder -1;
                
            end
        end
        
% Convert bits back to intergers        
startPlacement = 1
for n = 1:popSize 
   for c = 1:chromsomeSize      
       endPlacement = startPlacement + convertedBitNoSize -1
       it = population(startPlacement:endPlacement,n)
       it = it'
       startPlacement = c+convertedBitNoSize       
        % the inverse transformation
        intergerOutput(c,n) = it*pow2(numBitsConvertIntergerPart-1:-1:-numBitsConvertDecimalPart).'        
   end
end        

        
    population = intermediatePop;    
    
            
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
