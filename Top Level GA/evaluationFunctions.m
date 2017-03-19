classdef evaluationFunctions
  
    methods(Static)

    
        %% Evaluation function: Test results for each individual - using RMS for Quadratic
        function [rms] = evaluationFunctionQuad(XsampleSize,YsamplePoints,XsamplePoints)
                sumYminusXsquared = 0;
                for sample = 1:XsampleSize           
                    sumYminusXsquared = sumYminusXsquared + (YsamplePoints(sample)-XsamplePoints(sample))^2;
                end
                rms = 1/XsampleSize * sqrt(sumYminusXsquared);
        end
        
        %%Evaluation function for bin packing multi-objective problem
        function [fitnessValueObjective1, fitnessValueObjective2] = evaluationFunctionBinPacking(desiredWeightPerBin, bin, numBinsUsed, popSize)
            
             weightColumn = 1;
             individual =1; 
             %Looking at every individuals weight column
             while weightColumn <= popSize*2
                 %Looking at the weight in every bin 
                 for currentBin = 1:numBinsUsed(individual)                      
                    %Objective 1: equal balance of weight
                    %Zero being the fittest value
                    differenceToDesired(currentBin) = desiredWeightPerBin(individual) - bin(currentBin,weightColumn);
                    differenceToDesired = abs(differenceToDesired);                     
                 end
                 fitnessValueObjective1(individual) = sum(differenceToDesired);
                 weightColumn = weightColumn +2;
                 individual = individual +1;
                    
                 %Objective 2: Minimum num bins used
                 %Need to think about this, minimum amount of bins, but
                 %the minimum amount of bins is unknown, but i could
                 %calculate it, but i dont think thats the point, i
                 %should be able to calculate things without a exact
                 %answer right? 
                    
                 fitnessValueObjective2 = numBinsUsed;                  
            end        
        end        
    end
end