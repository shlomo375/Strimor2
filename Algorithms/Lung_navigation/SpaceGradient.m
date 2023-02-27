function [Gradient, IntensityRange, NewAgentInd, NewAgent,SumOfMean] = SpaceGradient(Space,ScannedSpace,ZoneInd,SumOfMean,Itr,AA)
% Space(ScannedSpace ~= 0) = 1;

% ZoneRange = (size(ZoneInd,1)-1)/2;
AgentAreaValues = Space(ZoneInd);

% MeanAgentArea = mean(AgentAreaValues,[1,2,3]);
% SumOfMean = SumOfMean + MeanAgentArea;
% TotalMean = SumOfMean/Itr
% StdAgentArea = std(AgentAreaValues,1,[1,2,3]);

Corners = true(3,3,3,size(AgentAreaValues,4));
Corners(2,:,2,:) = false;
Corners(:,2,2,:) = false;
Corners(2,2,[1,3],:) = false;

AgentAreaValues = AgentAreaValues.* ~ScannedSpace(ZoneInd) + 100.* ScannedSpace(ZoneInd);
AgentAreaValues(Corners) = 100;

IntensityRange = permute(max(AgentAreaValues,[],[1,2,3])-min(AgentAreaValues,[],[1,2,3]),[4,1,2,3]);

% [dx,dy,dz] = gradient(AgentAreaValues);
% G = -[permute(dx(ZoneRange+1,ZoneRange+1,ZoneRange+1,:),[4,1,2,3]),...
%     permute(dy(ZoneRange+1,ZoneRange+1,ZoneRange+1,:),[4,1,2,3]),...
%     permute(dz(ZoneRange+1,ZoneRange+1,ZoneRange+1,:),[4,1,2,3])];
% 
% Gradient = G./vecnorm(G')';
% 
% Gradient(isnan(Gradient)) = 0;
% [~,I] = min(AgentAreaValues,[],[1,2,3],"linear")
NewAgentInd = unique(ZoneInd(AgentAreaValues<0.02));
% NewAgentInd = unique(ZoneInd(AgentAreaValues < MeanAgentArea-0.5*StdAgentArea));

[NewAgent(:,2),NewAgent(:,1),NewAgent(:,3)] = ind2sub(size(Space),NewAgentInd);


end
