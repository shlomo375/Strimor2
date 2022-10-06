%% simple RRT

close all
ss = stateSpaceSE2;
sv = validatorOccupancyMap(ss);
load exampleMaps
% map = occupancyMap(simpleMap,10);
map = occupancyMap(emptyMap,10);
sv.Map = map;

sv.ValidationDistance = 0.001;
ss.StateBounds = [[0,10];[0,10]; [-pi pi]];
planner = plannerRRT(ss,sv);
planner.MaxConnectionDistance = 1;
planner.GoalBias = 0.000001;
start = [.5,.5,0];
goal = [5,2,0];

rng(100,'twister'); % for repeatable result


% show(map)
figure
planner.MaxIterations = 1000;
[pthObj,solnInfo] = plan(planner,start,goal);
plot(solnInfo.TreeData(:,1),solnInfo.TreeData(:,2),'.-'); % tree expansion

figure
planner.MaxIterations = 10000;
rng(100,'twister'); % for repeatable result
[pthObj,solnInfo] = plan(planner,start,goal);
plot(solnInfo.TreeData(:,1),solnInfo.TreeData(:,2),'.-'); % tree expansion

figure
planner.MaxIterations = 100000;
rng(100,'twister'); % for repeatable result
[pthObj,solnInfo] = plan(planner,start,goal);
plot(solnInfo.TreeData(:,1),solnInfo.TreeData(:,2),'.-'); % tree expansion

