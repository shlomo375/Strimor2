function [MovingModuleInd,Axis] = FindModuleConnectedToEdgeToReduce(WS,EdgeInd,EdgeModuleType,BranchModuleInd,SpreadingDirection)

if matches(SpreadingDirection,"Right")
    Dir = 1;
    if EdgeModuleType == -1
        Axis = 3;
        R = WS.R3;
        AxisStep = 1;
    else
        Axis = 2;
        R = WS.R2;
        AxisStep = -1;
    end
else
    Dir = -1;
    if EdgeModuleType == -1
        Axis = 2;
        R = WS.R2;
        AxisStep = -1;
    else
        Axis = 3;
        R = WS.R3;
        AxisStep = 1;
    end
end

MovingModuleInd = FindModule(WS,R,Axis,AxisStep,Dir,EdgeInd,BranchModuleInd);
end


function MovingModuleInd = FindModule(WS,R,Axis,AxisStep,Dir,EdgeInd,BranchModuleInd)

AdjacentToEdgeModule = UpdateLinearIndex(WS.SpaceSize,EdgeInd,1,Dir*0.5);
FirstReduceModule = UpdateLinearIndex(WS.SpaceSize,AdjacentToEdgeModule,Axis,AxisStep);
if any(BranchModuleInd == FirstReduceModule)
    [Row,~] = find(R==EdgeInd,1);
    StaticModuleLine = R(Row,:);
    WS.Space.Status = zeros(WS.SpaceSize);
    WS.Space.Status(BranchModuleInd) = 1;
    ScannedAgent = ~WS.Space.Status;
    ScannedAgent(StaticModuleLine(StaticModuleLine>0)) = true;
    [~, MovingModuleInd] = ScanningAgentsFast(WS, ScannedAgent, FirstReduceModule,true);
else
   MovingModuleInd = [];
end

end