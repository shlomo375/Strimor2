function [G,theta,gaussian_map] = PotentialField(x,y,Map,ObstacleZoneRange,Threshold)

% [X,Y] = meshgrid(1:size(Map,2),1:size(Map,1));
X = x;
Y=y;
% Defining the obstacle search area
Space = Map(floor(y-ObstacleZoneRange):ceil(y+ObstacleZoneRange),floor(x-ObstacleZoneRange):ceil(x+ObstacleZoneRange));
[Obstacle_y,Obstacle_x] = find(Space>Threshold);
Obstacle_y = floor(y-ObstacleZoneRange)-1 + Obstacle_y;
Obstacle_x = floor(x-ObstacleZoneRange)-1 + Obstacle_x;

% Gaussian calculation and derivatives
[gaussian_map, dx, dy ] = gaussian2d(X,Y, [Obstacle_x,Obstacle_y], 3);

% gradient and angle
Gradient = sqrt(dx.^2+dy.^2);
thetaMat = atan2(dy,dx);

if numel(X)==1
    G = Gradient;
    theta = thetaMat+pi;
else
    G = Gradient(round(x),round(y));
    theta = thetaMat(round(y),round(x))+pi;
end

% figure(22)
% contour(gaussian_map);
% hold on
% % plot(Agent_x,Agent_y,"*b");
% plot(x,y,"*r");
% for ii=1:numel(Obstacle_y)
%     plot(Obstacle_x(ii),Obstacle_y(ii),"*b");
% end
% r=0:0.1:1;
% xx=x+r*cos(theta);
% yy=y+r*sin(theta);
% plot(xx,yy,".g")
% hold off
% pause