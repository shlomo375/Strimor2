function [WS,Tree, ParentInd] = Expend(WS,Tree, ParentInd, SpreadingDir)
arguments
    WS
    Tree
    ParentInd
    SpreadingDir (1,1) {mustBeTextScalar,matches(SpreadingDir,["Left","Right","Left_Right","Right_Left"])};
end
if contains(SpreadingDir,"_")
    SpreadingDir = extractAfter(SpreadingDir,"_");
end
Previous_WorkZoneInd = [];
[GroupsSizes,GroupIndexes,GroupsInds] = ConfigGroupSizes(WS.Space.Status,WS.Space.Type,WS.R1);

if matches(SpreadingDir,"Left")
    BranchesIn2thRow = numel(GroupsInds{2}):-1:1;
else
    BranchesIn2thRow = 1:numel(GroupsInds{2});
end

for GroupNum = BranchesIn2thRow
    
    StartModule = GroupsInds{2}{GroupNum}(1);
    BranchModulesInd = Get_BranchModuleInd(WS,GroupsInds,StartModule,2,"BRANCH");

    WorkZoneInd = Get_WorkZone(WS,BranchModulesInd); 

    [StepApproved, New_WorkZoneInd,StepUnit] = WorkZoneCollistion(WS,GroupsInds,GroupsInds{2}{GroupNum},WorkZoneInd,Previous_WorkZoneInd,SpreadingDir);
    
    [OK, WS, Tree, ParentInd, BranchModulesInd] =...
                    ManeuverStepProcess(WS,Tree,ParentInd,BranchModulesInd, 1, StepApproved);
    New_StepApproved = StepApproved;
    while ~OK && StepUnit
        New_StepApproved = New_StepApproved-StepUnit;
        [OK, WS, Tree, ParentInd, BranchModulesInd] =...
                    ManeuverStepProcess(WS,Tree,ParentInd,BranchModulesInd, 1, New_StepApproved);

    end

    Previous_WorkZoneInd = UpdateLinearIndex(WS.SpaceSize,New_WorkZoneInd,1,New_StepApproved-StepApproved);
end
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [StepApproved, WorkZoneInd,StepUnit] = WorkZoneCollistion(WS,GroupsInds,GroupModulesInd,WorkZoneInd,Previous_WorkZoneInd,SpreadingDir)
StepUnit = 0;
if isempty(Previous_WorkZoneInd)
    if matches(SpreadingDir,"Left")
        [~,BaseEdgeCol] = ind2sub(WS.SpaceSize,max(GroupsInds{1}{1}));
        [~,GroupEdgeCol] = ind2sub(WS.SpaceSize,max(GroupModulesInd));

        BaseEdgeType = WS.Space.Type(max(GroupsInds{1}{1}));
        GroupEdgeType = WS.Space.Type(max(GroupModulesInd));

        StepApproved = ((BaseEdgeCol-(BaseEdgeType>0))-(GroupEdgeCol-(GroupEdgeType<0)))/2 ;%-1;
    else

        [~,BaseEdgeCol] = ind2sub(WS.SpaceSize,min(GroupsInds{1}{1}));
        [~,GroupEdgeCol] = ind2sub(WS.SpaceSize,min(GroupModulesInd));

        BaseEdgeType = WS.Space.Type(min(GroupsInds{1}{1}));
        GroupEdgeType = WS.Space.Type(min(GroupModulesInd));

        StepApproved = (((BaseEdgeCol+(BaseEdgeType>0))-(GroupEdgeCol+(GroupEdgeType<0)))/2);% +1);
    end
    WorkZoneInd = UpdateLinearIndex(WS.SpaceSize,WorkZoneInd,1,StepApproved);
else
    if any(find(ismember(Previous_WorkZoneInd,WorkZoneInd),1))
        SpreadingDir = setdiff(["Right","Left"],SpreadingDir);
        ExistTerm = true;
        MovmentStatus = false;
    else
        ExistTerm = false;
        MovmentStatus = true;
    end
    
    StepApproved = 0;
    if matches(SpreadingDir,"Left")
        StepUnit = 1;
    else
        StepUnit = -1;
    end
    
    New_WorkZoneInd = WorkZoneInd;
    while MovmentStatus ~= ExistTerm
        StepApproved = StepApproved+StepUnit;
        
        New_WorkZoneInd = UpdateLinearIndex(WS.SpaceSize,New_WorkZoneInd,1,StepApproved);
        
        if any(find(ismember(Previous_WorkZoneInd,New_WorkZoneInd),1))
            MovmentStatus = false;
            StepApproved = StepApproved-StepUnit;
        else
            MovmentStatus = true;
        end
    end
    WorkZoneInd = New_WorkZoneInd;


end

end
