function [PathLength, Path] = Get2TreesPath(StartDS,TargetDS, ConnectedNode)

try
[OK, PathFromStart] = Scanner(StartDS,ConnectedNode,"Path");
    
[OK2, PathFromTarget] = Scanner(TargetDS,ConnectedNode,"FlipAndPath");
catch ME5
    d=5
end
Path = [PathFromTarget(1:end-1,:); PathFromStart];

PathLength = size(Path,1);

if ~OK || ~OK2
    PathLength = -1;
end


end
