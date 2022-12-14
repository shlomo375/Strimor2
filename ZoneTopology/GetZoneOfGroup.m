function GroupZone = GetZoneOfGroup(ZoneLoc,GroupIndex)
if isempty(ZoneLoc)
    GroupZone = 1;
    return
end
GroupStartLoc = ZoneLoc + 2;
GroupStartLocFiltered = GroupStartLoc(~[diff(GroupStartLoc) == 2,0]);

ZoneLocFiltered = ZoneLoc(~[0, diff(ZoneLoc) == 2]);
GroupZone = find(any(GroupIndex < ZoneLocFiltered',2),1);

if isempty(GroupZone)
    GroupZone = numel(ZoneLocFiltered)+1;
end

if GroupZone ~=1
    if ~any(GroupIndex >= GroupStartLocFiltered(GroupZone-1)')
        GroupZone = inf;
    end
end
end
