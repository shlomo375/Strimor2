function FlatteningSpecialLines(WS,tree,FlatAxis,ParentInd)
RotationMatrices = {WS.R1,WS.R2,WS.R3};
ConfigMat2 = GetConfigProjection(WS.Space.Status,RotationMatrices,2);
ConfigType2 = -1 * GetConfigProjection(WS.Space.Type,RotationMatrices,2);

ConfigMat3 = GetConfigProjection(WS.Space.Status,RotationMatrices,3);
ConfigType3 = -1 * GetConfigProjection(WS.Space.Type,RotationMatrices,3);


[GroupsSizes1,GroupIndexes1, GroupInd1] = ConfigGroupSizes(WS.Space.Status,WS.Space.Type,WS.R1);
[GroupsSizes2,GroupIndexes2, GroupInd2] = ConfigGroupSizes(ConfigMat2,ConfigType2,WS.R2);
[GroupsSizes3,GroupIndexes3, GroupInd3] = ConfigGroupSizes(ConfigMat3,ConfigType3,WS.R3);

%% Do you need a special line reduction?
if size(GroupsSizes1,1)>2
    %% Straight line detection
    StraightLineToRightLoc = find(abs(GroupsSizes3) >= 5 | GroupsSizes3 == 4);

    StraightLineToLeftLoc = find(abs(GroupsSizes2) >= 5 | GroupsSizes2 == -4);
    
    %% axis 3
    for StraightLine_idx = 1:numel(StraightLineToRightLoc) % axis 3
        ModulesInd = GroupInd3{StraightLineToRightLoc(StraightLine_idx)}{:};
        
        ScannedAgent = ~WS.Space.Status;
        ScannedAgent(GroupInd1{1}{:}) = true;
        [~, StraightLineModulesInd] = ScanningAgents(WS, ScannedAgent, ModulesInd(3), []); % for Left line i need to take the first module
        
        
        

        Axis = 3;
        Step = -1;
        
        FlatteningBranch(WS,tree,ParentInd,ModulesInd,StraightLineModulesInd)

%         [OK, Configuration, Movement, WS1] = MakeAMove(WS,Axis,Step, StraightLineModulesInd);
%     
%         if OK
%             [Exists, tree, ParentInd] = SaveMoveToTree(tree,Configuration,Movement,ParentInd);
%             if Exists
%                 break
%             end
%             
%             WS = WS1;
% 
%             AllModuleInd(MovingModuleLocInAllModuleInd) = ...
%                 UpdateLinearIndex(size(WS.Space.Status),AllModuleInd(...
%                 MovingModuleLocInAllModuleInd),Axis,Step);
%         end
%         if sum(GroupsSizes3(StraightLineToRightLoc(StraightLine_idx)+1,:)~=0) > 1 % there is another group in the line above.
%             SuspiciousGroupInd = GroupInd3{StraightLineToRightLoc(StraightLine_idx)+1}{2};
%             
%         end
    
    end

    %% axis 2
end

end
