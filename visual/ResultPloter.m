function ResultPloter(Data, field,TreeName)
figure1 = figure("Name",field,'Position',[173,265.8,638.4,420]);
axes1 = axes('Parent',figure1)
for ii = 1:numel(TreeName)

    TreeNameLoc = matches(Data.name,TreeName(ii));

    data2Plot = sortrows(Data(TreeNameLoc,["N",field]));
    
    plot(data2Plot,"N",field,'LineWidth',2);
    
    hold on
end
xlabel("Number of modules",'FontSize',18,'Interpreter','latex');
switch field
    case "NumberOfCOnfig"
        ylabel("Tree size",'FontSize',18,'Interpreter','latex');
    case "PathLength"
        ylabel("Path length",'Interpreter','latex','FontSize',18);
end
set(axes1,'FontSize',12);
legend(TreeName,'Interpreter','latex','FontSize',18,'Position',[0.137,0.695,0.546,0.219]);

end