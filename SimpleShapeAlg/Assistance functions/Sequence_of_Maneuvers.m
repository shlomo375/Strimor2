function [NewWS, Newtree, NewParentInd, OK] = Sequence_of_Maneuvers(WS,tree,ParentInd,AllModuleInd,Moving_Log,Axis,Step,ConfigShifts,P)

arguments
    WS
    tree
    ParentInd (1,1) {mustBeInteger,mustBeNonnegative}
    AllModuleInd {mustBeVector}
    Moving_Log (:,:) {mustBeNumericOrLogical}
    Axis {mustBeInteger,mustBePositive,mustBeVector}
    Step {mustBeInteger,mustBeVector}
    ConfigShifts (2,1) {mustBeInteger,mustBeVector} = false;
    P.Plot (1,1) {mustBeNumericOrLogical} = false;
    
end

NewWS = WS;
Newtree = tree;
NewParentInd = ParentInd;

for Maneuver_ind = 1:length(Axis)
%     if Maneuver_ind==6
%         d=5
%     end
    [OK, NewWS, Newtree, NewParentInd, AllModuleInd(Moving_Log(Maneuver_ind,:))] =...
                ManeuverStepProcess(NewWS, Newtree, NewParentInd, ...
                    AllModuleInd(Moving_Log(Maneuver_ind,:)), Axis(Maneuver_ind), Step(Maneuver_ind));
    
    if any(ConfigShifts)
        Newtree.Data{NewParentInd,"IsomorphismMatrices1"}{1} = AddConfigShifts(Newtree.Data{NewParentInd,"IsomorphismMatrices1"}{1}, ConfigShifts);
    end


    if ~ OK
        fprintf("Maneuver num %d faild, enter to puse mode",Maneuver_ind);
        pause
        break
    end
    if P.Plot

        % get the root object
        rootObj = groot;
        
        % get the positions of all monitors
        monitorPositions = rootObj.MonitorPositions;
        
        % check if there is more than one monitor
        if size(monitorPositions, 1) > 1
            figure("Position",[-1914 572 560 420]);
        else
            figure("Position",[1 50 560 420]);
        end
        
        PlotWorkSpace(NewWS,"Plot_CellInd",false);
        NewWS.Space.Status(NewWS.Space.Status==NewWS.MovmentColorIdx) = 1; 
    end
end


end