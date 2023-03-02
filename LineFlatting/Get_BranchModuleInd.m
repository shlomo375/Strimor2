function [StraightLineModulesInd, Step] = Get_BranchModuleInd(WS,GroupInd,StartModule,Line,Dir)

ScannedAgent = ~WS.Space.Status;

ScannedAgent(cat(1,GroupInd{Line-1}{:})) = true;
[~, StraightLineModulesInd] = ScanningAgentsFast(WS, ScannedAgent, StartModule,true);


%% compute steps
if Line >=3
    ScannedAgent = ~WS.Space.Status;
    ScannedAgent(cat(1,GroupInd{Line-2}{:})) = true;
    ScannedAgent(cat(1,GroupInd{Line}{:})) = true;
    ScannedAgent(StraightLineModulesInd) = false;

    [~, BaseModulesInd] = ScanningAgentsFast(WS, ScannedAgent, StartModule,true);
    BaseModulesInd(ismember(BaseModulesInd,StraightLineModulesInd)) = [];
else
    BaseModulesInd = GroupInd{1}{1};
end
BaseModulesIndType = WS.Space.Type(BaseModulesInd);
[~,BaseModuleEdgeLocCol] = ind2sub(WS.SpaceSize,BaseModulesInd);

TopLineModulesInd = StraightLineModulesInd(ismember(StraightLineModulesInd,cat(1,GroupInd{Line}{:})));
TopLineModulesType = WS.Space.Type(TopLineModulesInd);
[~,MovingModuleEdgeLocCol] = ind2sub(WS.SpaceSize,TopLineModulesInd);
    
if Dir == 1
    Step = (max(BaseModuleEdgeLocCol(BaseModulesIndType==-1)) - min(MovingModuleEdgeLocCol(TopLineModulesType==1)))/2;
else
    Step = (min(BaseModuleEdgeLocCol(BaseModulesIndType==-1)) - max(MovingModuleEdgeLocCol(TopLineModulesType==1)))/2;
end

end
