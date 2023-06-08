function WorkZoneInd = Get_WorkZone(WS,BranchModulesInd)
WorkZoneCol = [-3,-2,-1,0,1,2,3];
WorkZoneRow = zeros(1,7);
R = {WS.R1, WS.R2, WS.R3};

WorkZoneInd = [];
for Axis = 1:numel(R)
    [Row,Col] = ind2sub(size(R{Axis}),find(ismember(R{Axis},BranchModulesInd),numel(BranchModulesInd)));

    ZoneIndInR = sub2ind(size(R{Axis}),Row+WorkZoneRow,Col+WorkZoneCol);
    WorkZoneInd = [WorkZoneInd;R{Axis}(ZoneIndInR(:))];
end

WorkZoneInd = unique(WorkZoneInd);

end
