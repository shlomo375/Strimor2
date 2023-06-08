function [BaseGroupNum, BaseGroupInd] = GetBasedGroup(WS,BaseGroupsInds,GroupInd)

OptionalBaseGroupInd = GroupInd(WS.Space.Type(GroupInd)==1) - 1;

BaseGroupInd = OptionalBaseGroupInd(WS.Space.Status(OptionalBaseGroupInd)>0);

RightBaseGroup = max(BaseGroupInd);
LeftBaseGroup = min(BaseGroupInd);

BaseGroupNum = 0;
for num = 1:numel(BaseGroupsInds)
    if any(BaseGroupsInds{num} == LeftBaseGroup)
        BaseGroupNum = num;
        break
    end
end

if numel(BaseGroupsInds)>1
    MaxBaseGroupNum = 0;
    for num = numel(BaseGroupsInds):-1:1
        if any(BaseGroupsInds{num} == RightBaseGroup)
            MaxBaseGroupNum = num;
            break
        end
    end
    BaseGroupNum = [BaseGroupNum, MaxBaseGroupNum];
end

end
