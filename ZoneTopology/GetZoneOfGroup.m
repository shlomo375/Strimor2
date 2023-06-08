function GroupZone = GetZoneOfGroup(ZoneLoc,GroupIndex)
if isempty(ZoneLoc)
    GroupZone = 1;
    return
end
GroupStartLoc = ZoneLoc + 2;
GroupStartLocFiltered = GroupStartLoc(~[diff(GroupStartLoc) == 2,0]);

ZoneLocFiltered = ZoneLoc(~[0, diff(ZoneLoc) == 2]);
% if any(ZoneLocFiltered==1)
%     ZoneLocFiltered(ZoneLocFiltered==1) = [];
%     flag=true;
% else
%     flag=false;
% end
GroupZone = find(all(GroupIndex >= ZoneLocFiltered',2),1,"last");

if isempty(GroupZone) % above the first hole or line without holl in the start  
    GroupZone = 1;
else 
    if all(GroupIndex < GroupStartLocFiltered(find(GroupStartLocFiltered>ZoneLocFiltered(GroupZone),1))')
        GroupZone = inf;
    else
        if ZoneLocFiltered(1) > 2
            GroupZone = GroupZone + 1;
        end
    end
end

% if flag
%     if ~any(GroupIndex >= GroupStartLocFiltered(GroupZone)')
%         GroupZone = inf;
%     end
% end

end
