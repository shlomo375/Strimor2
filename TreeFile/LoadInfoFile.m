function [FileName, VisitsAvg, Cost2TargetAvg] = LoadInfoFile(ds)

InfoLoc = contains(ds.Files,"Info");
load(string(ds.Files(InfoLoc)),"info");
FileName = info{:,1};
VisitsAvg = info{:,2};
Cost2TargetAvg = info{:,3};

end



