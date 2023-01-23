function [OK, WS,tree,ParentInd] = Unify_NC_AlphaOrBeta_VS_AlphaOrBeta_NC(WS,tree,ParentInd, PairLoc,Axis, GroupIndexes, GroupInd, ScannedAgent)

%%
switch Axis
    case 2
        R = WS.R2;
        Axis = [2;1;2];
        Step = [1,0,-1];
        
        FlipOver = 0;
    case 3
        R = WS.R3;
        Axis = [3;1;3];
        Step = [-1,0,1];

        FlipOver = 1;

end
LeftGroupRightInd =  GroupInd{2}{PairLoc + FlipOver}(end);
[Row,~] = find(R == LeftGroupRightInd,1);
LeftGroupFrontLineInd = R(Row,:);
LeftGroupFrontLineInd(LeftGroupFrontLineInd==0) =[];
LeftGroupFrontLineInd(WS.Space.Status(LeftGroupFrontLineInd)==0) = [];

% figure(1)
% PlotWorkSpace(WS,[],[]);
% a) The right pair of modules in the left group is moved down a row.
    
%MovingModule = LeftBranchInd;

[OK, NewWS, Newtree, NewParentInd, LeftGroupFrontLineInd] =...
    ManeuverStepProcess(WS,tree,ParentInd,LeftGroupFrontLineInd, Axis(1), Step(1));

if ~ OK
    return
end
% figure(2)
% PlotWorkSpace(NewWS,[],[]);
% b) Right group will move all the way to the left.

LeftGroupRightCol =  GroupIndexes{2}{PairLoc + FlipOver}(end);
RightGroupLeftCol = GroupIndexes{2}{PairLoc+1 - FlipOver}(1)-1;


Step(2) = (LeftGroupRightCol-RightGroupLeftCol)/2;

% [~, RightBranchInd] = ScanningAgents(WS, ScannedAgent, GroupInd{2}{PairLoc+1 - FlipOver}(1), []);
[~, RightBranchInd] = ScanningAgentsFast(WS, ScannedAgent, GroupInd{2}{PairLoc+1 - FlipOver}(1));

[OK, NewWS, Newtree, NewParentInd, RightBranchInd] =...
    ManeuverStepProcess(NewWS,Newtree,NewParentInd,RightBranchInd, Axis(2), Step(2));

if ~ OK
    return
end
% figure(3)
% PlotWorkSpace(NewWS,[],[]);
% c) The pair of modules will raise a row back.

% Axis = 2;
% Step = -1;
[OK, NewWS, Newtree, NewParentInd, LeftGroupFrontLineInd] =...
    ManeuverStepProcess(NewWS,Newtree,NewParentInd,LeftGroupFrontLineInd, Axis(3), Step(3));

if ~ OK
    return
end

% figure(4)
% PlotWorkSpace(NewWS,[],[]);

WS = NewWS;
tree = Newtree;
ParentInd = NewParentInd;

 
end
