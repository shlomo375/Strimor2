function [NeedHelp, varargout] = Read_Module_For_Help(WS, Tree, ParentInd, ConfigShift, Decision, Direction,Task)
NeedHelp = false;
varargout{1} = Decision;
varargout{2} = Direction;
if Task.Downwards && (~Task.Current_Line_Alpha || ~Task.Current_Line_Beta) 
    if matches(func2str(Decision{1}),["Alpha_Beta","Beta_Alpha"])
        varargout{1} = Decision{1};
        varargout{2} = Direction{1};
        return
    elseif matches(func2str(Decision{2}),["Alpha_Beta","Beta_Alpha"])
        varargout{1} = Decision{2};
        varargout{2} = Direction{2};
        return
    end
    
    StartConfig = Tree.Data{ParentInd,"IsomorphismMatrices1"}{1}(:,:,1);
    TargetConfig = Tree.EndConfig{1,"IsomorphismMatrices1"}{1}(:,:,1);

    if Task.Current_Line_Alpha
        Destenation_Line = Task.Current_Line_Alpha - 1;
        Beta_Override = zeros(size(StartConfig));
        Beta_Override(Destenation_Line) = 1;

        varargout{1} = Module_Task_Allocation(StartConfig, TargetConfig, Task.Downwards, Destenation_Line, BetaDiff_Override=Beta_Override,WS=WS,ConfigShift=ConfigShift);
    else
        Destenation_Line = Task.Current_Line_Beta - 1;
        Alpha_Override = zeros(size(StartConfig));
        Alpha_Override(Destenation_Line) = 1;

        varargout{1} = Module_Task_Allocation(StartConfig, TargetConfig, Task.Downwards, Destenation_Line, BetaDiff_Override=Alpha_Override,WS=WS,ConfigShift=ConfigShift);
    end
    varargout{2} = [];

    NeedHelp  = true;

end



end
