function AddDirToPath()
SoftwareLocation = pwd;
addpath(genpath(fullfile(SoftwareLocation,"AllTreeResulte")));
addpath(genpath(fullfile(SoftwareLocation,"configuration")));
addpath(genpath(fullfile(SoftwareLocation,"RRT")));
addpath(genpath(fullfile(SoftwareLocation,"simulation")));
addpath(genpath(fullfile(SoftwareLocation,"TreeEdit")));
addpath(genpath(fullfile(SoftwareLocation,"TreeFile")));
addpath(genpath(fullfile(SoftwareLocation,"CostFunction")));
addpath(genpath(fullfile(SoftwareLocation,"visual")));
addpath(genpath(fullfile(SoftwareLocation,"ZoneTopology")));
addpath(genpath(fullfile(SoftwareLocation,"GroupTopology")));

% copyfile("Users\shlom\OneDrive - Ariel University\Documents\לימודים\תואר שני\תזה\STRIMOR","New folder","f")
end
