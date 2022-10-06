function [OriginalConfigList, ConfigsInOtherFile] = UpdatFileCost(ds,ConfigInfo,OriginalConfigList)
ConfigsInOtherFile = [];
if istable(ds)
    ds.Cost(ConfigInfo(3)) = ds.Cost(ConfigInfo(3)) + ConfigInfo(4);
    ds.Level(ConfigInfo(3)) = ds.Level(ConfigInfo(3)) + ConfigInfo(5);
    NewList = ds.Childs{ConfigInfo(3)};
    NewList = [NewList, repmat(ConfigInfo(4:5),[size(NewList,1),1])];

    if isempty(NewList)
        return
    end
    try
    [Exist, Loc] = ismember(OriginalConfigList(:,1:3),NewList(:,1:3),"rows");
    catch
        d=6
    end
    if any(Exist)
        NewList(Loc(Exist),4:5) = NewList(Loc(Exist),4:5) + OriginalConfigList(Exist,4:5);
        OriginalConfigList(Exist,:) = [];
    end
    
    LocConfigInFile = NewList(:,1)==ConfigInfo(1) & NewList(:,2)==ConfigInfo(2);
    FilteredList = NewList(LocConfigInFile,:);
    ConfigsInOtherFile =NewList(~LocConfigInFile);
    
    if isempty(FilteredList)
        return
    end

    for ii = 1:size(FilteredList,1)
        if(FilteredList(ii,1)==StartConfigSizes(1) && FilteredList(ii,2)==StartConfigSizes(2))
            [OriginalConfigList, ConfigInOtherFile] = ScanTree(ds,FilteredList(ii,:),OriginalConfigList);
            ConfigsInOtherFile = [ConfigsInOtherFile; ConfigInOtherFile];
        end
    end
end

% FileName = "size_"+string(StartConfigSizes(1))+"_"+ string(StartConfigSizes(2)+".mat");
% FileExist = contains(ds.Files,FileName);
% 
% File = matfile(ds.Files{FileExist},"Writable",true);
% ConfigData = File.FileData(StartIndex,:);



end

