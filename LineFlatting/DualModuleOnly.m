function [WS,tree, ParentInd] =  DualModuleOnly(WS, tree, ParentInd)

[GroupsSizes,GroupIndexes, GroupInd] = ConfigGroupSizes(WS.Space.Status,WS.Space.Type,WS.R1);

GroupSizes = tree.Data{ParentInd,"IsomorphismMatrices1"}{1}(:,:,1);
if size(GroupSizes,2) > 1 || size(GroupSizes,1) > 2  || sign(GroupSizes(2,1)) ~= sign(GroupSizes(1,1))
    return
end


%%
% Algorithm for changing the order of a group with only 2 modules, a unit in a row when the base row has identical modules at the edges.
% The numbering of the modules is carried out from the end of the base line and inwards, modules 1-5,
% In the upper pair: module close to the corner - 6. Close to the middle - 7.
if EndIsAlpha(GroupsSizes(1))
    AllModuleInd = [flip(GroupInd{1}{1}(end-4:end)); flip(GroupInd{2}{1})];

    FirstStep = floor((GroupIndexes{1}{1}(end) - GroupIndexes{2}{1}(end)-1)/2) - 1;

    Steps = [FirstStep, -1, -1, ]
    Axis =  [1, ]
else
    AllModuleInd = [GroupInd{1}{1}(1:5); GroupInd{2}{1}];

    FirstStep = floor((GroupIndexes{1}{1}(1) - GroupIndexes{2}{1}(1)+1)/2) + 1;

    Steps = []
end

%% 1) Moving the upper pair towards the alpha module one step before the end.

[OK, NewWS, Newtree, NewParentInd, AllModuleInd([6,7])] =...
    ManeuverStepProcess(WS,tree,ParentInd,AllModuleInd([6,7]), Axis(1), Steps(1));

    if ~ OK
        return
    end


%% 2) Upload modules 1,2 one step up

[OK, NewWS, Newtree, NewParentInd, AllModuleInd([1,2])] =...
    ManeuverStepProcess(NewWS, Newtree, NewParentInd,AllModuleInd([1,2]), Axis(2), Steps(2));

    if ~ OK
        return
    end
% figure(2)
% PlotWorkSpace(NewWS,[],[]);

%% 3) Moving modules 1,2,6,7 one step inward.

[OK, NewWS, Newtree, NewParentInd, AllModuleInd([1,2,6,7])] =...
    ManeuverStepProcess(NewWS, Newtree, NewParentInd,AllModuleInd([1,2,6,7]), Axis(3), Steps(3));

    if ~ OK
        return
    end
% figure(3)
% PlotWorkSpace(NewWS,[],[]);

%% 4) Moving modules 1,3,4,5 one step down

[OK, NewWS, Newtree, NewParentInd, AllModuleInd([1,3,4,5])] =...
    ManeuverStepProcess(NewWS, Newtree, NewParentInd,AllModuleInd([1,3,4,5]), Axis(4), Steps(4));

    if ~ OK
        return
    end
% figure(4)
% PlotWorkSpace(NewWS,[],[]);

%% 5) Moving module 2 one step down

[OK, NewWS, Newtree, NewParentInd, AllModuleInd(2)] =...
    ManeuverStepProcess(NewWS, Newtree, NewParentInd,AllModuleInd(2), Axis(5), Steps(5));

    if ~ OK
        return
    end
% figure(5)
% PlotWorkSpace(NewWS,[],[]);

%% 6) Moving module 1,2,3,4,5 one step up

[OK, NewWS, Newtree, NewParentInd, AllModuleInd([1,2,3,4,5])] =...
    ManeuverStepProcess(NewWS, Newtree, NewParentInd,AllModuleInd([1,2,3,4,5]), Axis(6), Steps(6));

    if ~ OK
        return
    end
% figure(6)
% PlotWorkSpace(NewWS,[],[]);
%% 7) Moving module 1,2,3,4 step up

[OK, NewWS, Newtree, NewParentInd, AllModuleInd([1,2,3,4])] =...
    ManeuverStepProcess(NewWS, Newtree, NewParentInd,AllModuleInd([1,2,3,4]), Axis(7), Steps(7));

    if ~ OK
        return
    end
% figure(7)
% PlotWorkSpace(NewWS,[],[]);

%% 8) Moving module 7 step up

[OK, NewWS, Newtree, NewParentInd, AllModuleInd(7)] =...
    ManeuverStepProcess(NewWS, Newtree, NewParentInd,AllModuleInd(7), Axis(8), Steps(8));

    if ~ OK
        return
    end
% figure(8)
% PlotWorkSpace(NewWS,[],[]);

%% 9) Moving module 1,2,3,4,7 one step down.

[OK, NewWS, Newtree, NewParentInd, AllModuleInd([1,2,3,4,7])] =...
    ManeuverStepProcess(NewWS, Newtree, NewParentInd,AllModuleInd([1,2,3,4,7]), Axis(9), Steps(9));

    if ~ OK
        return
    end
% figure(9)
% PlotWorkSpace(NewWS,[],[]);


WS = NewWS;
tree = Newtree;
ParentInd = NewParentInd;


end
