%Remember currently have the Quadratic test function, so individual size
%bigger than 3 is pointless. 

function [] = GA3(individualSize,popSize,generations)
%% CHECK INPUTS AGAINST CONSTRAINTS MADE
if generations == 0
    genFlag = 0;
else
    genFlag = 1;
end

%% Parameters

numberOfSamples = 30 %for testing function
numParents = 2
numMutations = 1 %the number of mutations to a specific individual
probMutationOccuring = 0.5 %the probability of a individual in a population being mutated
bestFitKeepNo = 20 %the number of best fit individuals from the previous population, carried onto the next population

%% Initialise Population

%Generate random flaots to fill preallocated population and individual size
maxRand = 5.12
minRand = -5.12
population = (maxRand-minRand).*rand(individualSize,popSize) + minRand

%% Target of a Individual

targetIndividual = [4.20;1.5;9]


%% Evaluate Target Individual

%Generate sample points
XsamplePoints = linspace(minRand,maxRand,numberOfSamples);
XsampleSize = size(XsamplePoints);
%Test Function: Create the corresponding Y value for the x test sample points      
targetYsamplePoints(:,1) = TestFunctions.testFunctionQuad(XsampleSize(1,2),XsamplePoints,targetIndividual(:,1));
%Evaluation Function: evaluating the test points returning the RMS
targetRms = evaluationFunctions.evaluationFunctionQuad(XsampleSize(1,2),targetYsamplePoints(:,1),XsamplePoints);



    % plot target solution
    figure(1)
    p2 = plot(XsamplePoints,targetYsamplePoints, '--x');
    hold 'on'
    
    ezsurf(4.20^2 + 1.5^2 + 9)

%% Genetic Algorithm Loop

runSimulation = 1;
currentGeneration = 0;

while (runSimulation)
   
    %Generation count
    currentGeneration = currentGeneration +1;
    sprintf('Generation: %d', currentGeneration)  

    
    %Calculating fitness   
    for currentIndividual = 1:popSize      
        %Test Function: Create the corresponding Y value for the x test sample points      
        YsamplePoints(:,currentIndividual) = TestFunctions.testFunctionQuad(XsampleSize(1,2),XsamplePoints,population(:,currentIndividual));
        %Evaluation Function: evaluating the test points returning the RMS
        rms(currentIndividual) = evaluationFunctions.evaluationFunctionQuad(XsampleSize(1,2),YsamplePoints(:,currentIndividual),XsamplePoints);
        %Assining fitness value - Lower value = better fitness
        desiredFitness =0;
        fittnessValue(currentIndividual) = abs(targetRms - rms(currentIndividual));
        
        
        %Plot function
%         figure(1)
%         p1 = plot(XsamplePoints,YsamplePoints, '-o');
%         titleString = sprintf( 'plot function');
%         title(titleString);
%         grid on
%         hold on ;       
    end
    largestFitness(currentGeneration) = min(fittnessValue);
    sumFitnessValues = sum(fittnessValue);
    averageFitness(currentGeneration) = sumFitnessValues/popSize;   
    %Plot Average Fitness and largest fitness
%     figure(2);
%     p3 = plot(1:currentGeneration,averageFitness(1:currentGeneration), '-o');
%     p4 = plot(1:currentGeneration,largestFitness(1:currentGeneration), '-ogr');
%     hold 'on'   
%     
    % Selection - Creating Roulette Wheel
    startRange = 0;
    for currentIndividual = 1:popSize 
       %Set the probability of the individual with relevence to the other individuals  
       probabilityOfSelection = fittnessValue(currentIndividual)/sumFitnessValues;
       %Makeing it so the higher the value, the better the fitness, so that
       %fitter values will have the largest probability of being selected
       probabilityOfSelection = 1 - probabilityOfSelection;
       %Calculate the amount of numbers that represent its probability
       endRange = startRange + probabilityOfSelection;
       %Add the end range number to each individual
       population(individualSize+1,currentIndividual) = endRange;
       %Next number range starts from where the previous last stopped
       startRange = endRange;       
    end
    
    %Selecting parents using roulette wheel
    numParentsSelected = 0;
    parentsSelectedIndexNumbers =0;
    %for the number of parents required
    for numParentsSelected = 1:numParents
        currentIndividual = 1;
        newParent =1;
        %Generate random number for selection
        randomNumberRoulette = rand*(individualSize);
        %Step through all the populations individuals
        while (currentIndividual <= popSize)
            %Get current individuals range
            currentIndividualRange = population((individualSize+1),currentIndividual);
            %When the range number of the individual is bigger than the random
            %number, it means the previous individual must have the rand
            %generated number within its range. 
            if (currentIndividualRange) > (randomNumberRoulette);
                %Therefore that individual is the new parent
                if (currentIndividual ~= 1)
                    newParent = currentIndividual;
                end
                %If parent hasnt already been selected for use
                %ismember returns true when 
                if ~(ismember(newParent, parentsSelectedIndexNumbers))
                    parentsSelectedIndexNumbers(numParentsSelected) = newParent;
                    %Get the selected parents genes and put them in array
                    selectedGenes(1:individualSize,numParentsSelected) = population(1:individualSize,parentsSelectedIndexNumbers(numParentsSelected));
                    currentIndividual = popSize + 1;          
                else 
                    % Make a new random number and start again, if parent has
                    % already been selected
                    randomNumberRoulette = rand*(individualSize);
                    currentIndividual = 0;        
                end    
            end
            currentIndividual = currentIndividual + 1;
        end
    end 
    
    % Crossover function: Single random locus
    numOffspring = popSize/numParents;
    intermediatePositionEnd = 0;
    intermediatePositionStart = 1;
    offspringSize = 0; 
    crossingGenesNo = numParents;
    for currentOffspring = 1:numOffspring
        %Create random locus within range
        randLocusPoint = round(rand*(individualSize-2)) +2;
        %For however many number of parents we are using, cycle through
        for n = 1:crossingGenesNo 
            %ensure all genes used correctly
            if n == crossingGenesNo
                mate = 1;
            else
                mate = n +1;
            end
            offspring(1:randLocusPoint,n) = selectedGenes(1:randLocusPoint,n);
            offspring(randLocusPoint+1:individualSize,n) = selectedGenes(randLocusPoint+1:individualSize,mate);
            offspringSize = offspringSize +1;
        end     
        %Storing offspring in intermediate population       
        intermediatePositionEnd = intermediatePositionEnd + numParents;
        %intermediatePop = [intermediatePop offspring]
        intermediatePop(:,intermediatePositionStart:intermediatePositionEnd) = offspring(:,1:numParents);
        intermediatePositionStart = intermediatePositionStart + numParents;
        mate=0;
    end
    
    % Mutation: Random Resetting 
    for p = 1:offspringSize
        prob = rand();
        if prob < probMutationOccuring
            for n = 1:numMutations;
                randGeneToMutate = round(rand*(individualSize-1)) +1;
                %Generate random number within range and add to population
                intermediatePop(randGeneToMutate,p) = (maxRand-minRand).*rand() + minRand;
                disp('a mutation occured')
            end
        end 
    end 

    %New population - Elitism Function 
    IndAmoutCarriedOn = 0;
    %amount of individuals needed to match initial population size
    remainder = mod(popSize,numParents);
    intPopSize= size(intermediatePop);
 
    addIndToPop = bestFitKeepNo + remainder;
    %Step through the required number of individuals to add 
        for n = 1:addIndToPop
            %Take out the fittest from the old population
            [fitValueOldPop,bestValOldPopIndex] = max(population(individualSize+1,:));
            population(individualSize+1,bestValOldPopIndex)=0;
            %Generate random placement for the individual, ranged for the
            %intermediate pop size so it doesn't place over the remainder
            %ones added in.
            randPlacement = round(rand*(intPopSize(1,2)-1)) +1;
            %Replace into the intermediate population the amount of best
            %fit individuals specified
            if remainder == 0 
                intermediatePop(1:individualSize,randPlacement)= population(1:individualSize,bestValOldPopIndex);
                IndAmoutCarriedOn = IndAmoutCarriedOn+1;
            %Fill population to correct siz if needed due to a odd number,
            %adding best fit individuals from previous population
            elseif (remainder > 0) 
                intermediatePop(1:individualSize,( -remainder)) = population(1:individualSize,bestValOldPopIndex);
                IndAmoutCarriedOn = IndAmoutCarriedOn+1;
                remainder = remainder -1;  
            end
        end
    %Take on population to next generation
    population = intermediatePop    

%Allow for the EA to only stop when it reaches desired fitness   
    if ((genFlag == 1)&&(currentGeneration >= generations))||(desiredFitness == largestFitness(currentGeneration))
        runSimulation = 0;
    end
end

%% Plot information 
figure
% xlim([1 currentGeneration]);
% ylim([1 desiredFitness]);
p1 = plot(1:currentGeneration,averageFitness(1:currentGeneration), '-o');
titleString = sprintf('GA3: EA Generations Vs Average Fitness of Population');
title(titleString);
hold on ;
ylabel('Average Fitness of Population');
xlabel('EA Generation');
grid on
p2 = plot(1:currentGeneration,largestFitness(1:currentGeneration), '-ogr');
%p3 = plot(1:currentGeneration,minFitnessGenerational(1:currentGeneration), '-om');
lgd = legend([p1 p2],'Average Fitness of population','Largest Fitness of population','Location','northoutside');
title(lgd,'Key:')

end
