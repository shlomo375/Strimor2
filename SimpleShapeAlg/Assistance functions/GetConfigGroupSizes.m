function [GroupsSizes,GroupIndexes,GroupInd] = GetConfigGroupSizes(WS, ConfigShift, Downwards)
arguments
    WS
    ConfigShift
    Downwards = true;
end
[GroupsSizes,GroupIndexes,GroupInd] = ConfigGroupSizes_Axis1Only(WS.Space.Status,WS.Space.Type);

GroupsSizes =   [zeros([ConfigShift(1),size(GroupsSizes,[2,3])]);     GroupsSizes;   zeros([ConfigShift(2),size(GroupsSizes,[2,3])])];
GroupIndexes =  [cell(ConfigShift(1),size(GroupIndexes,2));     GroupIndexes;  cell(ConfigShift(2),size(GroupIndexes,2))];
GroupInd =      [cell(ConfigShift(1),size(GroupInd,2));         GroupInd;      cell(ConfigShift(2),size(GroupInd,2))];

if ~Downwards
    GroupsSizes = flip(-GroupsSizes);
    GroupIndexes = flip(GroupIndexes);
    GroupInd = flip(GroupInd);
end

end
