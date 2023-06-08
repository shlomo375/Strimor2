function ModuleTransitionData = TransferModuleToLine(WS, ConfigShift,ModuleType,DestenationLine,Downwards)
[GroupsSizes,GroupIndexes,GroupsInds] = GetConfigGroupSizes(WS, ConfigShift,Downwards);
Edges = Get_GroupEdges(GroupsSizes,GroupIndexes,GroupsInds);
if ~Downwards
    DestenationLine = numel(Edges)-DestenationLine+1;
end
LineSequence = DestenationLine:numel(Edges);
% if  Downwards
%     LineSequence = DestenationLine:numel(Edges);
% else
%     LineSequence = DestenationLine:-1:1;
% end
for Line = LineSequence
    if Edges{Line,1}(3,1) == -ModuleType
        Direction = "Left";
        break
    elseif Edges{Line,1}(3,2) == -ModuleType
        Direction = "Right";
        break
    end
end

ModuleTransitionData = CreatTaskAllocationTable([],"Current_Line",Line,"Side",Direction,"DestenationLine",DestenationLine,"Module_Num",1,"Type",ModuleType,"Downwards",Downwards);

end
