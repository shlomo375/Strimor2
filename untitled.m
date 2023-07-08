N =1000
AddDirToPath
 BasicWS = WorkSpace([N,N*2],"RRT*");
load("SimpleShapeAlg\Shapes\S2Arrow.mat","Tree")

Path2Video(Tree.Data,4,"SimpleShapeAlg\Media\ObstacleVideo\S2Arrow",BasicWS)