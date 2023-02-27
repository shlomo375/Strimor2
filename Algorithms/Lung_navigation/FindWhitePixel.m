function [FirstWhitePixel,NewAgent, LinesInd] = FindWhitePixel(Space,LinesSub,LineFilterLogical,Threshold)

DeletePoint = @(L,S) any(L <= 0,2) | any(L > size(S,[2,1,3]),2);

LinesNagetive = DeletePoint(LinesSub,Space);

LinesSub(repmat(LinesNagetive,1,3,1,1)) = 1;

LinesInd = sub2ind(size(Space),LinesSub(:,1,:,:,:),LinesSub(:,2,:,:,:),LinesSub(:,3,:,:,:));

LinesValue = Space(LinesInd);
LinesValue(LinesNagetive) = 1e2;

WhitePixelLoc = LinesValue > Threshold;

% NewAgentInd = LinesInd(~cumsum(WhitePixelLoc,3));
NewAgentLogical = ~cumsum(WhitePixelLoc,3);
NewAgent.Ind = unique(LinesInd(NewAgentLogical));
NewAgent.IndFiltered = unique(LinesInd(NewAgentLogical & LineFilterLogical));

[~,FirstWhitePixel] = max(WhitePixelLoc,[],3);

% ClearLineLength = sum(FirstWhitePixel,4)-2;
% 
% [PointVecMagnitude,LineIdx] = max(permute(ClearLineLength,[5,1,2,3,4]),[],2);
% LinesInd(~(NewAgentLogical & LineFilterLogical)) = 0;
% EdgePointInd = find(LinesInd(LineIdx,1,:,:),1,"last");
% find(NewPointsLogical(LineIdx,1,:,:),1,"last")
end
