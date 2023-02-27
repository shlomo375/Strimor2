function [Agents, Step] = MoveAgents(Agents, ObstacleGradient, SpaceGradient, Ratio, StepSize)

Step = StepSize .* (Ratio*ObstacleGradient + (1-Ratio)*SpaceGradient);

Agents = Agents + Step;
end
