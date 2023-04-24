function Tbl = CreatTaskAllocationTable(Name,Value)
% arguments
%     ModuleTransitionData
% end
arguments (Repeating)
    Name (1,1) {mustBeTextScalar,matches(Name,["Current_Line","Module_Num","Side","Downwards"])}
    Value (1,1)
end
    

Tbl = table(0,0,"",false,false,false,'VariableNames',["Current_Line","Module_Num","Side","Downwards","Finish","Sequence"]);
for ii = 1:numel(Name)

    Tbl{1,Name{ii}} = Value{ii};

end


end