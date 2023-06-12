function [Start_WS,Tree, ParentInd,ConfigShift] = MatchingStage(Start_WS,Target_WS,Tree, ParentInd,ConfigShift,Plot)

[GroupsSizes,GroupIndexes,GroupsInds] = GetConfigGroupSizes(Target_WS, ConfigShift(:,2),1);
Target_Edges = Get_GroupEdges(GroupsSizes,GroupIndexes,GroupsInds);
% [Step, Axis] = ArangeGroupLocations("Left",Target_Edges);
TargetReletivePosition = GroupsReletivePosition(Target_Edges);

[GroupsSizes,GroupIndexes,GroupsInds] = GetConfigGroupSizes(Start_WS, ConfigShift(:,1),1);
Start_Edges = Get_GroupEdges(GroupsSizes,GroupIndexes,GroupsInds);
Step = GroupsReletivePosition(Start_Edges,TargetReletivePosition);

Moving_Log = false(numel(Step),Tree.N);
AllModuleInd = [];
GroupStartInd = 1;
for Line = 1:numel(Step)
    if GroupsSizes(Line)
        AllModuleInd = [AllModuleInd, GroupsInds{Line}{1}];
        Moving_Log(Line,(GroupStartInd):end) = true;
        GroupStartInd = GroupStartInd + abs(GroupsSizes(Line));
    end
end

Delete_Loc = ~Step;
Step(Delete_Loc) = [];
Moving_Log(Delete_Loc,:) = [];
Axis = ones(size(Step));

[Start_WS, Tree, ParentInd] = Sequence_of_Maneuvers(Start_WS,Tree,ParentInd,AllModuleInd,Moving_Log,Axis,Step,ConfigShift(:,1),"Plot",Plot);
end


function [Step] = GroupsReletivePosition(Edges,Displacement_Reqierd)

arguments 
    Edges
    Displacement_Reqierd = false;
end

Displacment = zeros(1,size(Edges,3));
for Line = size(Edges,3):-1:2
    if Edges(1,1,Line-1) && Edges(1,1,Line)
            Displacment(Line) = floor((Edges(2,1,Line))) - (Edges(2,1,Line-1));
    end
end


if numel(Displacement_Reqierd) > 1
    Step = (Displacement_Reqierd - Displacment)/2; 
    Step = ceil(abs(Step)).* sign(Step);
else
    Step = Displacment;
end

end

