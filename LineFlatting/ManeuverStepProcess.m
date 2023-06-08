function [PrimaryOK, WS, tree, ParentInd, PrimaryModuleInd,Error] = ManeuverStepProcess(WS,tree,ParentInd,PrimaryModuleInd, PrimaryAxis,PrimaryStep)
SecondaryOK = false;
% The function tries to perform a primary movement. 
% If a movement is unsuccessful, she tries another movement.

if ~PrimaryStep
    PrimaryOK = true;
    return
end

[PrimaryOK, Configuration, Movement, WS1,~,Error] = MakeAMove(WS,PrimaryAxis,PrimaryStep, PrimaryModuleInd);

if PrimaryOK
    [Exists, tree, ParentInd] = SaveMoveToTree(tree,WS,Configuration,Movement,ParentInd);
%     if Exists
%         return
%     end
    
    WS = WS1;

    PrimaryModuleInd = UpdateLinearIndex(WS.SpaceSize,PrimaryModuleInd,PrimaryAxis,PrimaryStep);
% else
%    if nargin > 7
%         [SecondaryOK, Configuration, Movement, WS1] = MakeAMove(WS, SecondaryAxis, SecondaryStep, SecondaryModuleInd);
% 
%         if SecondaryOK
%             [Exists, tree, ParentInd] = SaveMoveToTree(tree,Configuration,Movement,ParentInd);
% %             if Exists
% %                 return
% %             end
% 
%             WS = WS1;
% 
%             SecondaryModuleInd = UpdateLinearIndex(WS.SpaceSize,SecondaryModuleInd,SecondaryAxis,SecondaryStep);
%        end
%    end
end

end
