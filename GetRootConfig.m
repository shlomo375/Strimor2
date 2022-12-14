function RootConfigs = GetRootConfig(ds,info)

Files = ds.Files(contains(string(ds.Files),"size"));
File = load(Files{randi(numel(Files))},"FileData");

RootConfigs = File.FileData(randi(size(File,1)),:);

end
% [Data,FileIndex] = GetVariablesFromDs(ds,["Visits","Cost2Target"]);
% data.Visits = Data(:,1);
% data.Cost2Target = Data(:,2);
% 
% NodeIndex = TreeClass.RandConfig(data,[],1);
% % if numel(data.Visits)<info.iteration
% %     NodeIndex = TreeClass.RandConfig(data,[],numel(data.Visits));
% % else
% %     NodeIndex = TreeClass.RandConfig(data,[],info.iteration);
% % end
% RootConfigs = GetVariablesFromDs(ds,[],sort(NodeIndex),FileIndex);
% 
% 
% end
