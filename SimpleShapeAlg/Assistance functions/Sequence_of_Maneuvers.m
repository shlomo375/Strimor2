function [NewWS, Newtree, NewParentInd] = Sequence_of_Maneuvers(WS,tree,ParentInd,AllModuleInd,Moving_Log,Axis,Step)

arguments
    WS
    tree
    ParentInd (1,1) {mustBeInteger,mustBeNonnegative}
    AllModuleInd {mustBeVector}
    Moving_Log (:,:) {mustBeNumericOrLogical}
    Axis {mustBeInteger,mustBePositive,mustBeVector}
    Step {mustBeInteger,mustBeVector}
end

NewWS = WS;
Newtree = tree;
NewParentInd = ParentInd;

for Maneuver_ind = 1:length(Axis)
    [OK, NewWS, Newtree, NewParentInd, AllModuleInd(Moving_Log(1,:))] =...
                ManeuverStepProcess(NewWS, Newtree, NewParentInd, ...
                    AllModuleInd(Moving_Log(Maneuver_ind,:)), Axis(Maneuver_ind), Step(Maneuver_ind));
            
    if ~ OK
        fprintf("Maneuver num %d faild, enter to puse mode",Maneuver_ind);
        pause
        break
    end
end


end
