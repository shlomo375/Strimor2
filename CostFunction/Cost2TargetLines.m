function MinCost = Cost2TargetLines(ConfigStruct,tree)
Config = logical(ConfigStruct.Status);
Target = logical(tree.EndConfig.ConfigMat{:});
WSConfig = WorkSpace(size(Config),"RRT*");
Config_RotationMatrices = {WSConfig.R1,WSConfig.R2,WSConfig.R3};

[StaticMatrix1,MovingMatrix1] = GetGroupsMatrix(Config,Config_RotationMatrices,Target,tree.EndConfig_RotationMatrices,1);
[StaticMatrix2,MovingMatrix2] = GetGroupsMatrix(Config,Config_RotationMatrices,Target,tree.EndConfig_RotationMatrices,2);
[StaticMatrix3,MovingMatrix3] = GetGroupsMatrix(Config,Config_RotationMatrices,Target,tree.EndConfig_RotationMatrices,3);

MinCost = 1e300;

for Axis1_idx = 0:size(StaticMatrix1,1)-size(MovingMatrix1,1)
    Cost1 = sum((MovingMatrix1 - StaticMatrix1(Axis1_idx+1:Axis1_idx+size(MovingMatrix1,1),:)).^2,'all');
    
    for Axis2_idx = 0:size(StaticMatrix2,1)-size(MovingMatrix2,1)

        Cost2 = sum((MovingMatrix2 - StaticMatrix2(Axis2_idx+1:Axis2_idx+size(MovingMatrix2,1),:)).^2,'all');
        try
%             Cost3 = sum((MovingMatrix3 - StaticMatrix3(((StartLineIDXAxis3:(StartLineIDXAxis3+size(MovingMatrix3,1)-1))-Axis2_idx+Axis1_idx-size(MovingMatrix1,1)+1),:)).^2,'all');
            Cost3 = sum((MovingMatrix3 - StaticMatrix3(((end-size(MovingMatrix3,1)+1:end)-Axis2_idx+Axis1_idx-size(MovingMatrix1,1)+1),:)).^2,'all');

        catch
            break
        end
        %%  The Cost-Function
        Cost = [Cost1,Cost2,Cost3];
        MinCost = CostSelector(Cost,MinCost,tree.FolderName);
%         Cost = sum([Cost1,Cost2,Cost3]);
%         if Cost<MinCost
%             MinCost = Cost;
%         end
    end
end




end
