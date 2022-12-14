function WorkerList = Taskmaster(WorkerList,Folders, info)
Name = extractBetween(Folders,"N\","\tree","Boundaries","exclusive");
% Name = extractBetween(Folders,"Results\","\","Boundaries","exclusive");



for ii = 1:numel(WorkerList)
    
    FolderName = Folders(ii);
%     ExpendTree(FolderName, info)
    switch Name(ii)
        case "OneTree"
                    WorkerList(ii) = parfeval(@ExpendTree,5,FolderName, info);
%             ExpendTree(FolderName, info);
        case "OneTree_IM3Axis"
            WorkerList(ii) = parfeval(@ExpendTree,5,FolderName, info);
    
        case "TwoTree"
            %                 Expend2Tree(FolderName, info);
            
            info.RowNumData.function = "";
%             Expend2Tree(FolderName, info);
%             WorkerList(ii) = parfeval(@Expend2Tree,5,FolderName, info);
        otherwise
            info.RowNumData.function = extractBefore(Name(ii),"_"); 
            info.RowNumData.parameter = double(extractAfter(Name(ii),"__"));
            if isnan(info.RowNumData.parameter)
                info.RowNumData.parameter = double(extractAfter(Name(ii),"_"));
            end
            WorkerList(ii) = parfeval(@Expend2Tree,5,FolderName, info);
%             Expend2Tree(FolderName, info)
    end
end
WorkerList(matches({WorkerList.State},'unavailable')) = [];
end

