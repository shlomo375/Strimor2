function [BranchModulesInd,varargout] = Get_BranchModuleInd(WS,GroupsIndxes,StartModule,Line,FunctionMethod,P)

arguments
    WS
    GroupsIndxes
    StartModule
    Line
    FunctionMethod {mustBeTextScalar,... 
        matches(FunctionMethod, ...
        ["BRANCH", ...
        "BRANCH_AND_MAX_STEP", ...
        "BRANCH_MAX_STEP_REDUCE"])} = "BRANCH";
    P.Dir {matches(P.Dir,["Left","Right"])}
end

ScannedAgent = ~WS.Space.Status;

ScannedAgent(cat(1,GroupsIndxes{Line-1}{:})) = true;
[~, BranchModulesInd] = ScanningAgentsFast(WS, ScannedAgent, StartModule,true);


if matches(FunctionMethod,["BRANCH_AND_MAX_STEP","BRANCH_MAX_STEP_REDUCE"])
  %% compute steps
        if Line >=3
%             ScannedAgent = ~WS.Space.Status;
%             ScannedAgent(cat(1,GroupsIndxes{Line-2}{:})) = true;
%             ScannedAgent(cat(1,GroupsIndxes{Line}{:})) = true;
%             ScannedAgent(BranchModulesInd) = false;
%         
%             [~, BaseModulesInd] = ScanningAgentsFast(WS, ScannedAgent, StartModule,true);
%             BaseModulesInd(ismember(BaseModulesInd,BranchModulesInd)) = [];
            BaseModulesInd = vertcat(GroupsIndxes{Line-1}{:});
        else
            BaseModulesInd = GroupsIndxes{1}{1};
        end
        BaseModulesIndType = WS.Space.Type(BaseModulesInd);
        [~,BaseModuleEdgeLocCol] = ind2sub(WS.SpaceSize,BaseModulesInd);
        
        TopLineModulesInd = BranchModulesInd(ismember(BranchModulesInd,cat(1,GroupsIndxes{Line}{:})));
        TopLineModulesType = WS.Space.Type(TopLineModulesInd);
        [~,MovingModuleEdgeLocCol] = ind2sub(WS.SpaceSize,TopLineModulesInd);
            
        switch P.Dir
            case "Right"
                varargout{1} = (max(BaseModuleEdgeLocCol(BaseModulesIndType==-1)) - min(MovingModuleEdgeLocCol(TopLineModulesType==1)))/2;
            case "Left"
                varargout{1} = (min(BaseModuleEdgeLocCol(BaseModulesIndType==-1)) - max(MovingModuleEdgeLocCol(TopLineModulesType==1)))/2;
        end
        if matches(FunctionMethod,"BRANCH_MAX_STEP_REDUCE")
            % compute Module to reduce
            NewModuleInd = UpdateLinearIndex(WS.SpaceSize,BranchModulesInd,1,varargout{1});
            switch P.Dir
                case "Right"
                    [~, EdgeModuleLoc] = max(BaseModuleEdgeLocCol);
                case "Left"
                    [~, EdgeModuleLoc] = min(BaseModuleEdgeLocCol);
            end
            EdgeModuleType = BaseModulesIndType(EdgeModuleLoc);
            EdgeInd = BaseModulesInd(EdgeModuleLoc);
            
            [varargout{2},varargout{3}] = FindModuleConnectedToEdgeToReduce(WS,EdgeInd,EdgeModuleType,NewModuleInd,P.Dir);
%                     varargout{2} = MovingModuleInd;
                    
        end
end

end


