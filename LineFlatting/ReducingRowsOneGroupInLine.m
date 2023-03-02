function [WS,tree, ParentInd] = ReducingRowsOneGroupInLine(WS,tree, ParentInd, SpreadingSide)

while 1
    EndTerm = WS.Space.Status;
    [GroupsSizes,~, GroupInd] = ConfigGroupSizes(WS.Space.Status,WS.Space.Type,WS.R1);
    AllModuleInd = find(WS.Space.Status);
    try
    switch SpreadingSide
        case 1
            LeadModuleType = sign(GroupsSizes(1:end-1));
            LeadModuleType(~mod(GroupsSizes(1:end-1,:),2)) = LeadModuleType(~mod(GroupsSizes(1:end-1,:),2))*-1;
            try
                LeadModuleInd = cellfun(@(x)x{end}(end),GroupInd(1:end-1),UniformOutput=true)';
            catch
                LeadModuleInd = cellfun(@(x)x(end),GroupInd(1:end-1,:),UniformOutput=true)';
            end
    
            for line = length(LeadModuleInd):-1:1
                ModuleAboveInd = [];
                if LeadModuleType(line)==1
    
                    AboveModule = true;
                    Step = 1;
                    Axis = 2;
    
                    [MovingModule,MovingModuleLocInAllModuleInd] = FindModuleReletiveToMotionAxis(WS.R2,LeadModuleInd(line),AllModuleInd,AboveModule);
                    
                else
                    AboveModule = false;
                    Step = -1;
                    Axis = 3;
                    
                    [MovingModule,MovingModuleLocInAllModuleInd] = FindModuleReletiveToMotionAxis(WS.R3,LeadModuleInd(line),AllModuleInd,AboveModule);
                    
                end
                
                for L = (length(GroupInd):-1:line+1)
                        ModuleAboveInd(:,L-line) = ismember(AllModuleInd,cat(1,GroupInd{L}{:}));
                end
                
                MovingModuleLocInAllModuleInd = all([MovingModuleLocInAllModuleInd,any(ModuleAboveInd,2)],2);
                
                
                if isempty(AllModuleInd(MovingModuleLocInAllModuleInd))
                    continue
                end


                [OK, NewWS, Newtree, NewParentInd, AllModuleInd(MovingModuleLocInAllModuleInd)] =...
                    ManeuverStepProcess(WS, tree, ParentInd, AllModuleInd(MovingModuleLocInAllModuleInd), Axis, Step);
                
                if ~ OK
                    return
                end
                
                WS = NewWS;
                tree = Newtree;
                ParentInd = NewParentInd;

                [~,~, GroupInd] = ConfigGroupSizes(WS.Space.Status,WS.Space.Type,WS.R1);
            end
    
        case -1
            LeadModuleType = sign(GroupsSizes(1:end-1));
            LeadModuleInd = cellfun(@(x)x{1}(1),GroupInd(1:end-1))';
            
            for line = length(LeadModuleInd):-1:1
                ModuleAboveInd = [];
                if LeadModuleType(line)==1
    
                    AboveModule = true;
                    Step = -1;
                    Axis = 3;
    
                    [MovingModule,MovingModuleLocInAllModuleInd] = ...
                        FindModuleReletiveToMotionAxis(WS.R3,LeadModuleInd(line),AllModuleInd,AboveModule);
    
                else
    
                    AboveModule = false;
                    Step = 1;
                    Axis = 2;
                    
                    [MovingModule,MovingModuleLocInAllModuleInd] = ...
                        FindModuleReletiveToMotionAxis(WS.R2,LeadModuleInd(line),AllModuleInd,AboveModule);
    
                end
                
            
                for L = (length(GroupInd):-1:line+1)
                        ModuleAboveInd(:,L-line) = ismember(AllModuleInd,cat(1,GroupInd{L}{:}));
                end
                MovingModuleLocInAllModuleInd = all([MovingModuleLocInAllModuleInd,any(ModuleAboveInd,2)],2);
                

                if isempty(AllModuleInd(MovingModuleLocInAllModuleInd))
                    continue
                end


                [OK, NewWS, Newtree, NewParentInd, AllModuleInd(MovingModuleLocInAllModuleInd)] =...
                    ManeuverStepProcess(WS, tree, ParentInd, AllModuleInd(MovingModuleLocInAllModuleInd), Axis, Step);
                
                if ~ OK
                    return
                end
                
                WS = NewWS;
                tree = Newtree;
                ParentInd = NewParentInd;
                
                [~,~, GroupInd] = ConfigGroupSizes(WS.Space.Status,WS.Space.Type,WS.R1);
            end
    end
    if isequal(WS.Space.Status,EndTerm)
        break
    end
    catch EndTe
        EndTe
    end
end

% PlotWorkSpace(WS,[],[]);
end
