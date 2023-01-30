function [OK, WS,tree,ParentInd] = Unify_NC_AlphaOrBeta_VS_AlphaOrBeta_NC(WS,tree,ParentInd, PairLoc,Axis, GroupIndexes, GroupInd, ScannedAgent)

%%
switch Axis
    case 2
        R = WS.R2;
        Axis = [2;1;2];
        Step = [1,0,-1];
        
        if numel(GroupInd{2}{PairLoc}) ~= 1
            LeftGroupRightInd =  GroupInd{2}{PairLoc}(end);
            [Row,~] = find(R == LeftGroupRightInd,1);
            GroupFrontLineInd = R(Row,:);
            GroupFrontLineInd(GroupFrontLineInd==0) =[];
            GroupFrontLineInd(WS.Space.Status(GroupFrontLineInd)==0) = [];
        
        else
            
            AllModuleInd = find(WS.Space.Status,tree.N);
            GroupFrontLineInd = FindModuleReletiveToMotionAxis(R,GroupInd{2}{PairLoc}(1),AllModuleInd,false,true);
        end

        LeftGroupRightCol =  GroupIndexes{2}{PairLoc}(end);
        RightGroupLeftCol = GroupIndexes{2}{PairLoc+1}(1)-1;

        Step(2) = (LeftGroupRightCol-RightGroupLeftCol)/2;
        
        [~, BranchInd] = ScanningAgentsFast(WS, ScannedAgent, GroupInd{2}{PairLoc+1}(1));

    case 3
        R = WS.R3;
        Axis = [3;1;3];
        Step = [-1,0,1];
        
        if numel(GroupInd{2}{PairLoc+1}) ~= 1
            RightGroupLeftInd =  GroupInd{2}{PairLoc+1}(1);
            [Row,~] = find(R == RightGroupLeftInd,1);
            GroupFrontLineInd = R(Row,:);
            GroupFrontLineInd(GroupFrontLineInd==0) =[];
            GroupFrontLineInd(WS.Space.Status(GroupFrontLineInd)==0) = [];
        else
%             Axis = [2;1;2];
            AllModuleInd = find(WS.Space.Status,tree.N);
            [GroupFrontLineInd] = FindModuleReletiveToMotionAxis(R,GroupInd{2}{PairLoc+1}(1),AllModuleInd,true,true);
        end

        RightGroupLeftCol =  GroupIndexes{2}{PairLoc+1}(1);
        LeftGroupRightCol = GroupIndexes{2}{PairLoc}(end)+1;

        Step(2) = (RightGroupLeftCol-LeftGroupRightCol)/2;
        
        [~, BranchInd] = ScanningAgentsFast(WS, ScannedAgent, GroupInd{2}{PairLoc}(end));


end


% figure(1)
% PlotWorkSpace(WS,[],[]);
%% a) The right pair of modules in the left group is moved down a row.
    
%MovingModule = LeftBranchInd;

[OK, NewWS, Newtree, NewParentInd, GroupFrontLineInd] =...
    ManeuverStepProcess(WS,tree,ParentInd,GroupFrontLineInd, Axis(1), Step(1));

if ~ OK
    return
end
% figure(2)
% PlotWorkSpace(NewWS,[],[]);
%% b) Right group will move all the way to the left.



% [~, RightBranchInd] = ScanningAgents(WS, ScannedAgent, GroupInd{2}{PairLoc+1 - FlipOver}(1), []);

[OK, NewWS, Newtree, NewParentInd] =...
    ManeuverStepProcess(NewWS,Newtree,NewParentInd,BranchInd, Axis(2), Step(2));

if ~ OK
    return
end
% figure(3)
% PlotWorkSpace(NewWS,[],[]);
%% c) The pair of modules will raise a row back.

% Axis = 2;
% Step = -1;
[OK, NewWS, Newtree, NewParentInd] =...
    ManeuverStepProcess(NewWS,Newtree,NewParentInd,GroupFrontLineInd, Axis(3), Step(3));

if ~ OK
    return
end

% figure(4)
% PlotWorkSpace(NewWS,[],[]);

WS = NewWS;
tree = Newtree;
ParentInd = NewParentInd;

 
end
