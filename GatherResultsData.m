clear
SoftwareLocation = 'C:\Users\shlom\OneDrive - Ariel University\Documents\לימודים\תואר שני\תזה\triangles';
% addpath(genpath(SoftwareLocation));
Folder = fullfile("AllTreeResulte");
fprintf("ds")
ds = fileDatastore(Folder,"IncludeSubfolders",false,"ReadFcn",@load,'UniformRead',true);
% 
% 

fprintf("readall");
data = readall(ds,"UseParallel", true);%,"UseParallel", true
Data = struct2table(data);
fprintf("save");
    
Data = [Data,table(string(extractBetween(ds.Files,"Results-","-tree","Boundaries","exclusive")),'variableNames',"TreeName"),...
    table(double(string(extractBetween(ds.Files,"Results-","N-","Boundaries","exclusive"))),'VariableNames',"N"),...
    table(string(extractBetween(ds.Files,"N-","-tree","Boundaries","exclusive")),'variableNames',"TreeType")];
M = table(ones(size(Data,1),1),'VariableNames',"M");
M(contains(Data.TreeName,"C2T"),"M")=table(double(extractAfter(Data.TreeName(contains(Data.TreeName,"C2T")),"_m")));
Data = [Data,M];
Data = [Data, table(Data.TreeType,'VariableNames',"type")];
Data.type(contains(Data.TreeName,"C2T")) = "C2T";

% p = anovan(Data.PathLength,{Data.N Data.M Data.type},'model','interaction','varnames',{'N','M','type'})
Data(abs(Data.PathLength)==1,:) = [];

save("AllData.mat","Data");
% load("AllData.mat","Data");

Names = unique(Data.TreeName);
VariableType = {'double','double','double','string'};
MeanData = table('Size',[numel(Names), 4],'VariableType',VariableType,'VariableNames',["NumberOfCOnfig","PathLength","N","name"])
stdData = MeanData;
for ii = 1:numel(Names)
    NameLoc=matches(Data.TreeName,Names(ii)) & double(extractBetween(Data.ResultFileName,"tree_",".mat"))<=200;
    MeanData(ii,:) = table(mean(Data{NameLoc,"NumberOfCOnfig"}),...
                              mean(Data{NameLoc,"PathLength"}),...
                              double(string(extractBefore(Names(ii),"N"))),...
                              string(extractAfter(Names(ii),"N-")),'RowNames',Names(ii));
    stdData(ii,:) = table(std(Data{NameLoc,"NumberOfCOnfig"}),...
                              std(Data{NameLoc,"PathLength"}),...
                              double(string(extractBefore(Names(ii),"N"))),...
                              string(extractAfter(Names(ii),"N-")),'RowNames',Names(ii));


end



%     ResultPloter(MeanData, "PathLength",unique(MeanData.name))

% ResultPloter(MeanData, "NumberOfCOnfig",MeanData.name)
% ResultPloter(MeanData, "NumberOfCOnfig",["TwoTree","C2T_m1","C2T_m3","C2T_m7","C2T_m15"])
% ResultPloter(MeanData, "PathLength",["TwoTree","C2T_m1","C2T_m3","C2T_m7","C2T_m15"])

figure('Name','Mean')
ResultPloter(MeanData, "PathLength",["uniform_1","uniform_3","normal_1"])
% figure('Name','std')
% ResultPloter(stdData, "PathLength",["uniform_1","uniform_3","normal_1"])

figure('Name','Mean')
ResultPloter(MeanData, "NumberOfCOnfig",["uniform_1","uniform_3","normal_1"])
% figure('Name','std')
% ResultPloter(stdData, "NumberOfCOnfig",["uniform_1","uniform_3","normal_1"])

figure('Name','Mean')
ResultPloter(MeanData, "PathLength",["TwoTree","uniform_1"])
% figure('Name','std')
% ResultPloter(stdData, "PathLength",["TwoTree","OneTree"])

figure('Name','Mean')
ResultPloter(MeanData, "NumberOfCOnfig",["TwoTree","uniform_1"])
% figure('Name','std')
% ResultPloter(stdData, "NumberOfCOnfig",["TwoTree","OneTree"])

figure('Name','Mean')
ResultPloter(MeanData, "PathLength",["TwoTree","OneTree"])
% figure('Name','std')
% ResultPloter(stdData, "PathLength",["TwoTree","OneTree"])

figure('Name','Mean')
ResultPloter(MeanData, "NumberOfCOnfig",["TwoTree","OneTree"])
