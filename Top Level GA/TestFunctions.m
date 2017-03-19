classdef TestFunctions
  
    methods(Static)
    
        %% Test Functin: Basic Quadratic - a(1)x^2 + a(2)x + a(3)
        function [YsamplePoints] = testFunctionQuad(XsampleSize,XsamplePoints,population)

            for sample = 1:XsampleSize
                YsamplePoints(sample) = (population(1,1))*XsamplePoints(sample)^2 + population(2,1)*XsamplePoints(sample) + population(3,1);
            end
         

        end


        %% Test Function: Multi-Objective bin packing problem
        function [desiredWeightPerBin, bin, numBinsUsed] = testFunctionBinPacking(population,individualSize,popSize)

            binSize = 20;
            %Set item weights
            testItems = [4,3,6,17,6,9,9,8,5,3,15,4,1,1,1,1,2,13,3,5,6,7,4];
            numTestItems = size(testItems);
            %Provide item ID's
            testItems(2,:) = 1:numTestItems(1,2);

            %Make sure
            if individualSize ~= numTestItems
               error('A item is being missed within the individuals size')
            end
            weightBinLocation = 1;
            numItemsBinLocation = 2;
            numBinsUsed(popSize) = 0;
            for individual = 1:popSize
                currentPackedBin = 0;
                packedBinNumItems = 0;
                packedBinWeight =0;
                binID = 1;
                currentItem =1;
                while (currentItem ~= individualSize+1)      

                    itemID = population(currentItem,individual);

                    %test how the new item will effect
                    currentPackedBin = currentPackedBin + testItems(1,itemID);

                    %If packing last item
                    if currentItem == individualSize
                        %Keep item in this bin
                        packedBinWeight = currentPackedBin;
                        packedBinNumItems = packedBinNumItems +1;
                        %Assign the items to that bin
                        bin(binID,weightBinLocation)= packedBinWeight;
                        bin(binID,numItemsBinLocation)= packedBinNumItems;
                        %track bins
                        numBinsUsed(individual) = numBinsUsed(individual)+1
                    %if bin overflows
                    elseif currentPackedBin > binSize
                        %Assign the items to that bin
                        bin(binID,weightBinLocation)= packedBinWeight;
                        bin(binID,numItemsBinLocation)= packedBinNumItems;
                        %take this item to put into the next bin
                        currentItem = currentItem -1;
                        %move on to next bin
                        binID = binID+1;
                        %reset Bin weight to none and item number
                        packedBinWeight =0;
                        packedBinNumItems =0;
                        currentPackedBin =0;
                        %track bins
                        numBinsUsed(individual) = numBinsUsed(individual)+1;
                    %if bin doesnt overflow
                    elseif (currentPackedBin <= binSize) && (currentItem ~= individualSize)
                        %Keep item in this bin
                        packedBinWeight = currentPackedBin;
                        packedBinNumItems = packedBinNumItems +1; 
                    end
                    
                    currentItem = currentItem +1;
                end
                %Calculate data needed for every solution
                %Desired weight of bins changes depending on the num bins
                %used
                sumWeightsEveryIndividual = sum(bin(:,weightBinLocation));
                desiredWeightPerBin(individual) = sumWeightsEveryIndividual/numBinsUsed(individual);
                
                %New potential solution being tested
                weightBinLocation = weightBinLocation +2;
                numItemsBinLocation = numItemsBinLocation +2;
            end           
        end
    end
end


