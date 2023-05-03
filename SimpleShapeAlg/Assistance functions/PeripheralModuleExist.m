function [OK, Task] = PeripheralModuleExist(Tree,Downwards,TopLineIdx,Edge,GroupSizeRequired)

if numel(GroupSizeRequired) == 2
    if TopLineIdx ~= 1
        GroupSizeAvailable = permute(Edge(4,1,2:3),[3,1,2]);
        LineShift = TopLineIdx-2;
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


Addition = abs(GroupSizeRequired)' - abs(GroupSizeAvailable);
Addition(Addition<0) = 0;

[Topest_Line_To_Add,~,Num_Module_Added] = find(Addition,1);

if isempty(Topest_Line_To_Add)
    OK = true;
    Task = [];
    return
end


if Num_Module_Added >= 2
    AlphaDiff = 1;
    BetaDiff = 1;
elseif EndIsAlpha(GroupSizeAvailable(Topest_Line_To_Add))
    BetaDiff = 1;
    AlphaDiff = 0;
else
    AlphaDiff = 1;
    BetaDiff = 0;
end

Topest_Line_To_Add = Topest_Line_To_Add + LineShift;

StartConfig = Tree.Data{Tree.LastIndex,"IsomorphismMatrices1"}{1}(:,:,1);
TargetConfig = Tree.EndConfig{1,"IsomorphismMatrices1"}{1}(:,:,1);
Task = Module_Task_Allocation(StartConfig, TargetConfig, Downwards, Topest_Line_To_Add, "AlphaDiff_Override",AlphaDiff,"BetaDiff_Override",BetaDiff);

OK = false;

end
