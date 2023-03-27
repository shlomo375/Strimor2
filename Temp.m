for i=1:1000
% [GroupsSizes,GroupIndexes,GroupInd] = ConfigGroupSizes(WS.Space.Status,WS.Space.Type,WS.R1);
% 
% GroupsSizes =   [zeros(ConfigShift(1),size(GroupsSizes,2));     GroupsSizes;   zeros(ConfigShift(2),size(GroupsSizes,2))];
% GroupIndexes =  [cell(ConfigShift(1),size(GroupIndexes',2));     GroupIndexes';  cell(ConfigShift(2),size(GroupIndexes',2))];
% GroupInd =      [cell(ConfigShift(1),size(GroupInd,2));         GroupInd;      cell(ConfigShift(2),size(GroupInd,2))];


[GroupsSizes2,GroupIndexes2,GroupInd2] = ConfigGroupSizes2(WS.Space.Status,WS.Space.Type,WS.R1);

GroupsSizes =   [zeros(ConfigShift(1),size(GroupsSizes,2));     GroupsSizes;   zeros(ConfigShift(2),size(GroupsSizes,2))];
GroupIndexes =  [cell(ConfigShift(1),size(GroupIndexes',2));     GroupIndexes';  cell(ConfigShift(2),size(GroupIndexes',2))];
GroupInd =      [cell(ConfigShift(1),size(GroupInd,2));         GroupInd;      cell(ConfigShift(2),size(GroupInd,2))];

end