function [Gradient, AgentDensity] = ObstacleGradient(AgentsPos,Range,Scale,Amplitude,MaxNumOfObstacleComputed)
AgentPos = permute(AgentsPos,[1,3,2]);
DistanceBeteenAgent = (AgentPos-pagetranspose(AgentPos));

ObstacleDistance = sum(DistanceBeteenAgent.^2,3);

ObstacleInsideZone = ~((ObstacleDistance > Range.^2)+eye(size(AgentsPos,1)));

AgentDensity = sum(ObstacleInsideZone,2)/(pi*Range^2);

if MaxNumOfObstacleComputed < max(sum(ObstacleInsideZone,2))
    [~,ObstacleSubInx] = sort(ObstacleDistance,2);
    ObstacleInd = sub2ind(size(ObstacleSubInx),(1:size(ObstacleSubInx,1))'.*ones(1,size(ObstacleSubInx,2)),ObstacleSubInx);
    
    ObstacleInsideZone(ObstacleInd(:,MaxNumOfObstacleComputed+2:end)) = false;
end

DistanceBeteenAgent(~(ObstacleInsideZone.*true(1,1,3))) = 1e3;


Sigma = 1./(AgentDensity);  
gaussian3d_base = exp(-sum(DistanceBeteenAgent.^2,3) ./ (2*Sigma.^2));

coeff = Amplitude * 100./ (2*pi*Sigma.^2);
Beta = coeff-(coeff .* gaussian3d_base);

d_Beta = - DistanceBeteenAgent.*Amplitude * 100./ (Sigma.^4*2*pi) .* gaussian3d_base;

G = - permute(sum((d_Beta./Beta),2)./prod(Beta,2),[1,3,2]);

Gradient = G./vecnorm(G')';

Gradient(isnan(Gradient)) = 0;

end
