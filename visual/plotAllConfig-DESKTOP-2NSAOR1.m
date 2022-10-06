function plotAllConfig(TreeArray, grid,fileName,extintion)
N = sum(logical(TreeArray{1,"ConfigMat"}{1}),'all');
Size = [N/2 N];
BasicWS = WorkSpace(Size,"RRT*");
for ii=1:size(TreeArray,1)
    ii
    figure(ii);
    Config.Status = TreeArray{ii,"ConfigMat"}{1};
    Config.Type = TreeArray{ii,"Type"};
    WS = SetConfigurationOnSpace(BasicWS,Config);
    if isempty(grid)
        Agents = find(WS.Space.Status);
        PlotWorkSpace(WS,grid,Agents,1,ii);
    else
        PlotWorkSpace(WS,grid);
    end

    saveas(gcf,fileName+string(ii)+extintion);
    close all

end
end
