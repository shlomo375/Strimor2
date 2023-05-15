function [Config_A, Config_B,ConfigShift] = GroupMatrixMatching(Config_A,WS_A,Config_B,WS_B,P)

arguments
    Config_A
    WS_A
    Config_B
    WS_B
    P.Start_Shift (1,1) {mustBeInteger,mustBeGreaterThan(P.Start_Shift,0)} = 1;
    P.Target_Shift (1,1) {mustBeInteger,mustBeGreaterThan(P.Target_Shift,0)} = 1;
end

% perimiyive function. should be more wisdem
GroupSizes_A = ConfigGroupSizes(WS_A.Space.Status,WS_A.Space.Type,WS_A.R1);
GroupSizes_B = ConfigGroupSizes(WS_B.Space.Status,WS_B.Space.Type,WS_B.R1);

% Config_A_Shift = [1;1];
% Config_B_Shift = [1;1];

Unify_GroupMatrix = max(numel(GroupSizes_A)+P.Start_Shift-1,numel(GroupSizes_B)+P.Target_Shift-1);

NewGroupSizes_A = zeros(Unify_GroupMatrix+2,1);
NewGroupSizes_A(P.Start_Shift+(1:numel(GroupSizes_A))) = GroupSizes_A;
Config_A.IsomorphismMatrices1{1} = NewGroupSizes_A;
Config_A{1,"IsomorphismStr1"} = join(string(Config_B.IsomorphismMatrices1{1}(:))',"");
Config_A{1,["IsoSiz1r","IsoSiz1c"]} = size(Config_B.IsomorphismMatrices1{1});
Config_A_Shift = [find(NewGroupSizes_A,1,"first")-1 ; numel(NewGroupSizes_A) - find(NewGroupSizes_A,1,"last")];

NewGroupSizes_B = zeros(Unify_GroupMatrix+2,1);
NewGroupSizes_B(P.Target_Shift+(1:numel(GroupSizes_B))) = GroupSizes_B;
Config_B.IsomorphismMatrices1{1} = NewGroupSizes_B;
Config_B{1,"IsomorphismStr1"} = join(string(Config_B.IsomorphismMatrices1{1}(:))',"");
Config_B{1,["IsoSiz1r","IsoSiz1c"]} = size(Config_B.IsomorphismMatrices1{1});
Config_B_Shift = [find(NewGroupSizes_B,1,"first")-1 ; numel(NewGroupSizes_B) - find(NewGroupSizes_B,1,"last")];
                  

% if size(GroupSizes_A,1) > size(GroupSizes_B,1)
% %     Config_B.IsomorphismMatrices1{1} = [Config_B.IsomorphismMatrices1{1}; zeros(size(GroupSizes_A,1)-size(GroupSizes_B,1),size(GroupSizes_B,2))];
%     Config_B.IsomorphismMatrices1{1} = [zeros(1,size(GroupSizes_B,2));Config_B.IsomorphismMatrices1{1}; zeros(size(GroupSizes_A,1)-size(GroupSizes_B,1)+1,size(GroupSizes_B,2))];
%     Config_B{1,"IsomorphismStr1"} = join(string(Config_B.IsomorphismMatrices1{1}(:))',"");
%     Config_B{1,["IsoSiz1r","IsoSiz1c"]} = size(Config_B.IsomorphismMatrices1{1});
%     Config_B_Shift = [                  1 ;...
%                       size(GroupSizes_A,1)-size(GroupSizes_B,1)+1];
% 
%     Config_A.IsomorphismMatrices1{1} = [zeros(1,size(GroupSizes_A,2)); Config_A.IsomorphismMatrices1{1};zeros(1,size(GroupSizes_A,2))];
%     Config_A{1,"IsomorphismStr1"} = join(string(Config_A.IsomorphismMatrices1{1}(:))',"");
%     Config_A{1,["IsoSiz1r","IsoSiz1c"]} = size(Config_A.IsomorphismMatrices1{1});
% else
% %     Config_A.IsomorphismMatrices1{1} = [Config_A.IsomorphismMatrices1{1}; zeros(size(GroupSizes_B,1)-size(GroupSizes_A,1),size(GroupSizes_A,2))];
%     Config_A.IsomorphismMatrices1{1} = [zeros(size(GroupSizes_B,1)-size(GroupSizes_A,1)+1,size(GroupSizes_A,2)); Config_A.IsomorphismMatrices1{1};zeros(1,size(GroupSizes_A,2))];
%     Config_A{1,"IsomorphismStr1"} = join(string(Config_A.IsomorphismMatrices1{1}(:))',"");
%     Config_A{1,["IsoSiz1r","IsoSiz1c"]} = size(Config_A.IsomorphismMatrices1{1});
% 
%     Config_A_Shift = [size(GroupSizes_B,1)-size(GroupSizes_A,1)+1;...
%                                         1                       ];
% 
%     Config_B.IsomorphismMatrices1{1} = [zeros(1,size(GroupSizes_B,2));Config_B.IsomorphismMatrices1{1}; zeros(1,size(GroupSizes_B,2))];
%     Config_B{1,"IsomorphismStr1"} = join(string(Config_B.IsomorphismMatrices1{1}(:))',"");
%     Config_B{1,["IsoSiz1r","IsoSiz1c"]} = size(Config_B.IsomorphismMatrices1{1});
% end
ConfigShift = [Config_A_Shift,Config_B_Shift];

end
