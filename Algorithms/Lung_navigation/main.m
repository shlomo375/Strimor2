% Lung navigation
%
% created by: shlomo odem
%               6/12/22
%%
clear
close all
NumIter = 50;
ObstacleSearchArea = 2;
Threshold = 0.03;
StepSize = 0.3;
StartSliceNum = 133;

LungFolder = fullfile("D:\DICOM","Lung1");
[Lung,Property] = dicomreadVolume(LungFolder);
Lung = squeeze(Lung);

Map=mat2gray(Lung(:,:,StartSliceNum), ...
    double([min(Lung(:,:,StartSliceNum),[],"all"),max(Lung(:,:,StartSliceNum),[],"all")]));
imshow(Map,[]);
pause
hold on;
[x,y] = ginput(1);
plot(x,y,"o");
pause

% Determining the order of displaying the images
[~,ScanerAxis,value] = find(diff(Property.PatientPositions(1:2,:),1));
ScanerDirection = sign(value);
if ScanerDirection>0 && Property.PatientPositions(1,ScanerAxis)>0 || ScanerDirection<0 && Property.PatientPositions(1,ScanerAxis)<0
    
    SliceRange = StartSliceNum:-1:1;
else 
    SliceRange = StartSliceNum:size(Lung,3);
    
end
tic
% Air duct tracking
for idx_Slice = SliceRange
    Map = mat2gray(Lung(:,:,idx_Slice), ...
        double([min(Lung(:,:,idx_Slice),[],"all"),max(Lung(:,:,idx_Slice),[],"all")]));
    figure(1)
    imshow(Map,[]);
    
    % Optimization for point location
    for iter = 1:NumIter
        [~, Angle,gaussian_map] = PotentialField(x,y,double(Map),ObstacleSearchArea,Threshold);

        x = x + StepSize*cos(Angle);
        y = y + StepSize*sin(Angle);

        figure(1)
        plot(x,y,".r");
        hold on
%         pause(0.05)
    end
plot(x,y,".r");
        hold on
% Saving the position of the point
    Path(idx_Slice,1:3) = [x,y,Property.PatientPositions(idx_Slice,ScanerAxis)];
    pause(0.1)
end
toc