function [Config_A, Config_B,ConfigShift] = GroupMatrixMatching(Config_A,WS_A,Config_B,WS_B)
% perimiyive function. should be more wisdem
GroupSizes_A = ConfigGroupSizes(WS_A.Space.Status,WS_A.Space.Type,WS_A.R1);
GroupSizes_B = ConfigGroupSizes(WS_B.Space.Status,WS_B.Space.Type,WS_B.R1);
% GroupSizes_A = Config_A.IsomorphismMatrices1{1}(:,:,1);
% GroupSizes_B = Config_B.IsomorphismMatrices1{1}(:,:,1);

Config_A_Shift = [0;0];
Config_B_Shift = [0;0];
if size(GroupSizes_A,1) > size(GroupSizes_B,1)
%     Config_B.IsomorphismMatrices1{1} = [Config_B.IsomorphismMatrices1{1}; zeros(size(GroupSizes_A,1)-size(GroupSizes_B,1),size(GroupSizes_B,2))];
    Config_B.IsomorphismMatrices1{1} = [Config_B.IsomorphismMatrices1{1}; zeros(size(GroupSizes_A,1)-size(GroupSizes_B,1),size(GroupSizes_B,2))];
    Config_B{1,"IsomorphismStr1"} = join(string(Config_B.IsomorphismMatrices1{1}(:))',"");
    Config_B{1,["IsoSiz1r","IsoSiz1c"]} = size(Config_B.IsomorphismMatrices1{1});
    Config_B_Shift = [                  0 ;...
                      size(GroupSizes_A,1)-size(GroupSizes_B,1)];
else
%     Config_A.IsomorphismMatrices1{1} = [Config_A.IsomorphismMatrices1{1}; zeros(size(GroupSizes_B,1)-size(GroupSizes_A,1),size(GroupSizes_A,2))];
    Config_A.IsomorphismMatrices1{1} = [zeros(size(GroupSizes_B,1)-size(GroupSizes_A,1),size(GroupSizes_A,2)); Config_A.IsomorphismMatrices1{1}];
    Config_A{1,"IsomorphismStr1"} = join(string(Config_A.IsomorphismMatrices1{1}(:))',"");
    Config_A{1,["IsoSiz1r","IsoSiz1c"]} = size(Config_A.IsomorphismMatrices1{1});
    
    Config_A_Shift = [size(GroupSizes_B,1)-size(GroupSizes_A,1);...
                                        0                       ];
end
ConfigShift = [Config_A_Shift,Config_B_Shift];

end
