function ResultPloter(Data, field,TreeName)

for ii = 1:numel(TreeName)

    TreeNameLoc = matches(Data.name,TreeName(ii));

    data2Plot = sortrows(Data(TreeNameLoc,["N",field]));
    
    plot(data2Plot,"N",field);
    
    hold on
end

legend(TreeName)

end