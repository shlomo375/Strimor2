%% Collect simple Shape DATA

Folder = fullfile("SimpleShapeAlg/Solutions");
Files = dir(Folder);
Files([Files.isdir]==1)=[];

Problems = [];

varName = ["Path_N","N","DL","Alpha_Alpha" ...
"Alpha_Beta" ...
"Beta_Alpha" ...
"Beta_Beta" ...
"Create_Alpha_Alpha" ...
"Create_Alpha_Beta" ...
"Create_Beta_Beta" ...
"MoveTo" ...
"Switch"];
varType = ["double","double","double","double","double","double","double","double","double","double","double","double"];
data = table('size',[numel(Files),size(varName,2)],'VariableNames',varName,'VariableTypes',varType);
for idx = 1:numel(Files)
    load(fullfile(Files(idx).folder,Files(idx).name),"Solution","ErrorProblem");
    idx
    if ~istable(Solution{1})
        data{idx,"N"} = 1;
        Problems{idx} = ErrorProblem{end};
        % delete(fullfile(Files(idx).folder,Files(idx).name));
       continue 
    end
    Path = Solution{1};
    data.N(idx) = nnz(Path.ConfigMat{1});
    data.Path_N(idx) = size(Path,1);
    data.DL(idx) = abs(Path.ConfigRow(1)-Path.ConfigRow(end));

    Path.Manuver(1) = "";
    % Find unique groups
    uniqueGroups = unique(Path.Manuver);
    
    % Find the indices of each group
    [~, groupIndices] = ismember(Path.Manuver, uniqueGroups);
    
    % Accumulate data based on groups
    aggregatedData = splitapply(@(x) numel(unique(x)), Path.Manuver_num, groupIndices);
    
    data{idx,uniqueGroups(2:end)} = aggregatedData(2:end)';

end
save("SimpleShapeAlg\AllSolutions.mat","data");

%%
data.N(data.N==-1) = 1;
data.DL = data.DL+1;

Path_N = accumarray([data.N,data.DL],data{:,"Path_N"}-data{:,"MoveTo"},[],@mean);
N = accumarray([data.N,data.DL],data.N,[],@mean);
DL = accumarray([data.N,data.DL],data.DL,[],@mean);
Resulte = cat(3,N,DL,Path_N);
Resulte(all(~Resulte(:,:,1),2),:,:) = [];
Resulte(Resulte(:,1,1)==1,:,:) = [];
x = Resulte(:,:,1);
y = Resulte(:,:,2);
z = Resulte(:,:,3);

save("SimpleShapeAlg\AllSolutions.mat","data","Resulte");
surf(x,y,z);




