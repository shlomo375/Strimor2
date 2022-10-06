function MinCost = CostSelector(Cost,MinCost,TreeName)

    CostName = extractBetween(TreeName,"_","__");
    switch CostName
        case "LineCost"
            Cost = 1 - sum(exp(-[Cost(1),Cost(2),Cost(3)]));
            if Cost<MinCost
                MinCost = Cost;
            end
        case "LineCostSam"
            Cost = sum([Cost(1),Cost(2),Cost(3)]);
            if Cost<MinCost
                MinCost = Cost;
            end
        case "LineCostProd"
            Cost = prod([Cost(1),Cost(2),Cost(3)]);
            if Cost<MinCost
                MinCost = Cost;
            end
        case "LineCostInversSam"
            Cost = 1 - sum(1./[Cost(1),Cost(2),Cost(3)]);
            if Cost<MinCost
                MinCost = Cost;
            end
    end

end
