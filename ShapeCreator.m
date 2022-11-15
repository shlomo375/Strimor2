clear
SoftwareLocation = 'C:\Users\shlom\OneDrive - Ariel University\Documents\לימודים\תואר שני\תזה\triangles';
% addpath(genpath(SoftwareLocation));

PairsNum = 1;
Stock = [];
ConfigPairs = [];
for AgentNum = 16
    CP = GetConfigPairs(AgentNum,PairsNum);
    load(strcat("configuration\ConfigPairs\N",string(AgentNum),".mat"),"ConfigPairs");
    ConfigPairs = [ConfigPairs,CP];
    save(strcat("configuration\ConfigPairs\N",string(AgentNum),".mat"),"ConfigPairs");
end

function ConfigPairs = GetConfigPairs(N,NumOfPairs)
    Stock = [];
    ConfigPairs = [];
    while size(ConfigPairs,2) < NumOfPairs
        try    
        Config = CreatShape(N);
        flag2 = false;
        catch e
            e;
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
                if Cost <= 0.6*N
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


function Config = CreatShape(N)
    space = zeros(N,N*2);
    space(N/2,N) = 1;
    male = 1;
    female = 0;
    
    while (male<N/2) || (female<N/2)
        type = randi(2,1);
        switch type
            case 1
                if male<N/2
                    space = AddAgent(space,-1);
                end
                
            case 2
                if female<N/2
                    space = AddAgent(space,1);
                end     
        end
        male = sum(space==1,"all");
        female = sum(space==-1,"all");
    
    end
    
    type = ones(size(space,1),1);
    type(2:2:end) = -1;
    temp = ones(1,size(space,2));
    temp(2:2:end) = -1;
    type = type.*temp;

    agent = find(space==1,1);
    if type(agent) ~= space(agent)
        type = -type;
    end
 
    WS = WorkSpace([N,N*2],"RRT*");
    Config.Status = double(logical(space));
    Config.Type = type(find(Config.Status,1));
    WS = SetConfigurationOnSpace(WS,Config);
    Config = GetConfiguration(WS);
%     PlotWorkSpace(WS,[]);
end

function space = AddAgent(space,type)
    [rows,cols] = find(space==type);
    try
    agent = randi(numel(rows),1);
    catch e
        return
    end
    row = rows(agent);
    col = cols(agent);
    
    dir = randi(3,1)-2;
    switch dir
        case 1
            space(row,col+1) = -type;
        case -1
            space(row,col-1) = -type;
        case 0
            if type==1
                space(row-1,col) =-type;
            else
                space(row+1,col) = -type;
            end
    end


end