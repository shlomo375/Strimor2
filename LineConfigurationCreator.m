SoftwareLocation = pwd;
AddDirToPath;
cd(SoftwareLocation);

% arrange Line configuration group

for AgentNum = 16:30
    
    
    load(strcat("configuration\OptimalConfigPairs\N",string(AgentNum),".mat"),"ConfigPairs");
    
    NumAlpha = sum(ConfigPairs{1}{1}==1,"all");
    NumBeta = sum(ConfigPairs{1}{1}==-1,"all");
    N = NumAlpha+NumBeta;
    WS = WorkSpace([N,N*2],"RRT*");
    space = zeros(N,N*2);
    Type = -ones(1,N-1);
    Type(2:2:end) = 1;
    space(1:N-1,N) = Type;
    space(1:N-1,N+1) = 1;
    save(strcat("configuration\OptimalConfigPairs\N",string(AgentNum),".mat"),"ConfigPairs");
end