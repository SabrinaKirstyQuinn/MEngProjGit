function selected = selection(populationFitness,bestFitness)


    % Find index of the best fit
    selected = find(populationFitness==bestFitness,1) 
    
    %problem is what if there is more than one with the same best fitness value 
    %currently only chosening the first best value that occurs
    
end