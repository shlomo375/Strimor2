function [OK, WS,tree,ParentInd] = Unify_NC_Beta_VS_Beta_NC(WS,tree,ParentInd, GroupsPairLoc, GroupsEdges,Axis, GroupIndexes, GroupInd, ScannedAgent)
AllModuleInd = find(WS.Space.Status,tree.N);


Case = sum(GroupsEdges.*[2,1]);
if Case == 3
    if GroupsPairLoc == 1
        Case = 2;
    else
        AlphaInRightGroup = length(GroupInd{2}{GroupsPairLoc}) >= length(GroupInd{2}{GroupsPairLoc+1});
        if AlphaInRightGroup
            Case = 1;
            if length(GroupIndexes{2}) > 2
                if abs(GroupIndexes{2}{GroupsPairLoc+2}(1) - GroupIndexes{2}{GroupsPairLoc+1}(end)) < 3
                    Case = 2;
                    if abs(GroupIndexes{2}{GroupsPairLoc}(1) - GroupIndexes{2}{GroupsPairLoc-1}(end)) < 3
                        OK = false;
                        return
                    end   
                end
            end
        else
            Case = 2;
            if length(GroupIndexes{2}) > 2
                if abs(GroupIndexes{2}{GroupsPairLoc-1}(end) - GroupIndexes{2}{GroupsPairLo1}(1)) < 3
                    Case = 1;
                    if abs(GroupIndexes{2}{GroupsPairLoc+1}(1) - GroupIndexes{2}{GroupsPairLoc}(end)) < 3
                        OK = false;
                        return
                    end   
                end
            end
        end
    end
end

switch Case
    case 1 %the half is on the Right, the beta will transfer to the left group
        AboveModule = true;
        IncludeOrigin = true;
        MovingHalfInd = FindModuleReletiveToMotionAxis(WS.R2,GroupInd{2}{GroupsPairLoc+1}(end),AllModuleInd,AboveModule,IncludeOrigin);
        InnerBeta = GroupInd{2}{GroupsPairLoc}(end);
        ForwardHorizenStep = (GroupIndexes{2}{GroupsPairLoc+1}(end) - GroupIndexes{2}{GroupsPairLoc}(end) + 1)/2;
        BackwardHorizenStep = -sign(ForwardHorizenStep).*length(GroupIndexes{2}{GroupsPairLoc+1})/2;
%         [~, BranchInd] = ScanningAgents(WS, ScannedAgent, GroupInd{2}{GroupsPairLoc +1}(1), []);
        [~, BranchInd] = ScanningAgentsFast(WS, ScannedAgent, InnerBeta,true);
%         BranchIndInMovingHalf = ismember(MovingHalfInd,BranchInd);
        InnerBetaLocInBranch = (BranchInd == InnerBeta);

        Axis = [2 ,     1     ,       2,      1     ,       2];
        Step = [1,ForwardHorizenStep, 1,BackwardHorizenStep,-1];
    case 2 %the half is on the Left, the beta will transfer to the Right group
        AboveModule = true;
        IncludeOrigin = true;
        MovingHalfInd = FindModuleReletiveToMotionAxis(WS.R3,GroupInd{2}{GroupsPairLoc}(end),AllModuleInd,AboveModule,IncludeOrigin);
        try
        InnerBeta = GroupInd{2}{GroupsPairLoc+1}(1);
        catch Ubb
            Ubb
        end
        ForwardHorizenStep = -(GroupIndexes{2}{GroupsPairLoc+1}(1) - GroupIndexes{2}{GroupsPairLoc}(1) + 1)/2;
        BackwardHorizenStep = -sign(ForwardHorizenStep).*length(GroupIndexes{2}{GroupsPairLoc})/2;
%         [~, BranchInd] = ScanningAgents(WS, ScannedAgent, GroupInd{2}{GroupsPairLoc +1}(1), []);
        [~, BranchInd] = ScanningAgentsFast(WS, ScannedAgent, InnerBeta,true);
        InnerBetaLocInBranch = (BranchInd == InnerBeta);
        Axis = [3 ,     1     ,       3,      1     ,       3];
        Step = [-1,ForwardHorizenStep, -1,BackwardHorizenStep,1];
    case 3
        OK = false;
        return
end
% figure(1)
% PlotWorkSpace(WS,[]);
%%
%%   a) Lowering the half containing a group with an alpha module at the end
    
[OK, NewWS, Newtree, NewParentInd, MovingHalfInd] =...
    ManeuverStepProcess(WS,tree,ParentInd,MovingHalfInd, Axis(1), Step(1));

if ~ OK
    return
end
% figure(2)
% PlotWorkSpace(NewWS,[]);
%%   b) Moving the second group along the X axis towards the first group
[OK, NewWS, Newtree, NewParentInd, BranchInd] =...
        ManeuverStepProcess(NewWS,Newtree,NewParentInd,BranchInd, Axis(2), Step(2));
    
if ~ OK
    return
end
% figure(3)
% PlotWorkSpace(NewWS,[]);
%%   c) Downloading the front beta module in the second group

[OK, NewWS, Newtree, NewParentInd, BranchInd(InnerBetaLocInBranch)] =...
        ManeuverStepProcess(NewWS,Newtree,NewParentInd,BranchInd(InnerBetaLocInBranch), Axis(3), Step(3));
    
if ~ OK
    return
end
% figure(4)
% PlotWorkSpace(NewWS,[]);

InnerBeta = BranchInd(InnerBetaLocInBranch);
BranchInd(InnerBetaLocInBranch) = [];
%%   d) The return of the second group to the semi-final was initially

[OK, NewWS, Newtree, NewParentInd] =...
        ManeuverStepProcess(NewWS,Newtree,NewParentInd,BranchInd, Axis(4), Step(4));
    
if ~ OK
    return
end
% figure(5)
% PlotWorkSpace(NewWS,[]);
%%   e) Raising the lowered half back

[OK, NewWS, Newtree, NewParentInd] =...
        ManeuverStepProcess(NewWS,Newtree,NewParentInd,[MovingHalfInd;InnerBeta], Axis(5), Step(5));
    
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
