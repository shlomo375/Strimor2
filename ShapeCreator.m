clear
SoftwareLocation = pwd;
addpath(genpath(SoftwareLocation));

PairsNum = 2;
Stock = [];
ConfigPairs = [];
AgentNum = 100;
MaxConfigNum = 50000;


for N = AgentNum
    WS = WorkSpace([N,N*2],"RRT*");
    ConfigCellArray = cell(MaxConfigNum,1);
    fprintf("ModuleNUm: %d\n",N);
    for ConfigNum = 1:MaxConfigNum
        [Config,NewWS] = CreatShape(WS,N);
        %
%          f = figure(666);
%         f.Position = [1921,265,1536,739];
%         cla
%         PlotWorkSpace(NewWS,"Plot_CellInd",true);   
        %
        ConfigCellArray{ConfigNum} = Config;
        if ~mod(ConfigNum,1000)
            fprintf("ConfigNum: %d, ModuleNUm: %d\n",ConfigNum,N);
        end
    end
    fprintf("save ModuleNUm: %d\n",N);
    save(strcat("configuration\LargeConfigs\N",string(N),".mat"),"ConfigCellArray");
end

% for AgentN = AgentNum
%     CP = GetConfigPairs(WS,AgentNum,PairsNum);
%     try
%         load(strcat("configuration\ConfigPairs\N",string(AgentNum),".mat"),"ConfigPairs");
%     end
%     ConfigPairs = [ConfigPairs,CP];
%     save(strcat("configuration\ConfigPairs\N",string(AgentNum),".mat"),"ConfigPairs");
% end

function ConfigPairs = GetConfigPairs(WS,N,NumOfPairs)
    Stock = [];
    ConfigPairs = [];
    while size(ConfigPairs,2) < NumOfPairs
        try    
            [Config,NewWS] = CreatShape(WS,N);
            flag2 = false;
        catch e
            e
        end
            if isempty(Stock)
                Stock{1} = Config;
            end
%             tic
            
            for ii = 1:numel(ConfigPairs)
                if isequal(Config,ConfigPairs{ii}{1})
                    flag = false;
                    break
                end
                if isequal(Config,ConfigPairs{ii}{2})
                    flag = false;
                    break
                end
            end
            
            for ii = 1:size(Stock)
                if isequal(Config,Stock{ii})
                    break
                end
                Cost = Cost2Target(Config.Status,Config.Type,Stock{ii}.Status,Stock{ii}.Type);
                if Cost <=0.75*N
                    flag2 = true;
                end
                if Cost <= 0.5*N
                    ConfigPairs{end+1} = {Config,Stock{ii}};
                    Stock(ii) = [];
                    fprintf("N: " + N+"   pairs found: "+numel(ConfigPairs)+"\n");
                    flag2 = false;
                end
                
            end
            if flag2
                Stock{end+1} = Config;
                if ~mod(size(Stock,2),200)
                    size(Stock,2)
                end
            end
            
    end
end


function [Config,NewWS] = CreatShape(WS,N)
WS.Space.Status(floor(WS.SpaceSize(1)/2),floor(WS.SpaceSize(2)/2):floor(WS.SpaceSize(2)/2)+1) = 1;
male = 1;

female = 1;

while (male<N/2) || (female<N/2)
    type = randi(2,1);
    switch type
        case 1
            if male<N/2
                [WS,Sucsses] = AddAgent(WS,-1);
                if Sucsses
                    male = male+1;
                end
            end
            
        case 2
            if female<N/2
                [WS,Sucsses] = AddAgent(WS,1);
                if Sucsses
                    female = female+1;
                end
                
            end     
    end

end

Config = GetConfiguration(WS);
NewWS = WS;
%     PlotWorkSpace(WS,[]);
end

