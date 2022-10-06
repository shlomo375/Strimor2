% clear
SoftwareLocation = 'C:\Users\shlom\OneDrive - Ariel University\Documents\לימודים\תואר שני\תזה\triangles';
% addpath(genpath(SoftwareLocation));
Folder = fullfile("AllTreeResulte/TimeLog");
% 
% ds = fileDatastore(Folder,"IncludeSubfolders",false,"ReadFcn",@load,'UniformRead',true);
% 
% data = readall(ds,"UseParallel",true);
% Data = struct2table(data);
% filteredData = table()
% 
% while ~isempty(Data)
%     TreeName = extractBefore(Data.JobName(1),"_TimeLog");
%     TreeLoc = contains(Data.JobName,TreeName);
%     Time = Data.JobTime(TreeLoc);
%     Names = Data.JobName(TreeLoc);
%     [MaxTime,MaxTimeLoc] = max(Time);
%     TreeName = Names(MaxTimeLoc)
% 
%     deleteTree = Names(~matches(Names,TreeName));
%     for delete_idx = 1:numel(deleteTree)
%         delete(fullfile(SoftwareLocation,"AllTreeResulte","TimeLog",deleteTree(delete_idx)));
%     end
%     filteredData(end+1,:) = table(TreeName,MaxTime);
%     Data(TreeLoc,:)=[];
% end

% save("AllTimeData.mat","filteredData");
load("AllTimeData.mat","filteredData")
Data = filteredData;
Names = unique(extractBefore(Data.TreeName,"_tree"));
% Names = unique(Data.TreeName);
VariableType = {'duration','double','string'};
MeanData = table('Size',[numel(Names), 3],'VariableType',VariableType,'VariableNames',["time","N","name"])
stdData = MeanData;
for ii = 1:numel(Names)
    NameLoc=contains(Data.TreeName,Names(ii)) & double(extractBetween(Data.TreeName,"tree_","_Time"))<=50;
    MeanData(ii,:) = table(mean(Data{NameLoc,"MaxTime"}),...
                              double(string(extractBefore(Names(ii),"N"))),...
                              string(extractAfter(Names(ii),"N_")),'RowNames',Names(ii));
    stdData(ii,:) = table(std(Data{NameLoc,"MaxTime"}),...
                              double(string(extractBefore(Names(ii),"N"))),...
                              string(extractAfter(Names(ii),"N_")),'RowNames',Names(ii));


end

figure('Name','Mean')
ResultPloter(MeanData, "time",["uniform_1","uniform_3","normal_1"])