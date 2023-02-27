function Stop = ExistTerms(P,Tree)
Stop = true;

%% The whole tree was scanned
if isempty(Tree.Scan)
    return
end

%% Each new point has a higher cost than the shortest route found
[~,BestCostLoc] = min(Tree.Data(1:Tree.LastIndex,P.Cost));
% if ~any(Tree.Scan(:,3) < Tree.Data(BestCostLoc,P.PathLength))
%     return
% end

if Tree.Data(BestCostLoc,P.TargetDis) < P.MinDistanceRequiredFromTarget
    return
end

% ScannedPoint = Tree.Data(:,P.Diameter)>0;
% Loc = find(Tree.Data(:,P.Diameter)>0);
% [~,BestCostLoc] = min(Tree.Data(Loc,P.Cost));
% if Tree.Data(Loc(BestCostLoc),P.Diameter) <=3 && Tree.Data(Loc(BestCostLoc),P.Diameter)>0
% 
%     return
% end
    Stop = false;
end
