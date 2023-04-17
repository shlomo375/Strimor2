function Module_Task_Allocation(WS,StartConfig, TargetConfig, ConfigShift,Up_Down, Line)

[AlphaDiff, BetaDiff] = GetGroupConfigDiff(StartConfig,TargetConfig);

[GroupsSizes,GroupIndexes,GroupsInds] = GetConfigGroupSizes(WS, ConfigShift(:,1));
Edges = Get_GroupEdges(GroupsSizes,GroupIndexes,GroupsInds);

Tbl = CreatTaskAllocationTable;



end





