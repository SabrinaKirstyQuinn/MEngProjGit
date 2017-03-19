classdef TestFunctions
    properties
        
    end
    methods
    
    %% Test Functin: Basic Quadratic - a(1)x^2 + a(2)x + a(3)
    function [YsamplePoints] = testFunction(XsampleSize,XsamplePoints,population)

        for sample = 1:XsampleSize
            YsamplePoints(sample) = (population(1,1))*XsamplePoints(sample)^2 + population(2,1)*XsamplePoints(sample) + population(3,1);
        end

    end


    %% Test Function: Multi-Objective bin packing problem
    function [] = testFunctionBinPacking(population,individualSize,popSize)

        binSize = 20
        %Set item weights
        testItems = [4,3,6,5,6,9,9,8,5,3,6,4,1,1,1,1,2,3,3,5,6,7,4]
        numTestItems = size(testItems)
        %Provide item ID's
        testItems(2,:) = 1:numTestItems(1,2)

        %Make sure
        if individualSize ~= numTestItems
           error('A item is being missed within the individuals size')
        end

        for individual = 1:popSize
            for currentItem = 1:individualSize


                itemID = population(individual,currentItem)

                %test how the new item will effect
                currentPackedBin = currentPackedBin + testItems(1,itemID)

                %if bin overflows
                if currentPackedBin > binSize
                    %Assign the items to that bin
                    bin(binID,1)= packedBinWeight
                    bin(binID,2)= packedBinNumItems
                    %take this item to put into the next bin
                    currentItem = currentItem -1
                    %move on to next bin
                    binID = binID+1
                    %reset Bin weight to none and item number
                    packedBinWeight =0
                    packedBinNumItems =0
                %if bin doesnt overflow
                elseif currentPackedBin <= binSize
                    %Keep item in this bin
                    packedBinWeight = currentPackedBin
                    packedBinNumItems = packedBinNumItems +1;
                end
            end   
        end
end


