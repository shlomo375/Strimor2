% Lung navigation
%
% created by: shlomo odem
%               6/12/22
%%
% clear
close all
Param = CreatParamStruct();
ParentPoint = [];


Tree.Data = zeros(1e5,Param.MatrixSize(2));
Tree.LastIndex = 1;
Tree.Scan = [];

[Lines, AngleMap, UnitVecList] = CreatLineOfSight(Param);

LungFolder = fullfile("D:\DICOM","Lung1");
[Lung,Property] = dicomreadVolume(LungFolder);
Lung = squeeze(Lung);
TargetSliceNum = 523- 159;

Volume = ShowValume(Lung);


Space = mat2gray(Lung, ...
    double([min(Lung,[],"all"),max(Lung,[],"all")]));
Param.SapceSize = size(Space);
ScannedSpace.Full = false(size(Space));
ScannedSpace.Scan = false(size(Space));
% ScannedSpace([1:2,end-1:end],:,:) = true;
% ScannedSpace(:,[1:2,end-1:end],:) = true;
% ScannedSpace(:,:,[1:2,end-1:end]) = true;
% s=sum(ScannedSpace,"all");


PointCoord = [264,318,3];% + 2*rand(1,3)-1;

% TargetCoord = SetAgentAtStart(Space,TargetSliceNum);
TargetCoord = [200  230  280];
[Volume,ScannedSpace.Full] = PlotTarget(Volume,ScannedSpace.Full,TargetCoord,Param.TargetSize);

Point = PointInfo(Param, size(Space), xyz2ind(size(Space), PointCoord),TargetCoord);

Tree.Data(1,:) = Point;
ScannedSpace.Full(Point(Param.Ind)) = true;


Volume = ShowValume(ScannedSpace.Full,Volume);


tic
try

    % Air duct tracking
for Itr =1:1e5
%     Point = CrossingBorder(Space,Point);
    
    [NewPointsInd, Point] = AgentLineOfSight(Param, Space, Point,Lines, AngleMap, UnitVecList);
    
    if(CheckPointIntegrity(Param, Point, ParentPoint)) && ~isempty(NewPointsInd.Ind)
        NewPointsTable = PointInfo(Param, size(Space), NewPointsInd.Ind, TargetCoord, Point);

        Tree = UpdateTree(Param, Tree, Point, NewPointsTable); 
        
        [Tree, ScannedSpace] = UpdateScanList(Param, Tree, ScannedSpace, NewPointsTable, NewPointsInd);

    end
    
    Tree.Scan = RemoveScannedPoint(Param, Tree.Scan, Point);
%     Tree.Scan(Tree.Scan(:,Param.Ind) == Point(1,Param.Ind),:) = [];

    
    if ExistTerms(Param,Tree)
        toc
        break
    end
    
    

    [Point, ParentPoint] = SelectPointToScan(Param, Tree);
    
toc
    disp({"Itr: "+string(Itr),"LastIndex: "+ string(Tree.LastIndex), "Scan: "+string(size(Tree.Scan,1))})
%     if ~mod(Itr,15)
%         toc
%         
%         Volume = ShowValume(ScannedSpace.Scan,Volume);
% %         [Path, PathCost] = BestPath(Param,Tree,ScannedSpace.Full,Volume);
%         Itr
% 
%     end

    
end
catch ME
    ME
end
toc
