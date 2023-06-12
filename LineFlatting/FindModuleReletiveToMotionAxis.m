function [MovingModuleInd,MovingModuleLocInAllModuleInd] = FindModuleReletiveToMotionAxis(R,ModuleInd,AllModuleInd,AboveModule,IncludeOrigin)
DontIncludeOriginModule = 1;
if nargin >= 5
    DontIncludeOriginModule = 0;
end


[Row,~] = find(R == ModuleInd,1);
if AboveModule
    LineRange = (Row+DontIncludeOriginModule):size(R,1);
else
    LineRange = (1:Row-DontIncludeOriginModule);
end

MovingModuleLocInAllModuleInd = ismember(AllModuleInd,R(LineRange,:));
MovingModuleInd = AllModuleInd(MovingModuleLocInAllModuleInd);

end
