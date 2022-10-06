function AddDirToPath()
SoftwareLocation = pwd;
addpath(genpath(fullfile(SoftwareLocation,"AllTreeResulte")));
addpath(genpath(fullfile(SoftwareLocation,"configuration")));
addpath(genpath(fullfile(SoftwareLocation,"RRT")));
addpath(genpath(fullfile(SoftwareLocation,"simulation")));
addpath(genpath(fullfile(SoftwareLocation,"TreeEdit")));
addpath(genpath(fullfile(SoftwareLocation,"TreeFile")));
addpath(genpath(fullfile(SoftwareLocation,"CostFunction")));
end
