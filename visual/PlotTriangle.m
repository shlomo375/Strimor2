function [p, t] = PlotTriangle(CenterLoc, Type, ColorIndex, Text, p, t)
TriangleCoordinate = zeros(3,size(CenterLoc,1),2);

down = (Type==1);
down = down(:);
up = ~down;
CenterLoc(:,2) = sqrt(3)*CenterLoc(:,2);

TriangleCoordinate(:,down',1) = [-1;1;0] + CenterLoc(down,1)';
TriangleCoordinate(:,down',2) = [-sqrt(3)/2; -sqrt(3)/2; sqrt(3)/2] + CenterLoc(down,2)';

TriangleCoordinate(:,up',1) = [-1;0;1] + CenterLoc(up,1)';
TriangleCoordinate(:,up',2) = [sqrt(3)/2; -sqrt(3)/2; sqrt(3)/2] + CenterLoc(up,2)';

Color = reshape(WorkSpace.Colors(ColorIndex),[size(ColorIndex,1),1,3]);
if nargin > 4
    set(p,'XData',TriangleCoordinate(:,:,1),'YData',TriangleCoordinate(:,:,2),'CData',Color);
%     p = patch(TriangleCoordinate(:,:,1),TriangleCoordinate(:,:,2),Color, p);
else
    p = patch(TriangleCoordinate(:,:,1),TriangleCoordinate(:,:,2),Color);
if nargin>3
    t = text(CenterLoc(:,1),CenterLoc(:,2),num2str(Text),'FontSize',7,'HorizontalAlignment','center');
end

axis equal;
end
