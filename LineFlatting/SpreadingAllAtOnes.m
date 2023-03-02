function [WS, tree, ParentInd, GroupsSizes,GroupInd] = SpreadingAllAtOnes(WS,tree,ParentInd,SpreadingDir)

[GroupsSizes,GroupIndexes, GroupInd] = ConfigGroupSizes(WS.Space.Status,WS.Space.Type,WS.R1);

% if SpreadingDir == 1
%     [LastGroupInLine,Line] = find(diff(~[GroupsSizes,zeros(size(GroupsSizes,1),1)],1,2)',size(GroupsSizes,1));
%     Ind = sub2ind(size(GroupsSizes),Line,LastGroupInLine);
%     
%     LineEdges = cell2mat(cellfun(@(line) [line{end}(1),line{end}(end)],GroupIndexes','UniformOutput',false));
%     FirstAlphaInLine = LineEdges(:,1) + double(GroupsSizes(Ind) < 0);
%     LastBetaInLine = LineEdges(:,2) - ~xor(GroupsSizes(Ind)>0,mod(GroupsSizes(Ind),2));
%     
%     StepsNeeded = [0; LastBetaInLine(1:end-1) - FirstAlphaInLine(2:end)]/2;
% else
%     LineEdges = cell2mat(cellfun(@(line) [line{1}(1),line{1}(end)],GroupIndexes','UniformOutput',false));
%     FirstBetaInLine = LineEdges(:,1) + double(GroupsSizes(:,1) > 0);
%     LastAlphaInLine = LineEdges(:,2) - ~xor(GroupsSizes(:,1)<0,mod(GroupsSizes(:,1),2));
% 
%     StepsNeeded = -[0; LastAlphaInLine(2:end) - FirstBetaInLine(1:end-1)]/2;
% end

for line = numel(GroupInd):-1:2
    if SpreadingDir == 1
        GroupsNum = 1:length(GroupInd{line});
    else
        GroupsNum = length(GroupInd{line}):-1:1;
    end
    if numel(GroupsNum)>1
        d=5
    end
    for group = GroupsNum
    %     GroupIndStartLoc = length(MoveingModules)+1;
        [MoveingModules, Step] = Get_BranchModuleInd(WS,GroupInd,GroupInd{line}{group}(1),line,SpreadingDir);

        if ~Step
            continue
        end
        Axis = 1;
        [OK, WS, tree, ParentInd, MoveingModules] =...
        ManeuverStepProcess(WS,tree,ParentInd,MoveingModules, Axis, Step);
        
    
        if ~OK
            continue
        end
        [~,~, GroupInd] = ConfigGroupSizes(WS.Space.Status,WS.Space.Type,WS.R1);
    end
end


% PlotWorkSpace(WS,[],[]);
end


