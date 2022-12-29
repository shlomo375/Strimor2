function [WS,tree] = ReducingRowsOneGroupInLine(WS,tree,FlatAxis,SpreadingSide, GroupInd, ParentInd)
Lables = ["IsomorphismMatrices1","IsomorphismMatrices2","IsomorphismMatrices3"];
AllModuleInd = find(WS.Space.Status);
GroupMatrix = tree.Data{tree.LastIndex,Lables(FlatAxis)}{1}(:,:,1);
switch FlatAxis
    case 1
        R1 = WS.R1;
        R2 = WS.R2;
        R3 = WS.R3;
    case 2
        R2 = WS.R1;
    case 3
        R3 = WS.R3;
end

switch SpreadingSide
    case 1
        LeadModuleType = sign(GroupMatrix(1:end-1));
        LeadModuleType(~mod(GroupMatrix(1:end-1),2)) = LeadModuleType(~mod(GroupMatrix(1:end-1),2))*-1;
        LeadModuleInd = cellfun(@(x)x(end),GroupInd(1:end-1))';
        
        for line = length(LeadModuleInd):-1:1
            if LeadModuleType(line)==1
%                 [Row,~] = find(R2==LeadModuleInd(line),1);
%                 MovingModuleLocInAllModuleInd = ismember(AllModuleInd,R2(Row+1:end,:));
%                 MovingModule = AllModuleInd(MovingModuleLocInAllModuleInd);
%                 
                AboveModule = true;
                Step = 1;
                Axis = 2;

                [MovingModule,MovingModuleLocInAllModuleInd] = FindModuleReletiveToMotionAxis(R2,LeadModuleInd(line),AllModuleInd,Axis,AboveModule);
                
            else
%                 [Row,~] = find(R3==LeadModuleInd(line),1);
%                 MovingModuleLocInAllModuleInd = ismember(AllModuleInd,R3(1:Row-1,:));
%                 MovingModule = AllModuleInd(MovingModuleLocInAllModuleInd);
                
                AboveModule = false;
                Step = -1;
                Axis = 3;
                
                [MovingModule,MovingModuleLocInAllModuleInd] = FindModuleReletiveToMotionAxis(R3,LeadModuleInd(line),AllModuleInd,Axis,AboveModule);

            end
            
            [OK, Configuration, Movement, WS1] = MakeAMove(WS,Axis,Step, MovingModule);
            
            if OK
                [Exists, tree, ParentInd] = SaveMoveToTree(tree,Configuration,Movement,ParentInd);
                if Exists
                    break
                end
                
                WS = WS1;
                WS.Space.Status(WS.Space.Status==2) = 1;
                AllModuleInd(MovingModuleLocInAllModuleInd) = ...
                    UpdateLinearIndex(size(WS.Space.Status),AllModuleInd(...
                    MovingModuleLocInAllModuleInd),Axis,Step);
            end
        end

    case -1
        LeadModuleType = sign(GroupMatrix(1:end-1));
        LeadModuleInd = cellfun(@(x)x(1),GroupInd(1:end-1))';
        
        for line = length(LeadModuleInd):-1:1
            if LeadModuleType(line)==1
%                 [Row,~] = find(R3==LeadModuleInd(line),1);
%                 MovingModuleLocInAllModuleInd = ismember(AllModuleInd,R3(Row+1:end,:));
%                 MovingModule = AllModuleInd(MovingModuleLocInAllModuleInd);


                AboveModule = true;
                Step = -1;
                Axis = 3;

                [MovingModule,MovingModuleLocInAllModuleInd] = FindModuleReletiveToMotionAxis(R3,LeadModuleInd(line),AllModuleInd,Axis,AboveModule);

            else
%                 [Row,~] = find(R2==LeadModuleInd(line),1);
%                 MovingModuleLocInAllModuleInd = ismember(AllModuleInd,R2(1:Row-1,:));
%                 MovingModule = AllModuleInd(MovingModuleLocInAllModuleInd);

                AboveModule = false;
                Step = 1;
                Axis = 2;
                
                [MovingModule,MovingModuleLocInAllModuleInd] = FindModuleReletiveToMotionAxis(R2,LeadModuleInd(line),AllModuleInd,Axis,AboveModule);

            end
            
            [OK, Configuration, Movement, WS1] = MakeAMove(WS,Axis,Step, MovingModule);
    
            if OK
                [Exists, tree, ParentInd] = SaveMoveToTree(tree,Configuration,Movement,ParentInd);
                if Exists
                    break
                end
                
                WS = WS1;

                AllModuleInd(MovingModuleLocInAllModuleInd) = ...
                    UpdateLinearIndex(size(WS.Space.Status),AllModuleInd(...
                    MovingModuleLocInAllModuleInd),Axis,Step);
            end
        PlotWorkSpace(WS,[]);
        end
end

% PlotWorkSpace(WS,[]);
end
