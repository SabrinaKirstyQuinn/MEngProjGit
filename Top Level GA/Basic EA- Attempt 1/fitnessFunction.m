function fitness = fitnessFunction(initialPopulation, solutionAim, CHROMOSOME_SIZE, POPULATION_SIZE)

    chromosome = zeros(CHROMOSOME_SIZE,1);
    fitness = zeros(1,POPULATION_SIZE);
    

    for n = 1:15
        fitLevel = 0;       
        chromosome =  initialPopulation(:,n);
        for a = 1:CHROMOSOME_SIZE           
            gene = chromosome(a,1); 
            desiredGene = solutionAim(a,1);
            if gene == desiredGene
                fitPoint = 0;
            elseif gene ~= desiredGene
                fitPoint = 1;
            end
            fitLevel = fitLevel + fitPoint;
        end
        fitness(1,n) = fitLevel;
    end 
end 