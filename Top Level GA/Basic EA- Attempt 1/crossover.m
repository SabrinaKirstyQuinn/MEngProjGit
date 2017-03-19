function crossedPopulation = crossover(selected,crossingPopulation,CHROMOSOME_SIZE,NUMBER_OF_PARENTS)
    
    % Just create a random number between 1 and 5 to use as locus
    CrossOverLocus = round((CHROMOSOME_SIZE - 2)*rand()+ 1,0) 
    
    % For however many number of parents we are using, cycle through
    for n = 1:(NUMBER_OF_PARENTS-1)
        %Get the selected individuals gene before locus
        selected1Gene = crossingPopulation(:,selected(n))    
        switchGeneSel1 = selected1Gene(1:CrossOverLocus)
        %Get the next selected individuals genes before locus
        selected2Gene = crossingPopulation(:,selected(n+1))  
        switchGeneSel2 = selected2Gene(1:CrossOverLocus)
        %Swap both individuals genes with eachother
        crossingPopulation(1:CrossOverLocus,selected(n+1)) = switchGeneSel1
        crossingPopulation(1:CrossOverLocus,selected(n+1)) = switchGeneSel2
        
    end
    
    %set to new output population 
    crossedPopulation = crossingPopulation
    
end