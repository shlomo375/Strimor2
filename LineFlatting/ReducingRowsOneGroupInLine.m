function [WS,tree, ParentInd] = ReducingRowsOneGroupInLine(WS,tree, ParentInd, SpreadingSide,GroupsSizes, GroupInd)

AllModuleInd = find(WS.Space.Status);

switch SpreadingSide
    case 1
        LeadModuleType = sign(GroupsSizes(1:end-1,:));
        LeadModuleType(~mod(GroupsSizes(1:end-1,:),2)) = LeadModuleType(~mod(GroupsSizes(1:end-1,:),2))*-1;
        try
            LeadModuleInd = cellfun(@(x)x{1}(end),GroupInd(1:end-1),UniformOutput=true)';
        catch
            LeadModuleInd = cellfun(@(x)x(end),GroupInd(1:end-1,:),UniformOutput=true)';
        end
        for line = length(LeadModuleInd):-1:1
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
            
            [OK, NewWS, Newtree, NewParentInd, AllModuleInd(MovingModuleLocInAllModuleInd)] =...
                ManeuverStepProcess(WS, tree, ParentInd, AllModuleInd(MovingModuleLocInAllModuleInd), Axis, Step);
            
            if ~ OK
                return
            end
            
            WS = NewWS;
            tree = Newtree;
            ParentInd = NewParentInd;
%             [OK, Configuration, Movement, WS1] = MakeAMove(WS,Axis,Step, MovingModule);
%             
%             if OK
%                 [Exists, tree, ParentInd] = SaveMoveToTree(tree,Configuration,Movement,ParentInd);
%                 if Exists
%                     break
%                 end
%                 
%                 WS = WS1;
%                 WS.Space.Status(WS.Space.Status==2) = 1;
%                 AllModuleInd(MovingModuleLocInAllModuleInd) = ...
%                     UpdateLinearIndex(size(WS.Space.Status),AllModuleInd(...
%                     MovingModuleLocInAllModuleInd),Axis,Step);
%             end
        end

    case -1
        LeadModuleType = sign(GroupsSizes(1:end-1));
        LeadModuleInd = cellfun(@(x)x{1}(1),GroupInd(1:end-1))';
        
        for line = length(LeadModuleInd):-1:1
            if LeadModuleType(line)==1
%                 [Row,~] = find(R3==LeadModuleInd(line),1);
%                 MovingModuleLocInAllModuleInd = ismember(AllModuleInd,R3(Row+1:end,:));
%                 MovingModule = AllModuleInd(MovingModuleLocInAllModuleInd);


                AboveModule = true;
                Step = -1;
                Axis = 3;

                [MovingModule,MovingModuleLocInAllModuleInd] = FindModuleReletiveToMotionAxis(WS.R3,LeadModuleInd(line),AllModuleInd,AboveModule);

            else
%                 [Row,~] = find(R2==LeadModuleInd(line),1);
%                 MovingModuleLocInAllModuleInd = ismember(AllModuleInd,R2(1:Row-1,:));
%                 MovingModule = AllModuleInd(MovingModuleLocInAllModuleInd);

                AboveModule = false;
                Step = 1;
                Axis = 2;
                
                [MovingModule,MovingModuleLocInAllModuleInd] = FindModuleReletiveToMotionAxis(WS.R2,LeadModuleInd(line),AllModuleInd,AboveModule);

            end
            
            [OK, NewWS, Newtree, NewParentInd, AllModuleInd(MovingModuleLocInAllModuleInd)] =...
                ManeuverStepProcess(WS, tree, ParentInd, AllModuleInd(MovingModuleLocInAllModuleInd), Axis, Step);
            
            if ~ OK
                return
            end
            
            WS = NewWS;
            tree = Newtree;
            ParentInd = NewParentInd;

%             [OK, Configuration, Movement, WS1] = MakeAMove(WS,Axis,Step, MovingModule);
%     
%             if OK
%                 [Exists, tree, ParentInd] = SaveMoveToTree(tree,Configuration,Movement,ParentInd);
%                 if Exists
%                     break
%                 end
%                 
%                 WS = WS1;
% 
%                 AllModuleInd(MovingModuleLocInAllModuleInd) = ...
%                     UpdateLinearIndex(size(WS.Space.Status),AllModuleInd(...
%                     MovingModuleLocInAllModuleInd),Axis,Step);
%             end
%         PlotWorkSpace(WS,[]);
        end
end

% PlotWorkSpace(WS,[],[]);
end
