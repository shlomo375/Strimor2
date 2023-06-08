clear
SoftwareLocation = pwd;
addpath(genpath(SoftwareLocation));

N = 100;
Persentege = 0.05:0.05:0.5;


for Percent = Persentege
    BasicWS = WorkSpace([N,N*2],"RRT*");
    load(strcat("configuration\LargeConfigs\N",string(N),".mat"),"ConfigCellArray");
    fprintf("ModuleNUm: %d\n",N);
    for ConfigNum = 1:5000%numel(ConfigCellArray)
        WS = SetConfigurationOnSpace(BasicWS,ConfigCellArray{ConfigNum});
        %
%          f = figure(665);
%         f.Position = [1921,265,1536,739];
%         cla
%         PlotWorkSpace(WS,"Plot_CellInd",true);
        %
        [Config, NewWS] = Holl_Creator(WS,Percent);
        %
%          f = figure(666);
%         f.Position = [1921,265,1536,739];
%         cla
%         PlotWorkSpace(NewWS,"Plot_CellInd",true);   
        %
        ConfigCellArray{ConfigNum} = Config;
        if ~mod(ConfigNum,100)
            fprintf("ConfigNum: %d, Percent: %d\n",ConfigNum,Percent);
        end
    end
    fprintf("save ModuleNUm: %d\n",N);
    save(strcat("configuration\LargeConfigs\N_",string(N),"_P_",string(Percent),".mat"),"ConfigCellArray");
end

function [Config, NewWS] = Holl_Creator(WS,Percent)

arguments
    WS
    Percent (1,1) {mustBeNonnegative,mustBeInRange(Percent,0,1)} = 0
end
N = sum(WS.Space.Status,'all');
TotalShiftedModule = ceil(N*Percent);
AlphaShifted = ceil(TotalShiftedModule/2);
BetaShifted = floor(TotalShiftedModule/2);
%%
Alpha = 0;
Beta = 0;
while (Alpha<AlphaShifted) || (Beta<BetaShifted)
    type = randi(2,1);
    switch type
        case 1
            if Alpha<AlphaShifted
                [WS,Sucsses] = AddAgent(WS,-1);
                if Sucsses
                    Alpha = Alpha+1;
                end
            end
            
        case 2
            if Beta<BetaShifted
                [WS,Sucsses] = AddAgent(WS,1);
                if Sucsses
                    Beta = Beta+1;
                end
                
            end     
    end
end
%%

while true
    NewWS = RemoveAgent(WS,1,AlphaShifted);
    NewWS = RemoveAgent(NewWS,-1,BetaShifted);

    ScannedAgent = ~NewWS.Space.Status;
    StartModule = find(NewWS.Space.Status,1);
    [~, BranchModulesInd] = ScanningAgentsFast(NewWS, ScannedAgent, StartModule,true);
    if numel(BranchModulesInd)==N
        break
    end

end
Config = GetConfiguration(NewWS);
end
