function WorkerList = Taskmaster(WorkerList,Folders, info)
% Name = extractBetween(Folders,"N\","\tree","Boundaries","exclusive");
% Name = extractBetween(Folders,"Results\","\","Boundaries","exclusive");



for ii = 1:numel(WorkerList)
    
    FolderName = Folders(ii);
    info.RowNumData.function = "uniform";
    info.RowNumData.parameter = 3;
    WorkerList(ii) = parfeval(@Expend2Tree,5,FolderName, info);
%             Expend2Tree(FolderName, info)
  
end
WorkerList(matches({WorkerList.State},'unavailable')) = [];
end

