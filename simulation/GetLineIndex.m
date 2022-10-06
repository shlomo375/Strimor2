function LineIndex = GetLineIndex(Agent,Center,Map)
lineEq_y = @(x,Alpha,p)(tan(Alpha).*(x-p.x)+p.y);
LineCrossX = @(p1,Alpha1,p2,Alpha2)...
    (((tan(Alpha1).*p1.x-tan(Alpha2).*p2.x)-(p1.y-p2.y))./(tan(Alpha1)-tan(Alpha2)));
dis = @(p1,x,y)(sqrt((p1.x-x).^2+(p1.y-y).^2));
if 1%Center.type
    LineIndex(1) = -(Agent.x - Center.x);
    TempAgent = Agent;
    TempAgent.x = Agent.x - (Agent.Type==1)/2 + (Agent.Type~=1)/2
    TempCenter = Center;
    TempCenter.x = Center.x - (Center.Type==1)/2 + (Center.Type~=1)/2
    y2 = LineCrossX(TempCenter,deg2rad(30),TempAgent,deg2rad(-60));
    x2 = lineEq_y(y2,deg2rad(30),TempCenter);
    d = dis(TempCenter,x2,y2);
    %LineIndex(2) = 


end
