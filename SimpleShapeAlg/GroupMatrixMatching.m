function [Config_A, Config_B] = GroupMatrixMatching(Config_A,Config_B)
% perimiyive function. should be more wisdem


GroupSizes_A = Config_A.IsomorphismMatrices1{1}(:,:,1);
GroupSizes_B = Config_B.IsomorphismMatrices1{1}(:,:,1);
if size(GroupSizes_A,1) > size(GroupSizes_B,1)
%     Config_B.IsomorphismMatrices1{1} = [Config_B.IsomorphismMatrices1{1}; zeros(size(GroupSizes_A,1)-size(GroupSizes_B,1),size(GroupSizes_B,2))];
    Config_B.IsomorphismMatrices1{1} = [zeros(size(GroupSizes_A,1)-size(GroupSizes_B,1),size(GroupSizes_B,2)); Config_B.IsomorphismMatrices1{1}];
else
%     Config_A.IsomorphismMatrices1{1} = [Config_A.IsomorphismMatrices1{1}; zeros(size(GroupSizes_B,1)-size(GroupSizes_A,1),size(GroupSizes_A,2))];
Config_A.IsomorphismMatrices1{1} = [zeros(size(GroupSizes_B,1)-size(GroupSizes_A,1),size(GroupSizes_A,2)); Config_A.IsomorphismMatrices1{1}];
end


end
