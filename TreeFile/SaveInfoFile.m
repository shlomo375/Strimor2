function SaveInfoFile(Folder, FileName,FileData)

try
    info = struct2cell(load(fullfile(Folder,"Info"),"info"));
    info = info{1};
catch e
    if matches(e.identifier,"MATLAB:load:couldNotReadFile")
        info = cell(1,3);
        info{1} = "0";
    end

end
VisitAvg = mean(FileData.Visits);
Cost2TargetAvg = mean(FileData.Cost2Target);
FileLocInInfo = matches([info{:,1}],FileName);

if any(FileLocInInfo)
    info(FileLocInInfo,2:3) = {VisitAvg, Cost2TargetAvg};
else
    if info{1}{:,1}=='0'
        info(1,:) = {FileName,VisitAvg, Cost2TargetAvg};
    else
        info(end+1,:) = {FileName,VisitAvg, Cost2TargetAvg};
    end
end

try
    save(fullfile(Folder,"Info"),"info");
catch e
end
end
