function [Step,Axis,Moving_Log] = AddGoBackSteps(Step,Axis,Moving_Log)

Foward_Loc = find(Axis==1);
if isempty(Foward_Loc)
    return
end
if any(Foward_Loc > 4)
    Module_Loc = max(Foward_Loc);
    Ratio = 0.5;
else
    [~,Module_Loc] = max(sum(Moving_Log(Foward_Loc,:),2));
    Ratio = 1;
end

if ~all(Moving_Log(Module_Loc,:))
    return 
end

Step(end+1) = fix(-Step(Module_Loc)*Ratio);
Axis(end+1) = 1;
Moving_Log(end+1,:) = 1;


end
