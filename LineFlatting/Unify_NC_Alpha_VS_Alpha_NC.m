function [OK, WS,tree,ParentInd] = Unify_NC_Alpha_VS_Alpha_NC(WS,tree,ParentInd, GroupsPairLoc, GroupsEdges,GroupIndexes, GroupInd, ScannedAgent)
AllModuleInd = find(WS.Space.Status,tree.N);

Case = sum(GroupsEdges.*[2,1])-1;
if Case == -1
    BetaInRightGroup = length(GroupInd{2}{GroupsPairLoc}) <= length(GroupInd{2}{GroupsPairLoc+1});
    if BetaInRightGroup
        Case = 1; %the half is on the right
    else
        Case = 0; %the half is on the left
    end
end

[OK, WS,tree,ParentInd] = UnificationManeuver(WS,tree,ParentInd, GroupsPairLoc, Case,GroupIndexes, GroupInd, ScannedAgent,AllModuleInd);
if ~OK && ~sum(GroupsEdges.*[2,1])
    [OK, WS,tree,ParentInd] = UnificationManeuver(WS,tree,ParentInd, GroupsPairLoc, ~Case,GroupIndexes, GroupInd, ScannedAgent,AllModuleInd);
end

end

function [OK, WS,tree,ParentInd] = UnificationManeuver(WS,tree,ParentInd, GroupsPairLoc, Case,GroupIndexes, GroupInd, ScannedAgent,AllModuleInd)
switch Case
    case 0 %the half is on the left
        AboveModule = true;
        MovingHalfInd = FindModuleReletiveToMotionAxis(WS.R2,GroupInd{2}{GroupsPairLoc}(end),AllModuleInd,AboveModule);
%         OuterBranch = GroupInd{2}{GroupsPairLoc}(1);

        OuterBranch = FindModuleBranch(WS, GroupInd{2}{GroupsPairLoc}(1), GroupInd{2}{GroupsPairLoc}(2:end));
        HorizenStep = (GroupIndexes{2}{GroupsPairLoc}(1)+1 - GroupIndexes{2}{GroupsPairLoc+1}(1))/2 +1;
%         [~, BranchInd] = ScanningAgents(WS, ScannedAgent, GroupInd{2}{GroupsPairLoc +1}(1), []);
        [~, BranchInd] = ScanningAgentsFast(WS, ScannedAgent, GroupInd{2}{GroupsPairLoc +1}(1),true);
        BranchIndInMovingHalf = ismember(MovingHalfInd,BranchInd);

        Axis = [2 ,     1     , 3,      1     ,2];
        Step = [-1,HorizenStep, 1,length(GroupIndexes{2}{GroupsPairLoc})/2-1,1];
%         try
%             Onlyfortesting
%         catch e
%             e
%             fprintf("Unify_NC_Alpha_VS_Alpha_NC");
%         end
    case 1 %the half is on the right
        AboveModule = true;
        MovingHalfInd = FindModuleReletiveToMotionAxis(WS.R3,GroupInd{2}{GroupsPairLoc+1}(1),AllModuleInd,AboveModule);
%         OuterBranch = GroupInd{2}{GroupsPairLoc+1}(end);

        OuterBranch = FindModuleBranch(WS, GroupInd{2}{GroupsPairLoc+1}(end), GroupInd{2}{GroupsPairLoc+1}(1:end-1));
        HorizenStep = (GroupIndexes{2}{GroupsPairLoc+1}(end)- GroupIndexes{2}{GroupsPairLoc}(end)-1)/2 -1; %length(GroupInd{2}{GroupsPairLoc})/2 -1;
%         [~, BranchInd] = ScanningAgents(WS, ScannedAgent, GroupInd{2}{GroupsPairLoc}(1), []);
        [~, BranchInd] = ScanningAgentsFast(WS, ScannedAgent, GroupInd{2}{GroupsPairLoc}(1),true);
        BranchIndInMovingHalf = ismember(MovingHalfInd,BranchInd);

        Axis = [ 3,     1     , 2,      1     ,3];
        Step = [ 1,HorizenStep, -1,-((length(GroupIndexes{2}{GroupsPairLoc+1})/2)-1),-1];
    case 2
        OK = false;
        return
end
% figure(1)
% PlotWorkSpace(WS,[]);

%%


%   A) move up by row  the Half of Module with the big group

[OK, NewWS, Newtree, NewParentInd, MovingHalfInd] =...
    ManeuverStepProcess(WS,tree,ParentInd,MovingHalfInd, Axis(1), Step(1));

if ~ OK
    return
end
% figure(2)
% PlotWorkSpace(NewWS,[]);

%%



%   b) Moving the large group in axis 1 towards the edge of the small group
if Step(2)
    [OK, NewWS, Newtree, NewParentInd, MovingHalfInd(BranchIndInMovingHalf)] =...
        ManeuverStepProcess(NewWS,Newtree,NewParentInd,MovingHalfInd(BranchIndInMovingHalf), Axis(2), Step(2));
    
    if ~ OK
        return
    end
%     figure(3)
%     PlotWorkSpace(NewWS,[]);
end

%%


%   c) Raising the extreme beta module in the small group one line
[OK, NewWS, Newtree, NewParentInd, OuterBranch] =...
    ManeuverStepProcess(NewWS,Newtree,NewParentInd,OuterBranch, Axis(3), Step(3));

if ~ OK
    return
end
% figure(4)
% PlotWorkSpace(NewWS,[]);

%%


%   d) Returning the large group the number of steps from section b.
if Step(4)
    [OK, NewWS, Newtree, NewParentInd, TempInd] =...
        ManeuverStepProcess(NewWS,Newtree,NewParentInd,[OuterBranch;MovingHalfInd(BranchIndInMovingHalf)], Axis(4), Step(4));
    OuterBranch = TempInd(1);
    MovingHalfInd(BranchIndInMovingHalf) = TempInd(2:end);
    
    if ~ OK
        return
    end
%     figure(5)
%     PlotWorkSpace(NewWS,[]);
end

%%



%   e) Lowering the half line one line down

[OK, NewWS, Newtree, NewParentInd] =...
    ManeuverStepProcess(NewWS,Newtree,NewParentInd,[OuterBranch;MovingHalfInd], Axis(5), Step(5));

if ~ OK
    return
end
% figure(6)
% PlotWorkSpace(NewWS,[]);

%%




WS = NewWS;
tree = Newtree;
ParentInd = NewParentInd;

end
