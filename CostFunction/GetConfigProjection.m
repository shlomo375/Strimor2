function NewConfig = GetConfigProjection(Config,Config_RotationMatrices,Axis)
           
    space = zeros(size(Config_RotationMatrices{1}));
    space(1:size(Config,1),1:size(Config,2)) = Config;
    
    R = Config_RotationMatrices{Axis};
    
    ZeroLoc = (R==0);
    R(~R) = 1;
    space = space(R);
    space(ZeroLoc) = 0;
    NewConfig = space;
%     NewConfig = space(any(space,2),any(space));
    
end