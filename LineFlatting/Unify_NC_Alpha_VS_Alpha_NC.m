function [OK, WS,tree,ParentInd] = Unify_NC_Alpha_VS_Alpha_NC(WS,tree,ParentInd, GroupsPairLoc, GroupsEdges,Axis, GroupIndexes, GroupInd, ScannedAgent)
AllModuleInd = find(WS.Space.Status,tree.N);

Case = sum(GroupsEdges.*[2,1]);
if ~Case
    BetaInRightGroup = length(GroupInd{2}{GroupsPairLoc}) <= length(GroupInd{2}{GroupsPairLoc+1});
    if BetaInRightGroup
        Case = 2; %the half is on the right
    else
        Case = 1; %the half is on the left
    end
end

switch Case
    case 1 %the half is on the left
        AboveModule = true;
        MovingHalfInd = FindModuleReletiveToMotionAxis(WS.R2,GroupInd{2}{GroupsPairLoc}(end),AllModuleInd,AboveModule);
        OuterBeta = GroupInd{2}{GroupsPairLoc}(1);
        HorizenStep = -length(GroupInd{2}{GroupsPairLoc+1})/2 -1;
%         [~, BranchInd] = ScanningAgents(WS, ScannedAgent, GroupInd{2}{GroupsPairLoc +1}(1), []);
        [~, BranchInd] = ScanningAgentsFast(WS, ScannedAgent, GroupInd{2}{GroupsPairLoc +1}(1));
        BranchIndInMovingHalf = ismember(MovingHalfInd,BranchInd);

        Axis = [2 ,     1     , 3,      1     ,2];
        Step = [-1,HorizenStep, 1,-HorizenStep,1];
    case 2 %the half is on the right
        AboveModule = true;
        MovingHalfInd = FindModuleReletiveToMotionAxis(WS.R3,GroupInd{2}{GroupsPairLoc+1}(1),AllModuleInd,AboveModule);
        OuterBeta = GroupInd{2}{GroupsPairLoc+1}(end);
        HorizenStep = length(GroupInd{2}{GroupsPairLoc})/2 -1;
%         [~, BranchInd] = ScanningAgents(WS, ScannedAgent, GroupInd{2}{GroupsPairLoc}(1), []);
        [~, BranchInd] = ScanningAgentsFast(WS, ScannedAgent, GroupInd{2}{GroupsPairLoc}(1));
        BranchIndInMovingHalf = ismember(MovingHalfInd,BranchInd);

        Axis = [3 ,     1     , 2,      1     ,3];
        Step = [1,HorizenStep, -1,-HorizenStep,-1];
    case 3
        OK = false;
        return
end
figure(1)
PlotWorkSpace(WS,[],[]);

%%


%   A) move up by row  the Half of Module with the big group

[OK, NewWS, Newtree, NewParentInd, MovingHalfInd] =...
    ManeuverStepProcess(WS,tree,ParentInd,MovingHalfInd, Axis(1), Step(1));

if ~ OK
    return
end
figure(2)
PlotWorkSpace(NewWS,[],[]);

%%



%   b) Moving the large group in axis 1 towards the edge of the small group
if HorizenStep
    [OK, NewWS, Newtree, NewParentInd, MovingHalfInd(BranchIndInMovingHalf)] =...
        ManeuverStepProcess(NewWS,Newtree,NewParentInd,MovingHalfInd(BranchIndInMovingHalf), Axis(2), Step(2));
    
    if ~ OK
        return
    end
    figure(3)
    PlotWorkSpace(NewWS,[],[]);
end

%%


%   c) Raising the extreme beta module in the small group one line
[OK, NewWS, Newtree, NewParentInd, OuterBeta] =...
    ManeuverStepProcess(NewWS,Newtree,NewParentInd,OuterBeta, Axis(3), Step(3));

if ~ OK
    return
end
figure(4)
PlotWorkSpace(NewWS,[],[]);

%%


%   d) Returning the large group the number of steps from section b.
if HorizenStep
    [OK, NewWS, Newtree, NewParentInd, TempInd] =...
        ManeuverStepProcess(NewWS,Newtree,NewParentInd,[OuterBeta;MovingHalfInd(BranchIndInMovingHalf)], Axis(4), Step(4));
    OuterBeta = TempInd(1);
    MovingHalfInd(BranchIndInMovingHalf) = TempInd(2:end);
    
    if ~ OK
        return
    end
    figure(5)
    PlotWorkSpace(NewWS,[],[]);
end

%%



%   e) Lowering the half line one line down

[OK, NewWS, Newtree, NewParentInd] =...
    ManeuverStepProcess(NewWS,Newtree,NewParentInd,[OuterBeta;MovingHalfInd], Axis(5), Step(5));

if ~ OK
    return
end
figure(6)
PlotWorkSpace(NewWS,[],[]);

%%




WS = NewWS;
tree = Newtree;
ParentInd = NewParentInd;

end