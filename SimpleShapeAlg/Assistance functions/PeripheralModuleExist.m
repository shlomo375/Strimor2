function [OK, Task] = PeripheralModuleExist(Tree,Direction,Downwards,TopLineIdx,Edge,GroupSizeRequired,Action)
arguments

    Tree
    Direction
    Downwards
    TopLineIdx
    Edge
    GroupSizeRequired
    Action = "";
end

if numel(GroupSizeRequired) == 2
    if TopLineIdx ~= 1 %&& ~matches(Action,"Create")
        GroupSizeAvailable = permute(Edge(4,1,2:3),[3,1,2]);
        LineShift = TopLineIdx-2;
    % elseif matches(Action,"Create")
    %     GroupSizeAvailable = permute(Edge(4,1,1:2),[3,1,2]);
    %     LineShift = TopLineIdx-1;
    else
        error("problem at PeripheralModuleExist func");
    end
end

if numel(GroupSizeRequired) == 3
    if TopLineIdx ~= 2
        GroupSizeAvailable = permute(Edge(4,1,2:end),[3,1,2]);
        LineShift = TopLineIdx-3;
    else
        error("problem at PeripheralModuleExist func");
    end
end

% switch Action
%     case "Switch"
%         Addition(1,1) = abs(GroupSizeRequired(1)) - (GroupSizeAvailable(1));
% 
%         Addition(2,1) = abs(GroupSizeRequired(2)) - abs(GroupSizeAvailable(2));
%         if GroupSizeRequired(2) == - GroupSizeAvailable(2)
%             Addition(2) = 1;
%         end
%         Addition(Addition<0) = 0;
%         Downwards = ~Downwards;
%     otherwise
        Addition = abs(GroupSizeRequired)' - abs(GroupSizeAvailable);
        Addition(Addition<0) = 0;
% end

[Topest_Line_To_Add,~,Num_Module_Added] = find(Addition,1);

if isempty(Topest_Line_To_Add)
    OK = true;
    Task = [];
    return
end

if matches(Direction,"Left")
    Direction = "Right";
else
    Direction = "Left";
end
if Num_Module_Added >= 2
    AlphaDiff = 1;
    BetaDiff = 1;
elseif EndIsAlpha(GroupSizeAvailable(Topest_Line_To_Add))
    if Downwards
        BetaDiff = 1;
        AlphaDiff = 0;
    else
        AlphaDiff = 1;
        BetaDiff = 0;
    end
else
    if Downwards
        AlphaDiff = 1;
        BetaDiff = 0;
    else
        BetaDiff = 1;
        AlphaDiff = 0;
    end
end

Topest_Line_To_Add = Topest_Line_To_Add + LineShift;


StartConfig = Tree.Data{Tree.LastIndex,"IsomorphismMatrices1"}{1}(:,:,1);
TargetConfig = Tree.EndConfig{1,"IsomorphismMatrices1"}{1}(:,:,1);

if ~Downwards
    Topest_Line_To_Add = numel(StartConfig) - Topest_Line_To_Add + 1;
end

Task = Module_Task_Allocation(StartConfig, TargetConfig, Tree.Total_Downwards, Topest_Line_To_Add, "AlphaDiff_Override",AlphaDiff,"BetaDiff_Override",BetaDiff);

OK = false;

end
