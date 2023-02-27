stop = false
SoftwareLocation = 'C:\Users\shlom\OneDrive - Ariel University\Documents\לימודים\תואר שני\תזה\triangles';
% addpath(genpath(SoftwareLocation));
try
load("configuration\Square62.mat","Start")
load("configuration\Car62.mat","End")
for AgentNum = 62
    [ConfigPairs1, ConfigPairs2,Cost2Start,Cost2End] = GetConfigPairs(62,{End},{Start});
    
    CP = [ConfigPairs1 , flip(ConfigPairs2)];
%     for ii = 1:numel(CP)-1
%         ConfigPairs{ii} = {CP{ii},CP{ii+1}};
%     end
    save(strcat("configuration\ConfigPairs\N",string(AgentNum),".mat"),"ConfigPairs");%30
end



catch e
    e
% pause
end


function [Start,End,Cost2Start,Cost2End] = GetConfigPairs(N,Start,End)
    lastMaxCostStart = 0;
    lastMaxCostEnd = 0;
    j=0;
    WS = WorkSpace([N,N*2],"RRT*","Lite");
    func =@(x) 10-2*x/100000;
    stop = false
    Cost2Start = [];
    Cost2End = [];
    for kk = 1:2e5
            j=j+1;
            Config = CreatShape(N,WS);
            CostStart = Cost2Target(Config.Status,Config.Type,Start{end}.Status,Start{end}.Type);
            CostEnd = Cost2Target(Config.Status,Config.Type,End{end}.Status,End{end}.Type);
            
            StartLoc = CostStart>= func(j) %& CostEnd >= lastMaxCostEnd;
            if ~mod(j,100)
                disp({func(j),kk})
            end
            if any(StartLoc)
                Cost2Start(end+1) = CostStart;
                Cost2End(end+1) = CostEnd;
                Start{end+1} = Config;
                fprintf("Start size: "+ numel(Start)+"EndCost: "+CostEnd+"\n");
                lastMaxCostEnd = CostEnd;
            end
%             EndLoc = CostEnd>= func(j) %& CostStart >= lastMaxCostStart;
%             
%             if any(EndLoc)
%                 End{end+1} = Config;
%                 fprintf("End size: "+ numel(End)+"StartCost: "+CostStart+"\n");
%                 lastMaxCostStart = CostStart;
%             end
%             if isequal(End{end},Start{end})
%                 break
%             end
            if numel(Start)>10000
                break
            end
    end
end        


function Config = CreatShape(N,WS)
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
 
%     WS = WorkSpace([N,N*2],"RRT*","Lite");
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