% Inner loop with a multiObjective bin packing test, based upon the NSGA-2 

function [] = InnerGA1(individualSize,popSize,generations)
%% CHECK INPUTS AGAINST CONSTRAINTS MADE
if generations == 0
    genFlag = 0;
else
    genFlag = 1;
end

%% Parameters

numObjectives = 2

%numberOfSamples = 30 %for testing function
%numParents = 2
%numMutations = 1 %the number of mutations to a specific individual
%probMutationOccuring = 0.1 %the probability of a individual in a population being mutated
%bestFitKeepNo = 1 %the number of best fit individuals from the previous population, carried onto the next population

%% Initialise Population

%Generate random flaots to fill preallocated population and individual size
maxRand = 23
minRand = 1

for individualNum = 1:popSize
    gene = 1;
    individual = zeros(individualSize,1);
    while gene <= individualSize
        randNum = round((maxRand-minRand).*rand() + minRand);
        if ~(ismember(randNum,individual));
            individual(gene,1) = randNum;
            gene = gene+1;
            population(:,individualNum) = individual;
        end
    end  
end

%% Genetic Algorithm Loop

runSimulation = 1;
currentGeneration = 0;

while(runSimulation)
   
    %Generation count
    currentGeneration = currentGeneration +1;
    sprintf('Generation: %d', currentGeneration)  
     
%     %Fitness Function:  
%     [desiredWeightPerBin, bin, numBinsUsed] = TestFunctions.testFunctionBinPacking(population,individualSize,popSize);
%     [fitnessValueObjective1, fitnessValueObjective2] = evaluationFunctions.evaluationFunctionBinPacking(desiredWeightPerBin, bin, numBinsUsed, popSize);
%     %Graph plotting the objective fitness of each individual against
%     %eachover
%     xMaxAxis = max(fitnessValueObjective1) + 10;
%     yMaxAxis = max(fitnessValueObjective2) + 10;
%     plot(fitnessValueObjective1(1,:),fitnessValueObjective2(1,:),'k*');
%     title('Every individuals fitness objective2 vs fitness objective 1');
%     ylabel('f(2)');
%     ylim([0 yMaxAxis]);
%     xlim([0 xMaxAxis]);
%     xlabel('f(1)');
    
    
    
    %Quick mauual test 

    fitnessValueObjective1 = [5,8,19,2,3,8,5,7,8,5,20,15,1,6,8,6,8,3,4,3,2,2,3,13]
    fitnessValueObjective2 = [4,5,6,7,7,12,2,4,18,8,9,5,3,4,7,6,6,7,3,13,2,3,12,15]
    %fitnessValueObjective1(2) = [1:individualSize]
    %fitnessValueObjective2(2) = [1:individualSize]




    %Fast Non Dominating Sorting Function
    %positioned in the population array 
    dominationSetPlacement = 1;
    %contains the number of individuals that dominate a certain individual
    dominatedCount =zeros(1, popSize);
    %contains the number of the individuals, that that individual has
    %dominated
    dominationSet = zeros(1, popSize);
    %Rank placement within the population 
    rankPlacement = individualSize + 1;
    
    fronts{1} =[];
    dominationSet1Placement = 1;
    dominationSet2Placement = 1;
    
    largestObjective1 = 1
    largestObjective2 = 1
    %Fast Non-Dominated Sorting function:
    for individual = 1:popSize
        equalDominance = 0 
        %get the selected individuals objectives
        selectedIndividual(1) = fitnessValueObjective1(individual)
        selectedIndividual(2) = fitnessValueObjective2(individual)
        for nextIndividual = individual + 1:popSize
            %get the objectives for the selected next individual
            selectedNextIndividual(1) = fitnessValueObjective1(nextIndividual)
            selectedNextIndividual(2) = fitnessValueObjective2(nextIndividual) 
                

            
            %individual dominates next individual if all are less
            if (selectedIndividual(:) <= selectedNextIndividual(:)) 
                %add next individual to the current individuals domination
                %set
                dominationSet(dominationSet1Placement,individual) = nextIndividual
                dominationSet1Placement = dominationSet1Placement + 1
                %add a extra count to the next individuals dominated count
                dominatedCount(nextIndividual)= dominatedCount(nextIndividual)+1 
            elseif (selectedIndividual(1) <= selectedNextIndividual(1)) && (selectedIndividual(2) <= selectedNextIndividual(2))
                %add next individual to the current individuals domination
                %set
                dominationSet(dominationSet1Placement,individual) = nextIndividual
                dominationSet1Placement = dominationSet1Placement + 1
                %add a extra count to the next individuals dominated count
                dominatedCount(nextIndividual)= dominatedCount(nextIndividual)+1
                
             elseif (selectedIndividual(2) <= selectedNextIndividual(2)) && (selectedIndividual(1) <= selectedNextIndividual(1))
                %add next individual to the current individuals domination
                %set
                dominationSet(dominationSet1Placement,individual) = nextIndividual
                dominationSet1Placement = dominationSet1Placement + 1
                %add a extra count to the next individuals dominated count
                dominatedCount(nextIndividual)= dominatedCount(nextIndividual)+1
            
 
            %if next individual dominates this individual
            elseif selectedNextIndividual(:) >= selectedIndividual(:)
                %add individual to the next individuals domination set
                dominationSet(dominationSet1Placement,nextIndividual) = individual
                dominationSet1Placement = dominationSet1Placement + 1
                %add a extra count to the individuals dominated count
                dominatedCount(individual)= dominatedCount(individual)+1 
            elseif (selectedIndividual(1) >= selectedNextIndividual(1)) && (selectedIndividual(2) >= selectedNextIndividual(2))
                %add individual to the next individuals domination set
                dominationSet(dominationSet1Placement,nextIndividual) = individual
                dominationSet1Placement = dominationSet1Placement + 1
                %add a extra count to the individuals dominated count
                dominatedCount(individual)= dominatedCount(individual)+1 
            elseif (selectedIndividual(2) >= selectedNextIndividual(2))&& (selectedIndividual(1) >= selectedNextIndividual(1))           
                %add individual to the next individuals domination set
                dominationSet(dominationSet1Placement,nextIndividual) = individual
                dominationSet1Placement = dominationSet1Placement + 1
                %add a extra count to the individuals dominated count
                dominatedCount(individual)= dominatedCount(individual)+1
            
            elseif (selectedIndividual(1) == selectedNextIndividual(1))||(selectedIndividual(2) == selectedNextIndividual(2))
                equalDominance = equalDominance+1
            end
            
        end   
        %If the individual has a dominated count of zero, it hasnt been
        %dominated by anything, therefore it is the most dominant
        if (dominatedCount(individual) == 0) && (equalDominance ~= numObjectives)
            population(rankPlacement, individual) = 1
            %add individual to the first front
            fronts{1} = [fronts{1} individual]
            fronts{1};
        end
        
    end
    %Sorting into fronts     
    dominationSetSize = size(dominationSet)
    k = 1
    while true
        %que for temporarily storing the values for K+1 front
        Que = []

        %select individuals out of current front     
        for individual = fronts{k}     
            %for all values within the domination set of said individual
            for dominationSetIndividualIndex = 1:dominationSetSize(1,1)
                dominationSet
                fronts{k}
                
                %select a individual from the domination set
                dominationSetIndividual = dominationSet(dominationSetIndividualIndex,individual) 
                
                
                if dominationSetIndividual ~= 0

                
                    %reduce the dominated count of this individual by 1
                    dominatedCount(dominationSetIndividual) = dominatedCount(dominationSetIndividual) - 1
                    %if dominated count of the individual selected from the
                    %dominated set = 0, no other values in the subset are
                    %dominant
                    if dominatedCount(dominationSetIndividual) == 0
                        Que=[Que dominationSetIndividual]
                        rank = k + 1
                        population(rankPlacement, dominationSetIndividual) = rank
                    end 
               end
            end 
        end
        %Print fronts for testing
        for n = 1:k
            fronts{n}
        end
        
        if isempty(Que)
            break;
        end
        k = k + 1
        fronts{k} = Que
        
    end
    
    xMaxAxis = max(fitnessValueObjective1) + 10;
    yMaxAxis = max(fitnessValueObjective2) + 10;
    for currentFront = 1:k 
    plot(fitnessValueObjective1(1,fronts{currentFront}),fitnessValueObjective2(1,fronts{currentFront}),'--*');
    hold on
    end
    title('Every individuals fitness objective2 vs fitness objective 1');
    ylabel('f(2)');
    ylim([0 yMaxAxis]);
    grid minor 
    xlim([0 xMaxAxis]);
    xlabel('f(1)');
    
    
   population
   fitnessValueObjective1
   fitnessValueObjective2       
        
        
        
        
runSimulation = 0;
end
end
    
    
    
    
    




