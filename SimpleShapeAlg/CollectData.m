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

%%
data(data.N==1,:) = [];
data.DL = data.DL+1;
save("SimpleShapeAlg\AllSolutions.mat","data");

%%
load("SimpleShapeAlg\AllSolutions.mat","data");
Path_N = accumarray([data.N,data.DL],data{:,"Path_N"}-data{:,"MoveTo"},[],@mean);
N = accumarray([data.N,data.DL],data.N,[],@mean);
DL = accumarray([data.N,data.DL],data.DL,[],@mean);
Path_N_STD = accumarray([data.N,data.DL],data{:,"Path_N"}-data{:,"MoveTo"},[],@std);
Path_N(all(~N,2),:) = [];
DL(all(~N,2),:) = [];
Path_N_STD(all(~N,2),:) = [];
N(all(~N,2),:) = [];
N = max(N,[],2);
DL = max(DL,[],1);
DL = DL-1;
N_Req = [100,300,500];
Color = [0,0.45,.74;  .85,.33,.1; .49,.18,.56]%.93,.69,.13;
for ii = 1:numel(N)
    
    if any(N(ii) == N_Req)
        p = Path_N(ii,Path_N(ii,:)~=0);
        s = Path_N_STD(ii,Path_N(ii,:)~=0);
        l = DL(1,Path_N(ii,:)~=0);

        plot(l,p,'Color',Color(N(ii) == N_Req,:));
        hold on
        lower_bound = p - 2*s;
        upper_bound = p + 2*s;
        fill([l'; flip(l)'], [upper_bound'; flip(lower_bound)'],Color(N(ii) == N_Req,:), 'FaceAlpha', 0.2,'EdgeColor','none');
    end
        
end

% save("SimpleShapeAlg\AllSolutions.mat","data","Resulte");
% surf(x,y,z);




