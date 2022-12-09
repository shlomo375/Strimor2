function [NumberOfCOnfig, PathLength, Path, time] = ExtructPathFromTrees(Tree1,Tree2,ConnectedNode1,ConnectedNode2)
Path = [];
time = max(ConnectedNode1.time,ConnectedNode2.time);

Tree1.Data(Tree1.LastIndex+1:end,:) = [];
Tree1.Data(Tree1.Data.time>time,:) = [];

NumberOfCOnfig = size(Tree1.Data,1);

Tree2.Data(Tree2.LastIndex+1:end,:) = [];
Tree2.Data(Tree2.Data.time>time,:) = [];

NumberOfCOnfig = NumberOfCOnfig + size(Tree2.Data,1);

try
[OK, PathFromStart, PathLengthStart] = ScannerIsomorphism(Tree1,ConnectedNode1,"Path",Tree1.NumOfIsomorphismAxis);
            
[OK2, PathFromTarget, PathLengthTarget] = ScannerIsomorphism(Tree2,ConnectedNode2,"FlipAndPath",Tree2.NumOfIsomorphismAxis);


if ~OK2 || ~OK
    error
end
catch eee
    eee
end
Path = [PathFromTarget(1:end-1,:); PathFromStart];

PathLength = size(Path,1);

end
