function [p, t,MoveNumText] = PlotTriangle(CenterLoc, Type, ColorIndex, Text, p, t,MoveNumText)
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

% axis equal;
% xlim([min(TriangleCoordinate(:,:,1),[],"all")-1,max(TriangleCoordinate(:,:,1),[],"all")+1]);
% ylim([min(TriangleCoordinate(:,:,2),[],"all")-1,max(TriangleCoordinate(:,:,2),[],"all")+1]);

if ~isempty(p)
    set(p,'XData',TriangleCoordinate(:,:,1),'YData',TriangleCoordinate(:,:,2),'CData',Color);
%     p = patch(TriangleCoordinate(:,:,1),TriangleCoordinate(:,:,2),Color, p);
    
else
    cla
    p = patch(TriangleCoordinate(:,:,1),TriangleCoordinate(:,:,2),Color,"LineWidth",1);
    if ~isempty(MoveNumText)
        MoveNumText.handel = text(MoveNumText.x,MoveNumText.y,num2str(MoveNumText.value),'FontSize',22,'FontWeight','bold','HorizontalAlignment','center');

    end
end
if ~isempty(MoveNumText)
    set(MoveNumText.handel,"Position",[MoveNumText.x,MoveNumText.y],"string",num2str(MoveNumText.value));
end
if ~isempty(Text)
    t = text(CenterLoc(:,1),CenterLoc(:,2),num2str(Text),'FontSize',9,'HorizontalAlignment','center');
end

set(gca, 'Visible', 'off')
end
