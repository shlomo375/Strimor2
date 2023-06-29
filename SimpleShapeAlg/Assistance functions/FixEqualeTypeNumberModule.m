function WS = FixEqualeTypeNumberModule(WS,Ops)
arguments
    WS
    Ops = 'none'
end

[GroupsSizes,~,GroupInd] = ConfigGroupSizes_Axis1Only(WS.Space.Status,WS.Space.Type);

GroupsSizes(~mod(GroupsSizes,2)) = 0;
GroupsSizes(GroupsSizes>0) = 1;
GroupsSizes(GroupsSizes<0) = -1;

diffType = sum(GroupsSizes);

if diffType~=0
    deleteEdge = find(GroupsSizes==sign(diffType),abs(diffType));
    for row = deleteEdge
        WS.Space.Status(GroupInd{row}{1}(1)) = 0;
        if matches(Ops,'same')
            [R,C] = ind2sub(WS.SpaceSize,GroupInd{row}{1}(end));
            AddInd = sub2ind(WS.SpaceSize,R,C+1);
            WS.Space.Status(AddInd) = 1;
        end
    end
end



end

