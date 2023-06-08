function ResultPloter(MeanData,STD, field,TreeName)
figure1 = figure("Name",field,'Position',[173,265.8,638.4,420]);
axes1 = axes('Parent',figure1);
Color = [0,0.45,.74; .93,.69,.13; .85,.33,.1; .49,.18,.56];
for ii = 1:numel(TreeName)

    MeanTreeNameLoc = matches(MeanData.name,TreeName(ii));
    STDTreeNameLoc = matches(STD.name,TreeName(ii));

    Meandata2Plot = sortrows(MeanData(MeanTreeNameLoc,["N",field]));
    STDdata2Plot = sortrows(STD(STDTreeNameLoc,["N",field]));
    x = Meandata2Plot{:,1};
    mean_data = Meandata2Plot{:,2};
    STD_data = STDdata2Plot{:,2};

    lower_bound = mean_data - 2*STD_data;
    upper_bound = mean_data + 2*STD_data;

    plot(Meandata2Plot,"N",field,'LineWidth',2);
    hold on
    fill([x; flip(x)], [upper_bound; flip(lower_bound)],Color(ii), 'FaceAlpha', 0.2, 'EdgeColor', 'none');


    
    
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
try
legend([TreeName(1),"",TreeName(2),"",TreeName(3),""],'Interpreter','latex','FontSize',18,'Position',[0.137,0.695,0.546,0.219]);
catch
legend([TreeName(1),"",TreeName(2),""],'Interpreter','latex','FontSize',18,'Position',[0.137,0.695,0.546,0.219]);

end
end