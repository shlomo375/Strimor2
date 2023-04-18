function [Moving_Log,AllModuleInd] = AddAboveModule(Line, AllModuleInd,GroupsInds,LineSteps, Moving_Log, Downwards)

if Line < numel(GroupsInds) && any(LineSteps)
    ExtraModule = [];
    
    if Downwards
        for l = numel(GroupsInds):-1:Line+1
            if ~isempty(GroupsInds{l})
                ExtraModule = [ExtraModule, GroupsInds{l}{1}];
            end
        end
    else
        for l = 1:Line-1
            if ~isempty(GroupsInds{l})
                ExtraModule = [ExtraModule, GroupsInds{l}{1}];
            end
        end
    end
    AllModuleInd = [AllModuleInd;ExtraModule'];
    Moving_Log(1:nnz(LineSteps),(end+1):(end+numel(ExtraModule))) = true;
end

end
