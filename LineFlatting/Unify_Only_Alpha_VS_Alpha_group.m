function [OK, WS,tree,ParentInd] = Unify_Only_Alpha_VS_Alpha_group(WS,tree,ParentInd, GroupPairNum, GroupIndexes, GroupInd)

if GroupPairNum > 1 && GroupPairNum < numel(GroupInd{2})-1
    OK = false;
    return
end



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
