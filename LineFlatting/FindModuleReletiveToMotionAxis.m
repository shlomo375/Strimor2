function [MovingModuleInd,MovingModuleLocInAllModuleInd] = FindModuleReletiveToMotionAxis(R,ModuleInd,AllModuleInd,Axis,AboveModule)

[Row,~] = find(R == ModuleInd,1);
if AboveModule
    LineRange = (Row+1):size(R,1);
else
    LineRange = (1:Row-1);
end
MovingModuleLocInAllModuleInd = ismember(AllModuleInd,R(LineRange,:));
MovingModuleInd = AllModuleInd(MovingModuleLocInAllModuleInd);

end
