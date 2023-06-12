function [WS,tree, ParentInd] = SwitchGroupSides(WS,tree, ParentInd)
% load("Switch.mat")
[GroupsSizes,GroupIndexes, GroupInd] = ConfigGroupSizes(WS.Space.Status,WS.Space.Type,WS.R1);

% Temp = 1:numel(BottomModuleInd);
if FirstIsAlpha(GroupsSizes(1,:))
    % Swapping occurs on the right side of a configuration
    TopModuleInd = GroupInd{2}{1};
    BottomModuleInd = flip(GroupInd{1}{1}(end-5:end));
    AllModuleInd = [BottomModuleInd; TopModuleInd];
    
    FirstStep = (GroupIndexes{1}{1}(end)-GroupIndexes{2}{1}(end)-4)/2;
    Steps = [FirstStep,-1,-1,-1,-1,1,-1,-1,1];
    Axis = [1,2,1,2,3,2,3,2,3];

else
    TopModuleInd = GroupInd{2}{1};
    BottomModuleInd = GroupInd{1}{1}(1:6);
    AllModuleInd = [BottomModuleInd; TopModuleInd];

    FirstStep = -(GroupIndexes{2}{1}(1)-GroupIndexes{1}{1}(1)-4)/2;
    Steps = [FirstStep,1,1,1,1,-1,1,1,-1];
    Axis = [1,3,1,3,2,3,2,3,2];
end
% figure(1)
% PlotWorkSpace(WS,[],[]);
%% swap group adges algorithm

% The six modules at the end of the bottom row are numbered from the end
% inward, 1,2,3,4,5,6.
%%
% 1) Moving the top row to the end with the beta module, 2 steps before the
% end of the row.

    [OK, NewWS, Newtree, NewParentInd, AllModuleInd(7)] =...
    ManeuverStepProcess(WS,tree,ParentInd,AllModuleInd(7), Axis(1), Steps(1));

    if ~ OK
        return
    end
% figure(2)
% PlotWorkSpace(NewWS,[],[]);
%%
% 2) uploading modules 1,2,3 from the bottom row.

    [OK, NewWS, Newtree, NewParentInd, AllModuleInd([1,2,3])] =...
    ManeuverStepProcess(NewWS, Newtree, NewParentInd,AllModuleInd([1,2,3]), Axis(2), Steps(2));

    if ~ OK
        return
    end
% figure(3)
% PlotWorkSpace(NewWS,[],[]);
%%
% 3) moving the top row one step in the other direction (top row + modules
% 1,2,3).

    [OK, NewWS, Newtree, NewParentInd, AllModuleInd([1,2,3,7])] =...
    ManeuverStepProcess(NewWS, Newtree, NewParentInd,AllModuleInd([1,2,3,7]), Axis(3), Steps(3));

    if ~ OK
        return
    end
% figure(4)
% PlotWorkSpace(NewWS,[],[]);    
%%
% 4) Upload modules 1-5 one line up.
    
    [OK, NewWS, Newtree, NewParentInd, AllModuleInd([1,2,3,4,5])] =...
    ManeuverStepProcess(NewWS, Newtree, NewParentInd,AllModuleInd([1,2,3,4,5]), Axis(4), Steps(4));

    if ~ OK
        return
    end
% figure(5)
% PlotWorkSpace(NewWS,[],[]);    
%%
% 5) Download module 3 one step.

    [OK, NewWS, Newtree, NewParentInd, AllModuleInd(3)] =...
    ManeuverStepProcess(NewWS, Newtree, NewParentInd,AllModuleInd(3), Axis(5), Steps(5));

    if ~ OK
        return
    end
% figure(6)
% PlotWorkSpace(NewWS,[],[]);
%%
% 6) Downloading modules 1,2,4,5 one row in the other axis back to the
% previous place.

    [OK, NewWS, Newtree, NewParentInd, AllModuleInd([1,2,4,5])] =...
    ManeuverStepProcess(NewWS, Newtree, NewParentInd,AllModuleInd([1,2,4,5]), Axis(6), Steps(6));

    if ~ OK
        return
    end
% figure(7)
% PlotWorkSpace(NewWS,[],[]);
%%
% 7) Download modules 1,2,4,5,6 line down in the first axis.

    [OK, NewWS, Newtree, NewParentInd, AllModuleInd([1,2,4,5,6])] =...
    ManeuverStepProcess(NewWS, Newtree, NewParentInd,AllModuleInd([1,2,4,5,6]), Axis(7), Steps(7));

    if ~ OK
        return
    end
% figure(8)
% PlotWorkSpace(NewWS,[],[]);
%%
% 8) Upload module 1 row up.

    [OK, NewWS, Newtree, NewParentInd, AllModuleInd(1)] =...
    ManeuverStepProcess(NewWS, Newtree, NewParentInd,AllModuleInd(1), Axis(8), Steps(8));

    if ~ OK
        return
    end
% figure(9)
% PlotWorkSpace(NewWS,[],[]);
%%
% 9) Upload modules 2,4,5,6 one line up.

    [OK, NewWS, Newtree, NewParentInd, AllModuleInd([2,4,5,6])] =...
    ManeuverStepProcess(NewWS, Newtree, NewParentInd,AllModuleInd([2,4,5,6]), Axis(9), Steps(9));

    if ~ OK
        return
    end
% figure(10)
% PlotWorkSpace(NewWS,[],[]);

WS = NewWS;
tree = Newtree;
ParentInd = NewParentInd;
end
