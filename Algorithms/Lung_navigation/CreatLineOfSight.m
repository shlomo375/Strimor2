function [Lines, AngleMap, UnitVec] = CreatLineOfSight(P)
UnitVec=[];
Lines.FullSub=[];
Lines.FilterInd = [];

if mod(P.LineDensity,2)
    P.LineDensity = P.LineDensity +1;
end


[X,Y,Z] = sphere(P.ExpendDensity);
% R = permute(linspace(1,Radius,ExpendPointNumber),[1,4,2,3]);

UnitVecExpend(:,:,3) = Z(:,1:P.ExpendDensity/2);
UnitVecExpend(:,:,2) = Y(:,1:P.ExpendDensity/2);
UnitVecExpend(:,:,1) = X(:,1:P.ExpendDensity/2);

UnitVecExpend = unique(reshape(UnitVecExpend,[],3),"rows","stable");



[X,Y,Z] = sphere(P.LineDensity);
R = permute(linspace(1,P.LineLength,1.5*P.LineLength),[1,4,2,3]);

UnitVec(:,:,3) = Z(:,1:P.LineDensity/2);
UnitVec(:,:,2) = Y(:,1:P.LineDensity/2);
UnitVec(:,:,1) = X(:,1:P.LineDensity/2);

UnitVec = cat(1,unique(reshape(UnitVec,[],3),"rows","stable"),UnitVecExpend);



UnitVecSub = [UnitVec(:,2), UnitVec(:,1), UnitVec(:,3)];
Lines.FullSub(:,:,:,2) = -UnitVecSub.*R;
Lines.FullSub(:,:,:,1) = UnitVecSub.*R;

% Lines = permute(Lines,[1,2,4,5,3]);

%Lines = reshape(Lines,[],size(Lines,3),size(Lines,4),size(Lines,5)); % (Line,Coordinate,PointInLine,HalfLine);

% UnitVecList = permute(reshape(UnitVec,[],1,3),[3,1,2]);
OrthogonalVectors = UnitVec*UnitVec';
[~, SortedLoc] = sort(abs(OrthogonalVectors));

% OrthogonalVectorsInd = sub2ind(size(OrthogonalVectors),SortedLoc(1:Density/2,:),(1:size(OrthogonalVectors,1)).*ones(Density/2,1))
AngleMap = [(1:size(OrthogonalVectors,1))',SortedLoc(1:P.LineDensity/2,:)'];





% [X,Y,Z] = sphere(ExpendDensity);
% % R = permute(linspace(1,Radius,ExpendPointNumber),[1,4,2,3]);
% 
% UnitVecExpend(:,:,3) = Z(:,1:ExpendDensity/2);
% UnitVecExpend(:,:,2) = Y(:,1:ExpendDensity/2);
% UnitVecExpend(:,:,1) = X(:,1:ExpendDensity/2);
% 
% UnitVecExpend = unique(reshape(UnitVecExpend,[],3),"rows","stable");
% UnitVecSub = [UnitVecExpend(:,2), UnitVecExpend(:,1), UnitVecExpend(:,3)];
% 
% Lines.FullSub = cat(4,cat(1,Lines.FullSub(:,:,:,1),UnitVecSub.*R),cat(1,Lines.FullSub(:,:,:,2),-UnitVecSub.*R));

Lines.FilterInd = false(size(Lines.FullSub,1),1,size(Lines.FullSub,3),size(Lines.FullSub,4));
% Lines.FilterInd = Temp;
DeleteLinePoint = P.SaveEachPointInLine:P.SaveEachPointInLine:size(Lines.FilterInd,3);
Lines.FilterInd(end-size(UnitVecExpend,1)+1:end,:,DeleteLinePoint,:) = true;

end
