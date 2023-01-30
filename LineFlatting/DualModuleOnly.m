function [WS,Tree, ParentInd] =  DualModuleOnly(WS, Tree, ParentInd)

GroupSizes = Tree.Data{ParentInd,"IsomorphismMatrices1"}{1}(:,:,1);
if size(GroupSizes,2) > 1 || size(GroupSizes,1) > 2  || sign(GroupSizes(2,1)) ~= sign(GroupSizes(1,1))
    return
end


%%
% Algorithm for changing the order of a group with only 2 modules, a unit in a row when the base row has identical modules at the edges.
% The numbering of the modules is carried out from the end of the base line and inwards, modules 1-5,
% In the upper pair: module close to the corner - 6. Close to the middle - 7.
% 
% 1) Moving the upper pair towards the alpha module one step before the end.
% 2) Upload modules 1,2 one step up
% 3) Moving modules 1,2,6,7 one step inward.
% 4) Moving modules 1,3,4,5 one step down
% 5) Moving module 2 one step down
% 6) Moving module 1,2,3,4,5 one step up
% 7) Moving module 1,2,3,4 step up
% 8) Moving module 7 step up
% 9) Moving module 1,2,3,4,7 one step down.

if GroupPairNum == 1
% All modules are arranged in the following order:
% 1-4) The four modules of the bottom row, from the edge inward
% 5) Front module in the top row
% 6) Rear module in the top row
    AllModuleInd = [GroupInd{1}{1}(1:4); GroupInd{2}{1}(1); GroupInd{2}{2}(1)];

    FirstStep = -(((GroupIndexes{2}{1}(1)-GroupIndexes{1}{1}(1))/2)-1);
    SecondStep = -(((GroupIndexes{2}{2}(1)-GroupIndexes{2}{1}(1))/2)-1);

    Steps = [FirstStep,SecondStep,1,2,-1];
    Axis = [1,1,2,3,2];


    

else
% All modules are arranged in the following order:
% 1-4) The four modules of the bottom row, from the edge inward
% 5) Front module in the top row
% 6) Rear module in the top row
    AllModuleInd = [flip(GroupInd{1}{1}(end-3:end)); GroupInd{2}{end}(1); GroupInd{2}{end-1}(1)];

    FirstStep = (((GroupIndexes{1}{1}(end)-GroupIndexes{2}{end}(1))/2)-1);
    SecondStep = (((GroupIndexes{2}{end}(1)-GroupIndexes{2}{end-1}(1))/2)-1);

    Steps = [FirstStep,SecondStep,-1,-2,1];
    Axis = [1,1,3,2,3];

end
% figure(1)
% PlotWorkSpace(WS,[],[]);

% Algorithm for merging 2 alpha modules, the modules are numbered from the
% outer edge of the bottom row inward, the two modules in the top row are
% described as front and back modules.

%%
% 1) Moving a front and rear module in the upper row to the front edge of the lower
% row.
[OK, NewWS, Newtree, NewParentInd, AllModuleInd([5,6])] =...
    ManeuverStepProcess(WS,tree,ParentInd,AllModuleInd([5,6]), Axis(1), Steps(1));

    if ~ OK
        return
    end

% figure(1)
% PlotWorkSpace(NewWS,[],[]);
%%
% 2) Moving the rear module in the top row in the same direction until it
% attaches to the front module.
[OK, NewWS, Newtree, NewParentInd, AllModuleInd(6)] =...
    ManeuverStepProcess(NewWS, Newtree, NewParentInd,AllModuleInd(6), Axis(2), Steps(2));

    if ~ OK
        return
    end
% figure(1)
% PlotWorkSpace(NewWS,[],[]);
%%
% 3) Download front module and modules 1,2,3,4 one line down
[OK, NewWS, Newtree, NewParentInd, AllModuleInd([1,2,3,4,5])] =...
    ManeuverStepProcess(NewWS, Newtree, NewParentInd,AllModuleInd([1,2,3,4,5]), Axis(3), Steps(3));

    if ~ OK
        return
    end
% figure(1)
% PlotWorkSpace(NewWS,[],[]);
%%
% 4) Move module 1 two lines up.
[OK, NewWS, Newtree, NewParentInd, AllModuleInd(1)] =...
    ManeuverStepProcess(NewWS, Newtree, NewParentInd,AllModuleInd(1), Axis(4), Steps(4));

    if ~ OK
        return
    end
% figure(1)
% PlotWorkSpace(NewWS,[],[]);
%%
% 5) Raising the front module and 2,3,4 one row up.
[OK, NewWS, Newtree, NewParentInd, AllModuleInd([2,3,4,5])] =...
    ManeuverStepProcess(NewWS, Newtree, NewParentInd,AllModuleInd([2,3,4,5]), Axis(5), Steps(5));

    if ~ OK
        return
    end

% figure(1)
% PlotWorkSpace(NewWS,[],[]);

WS = NewWS;
tree = Newtree;
ParentInd = NewParentInd;


end
