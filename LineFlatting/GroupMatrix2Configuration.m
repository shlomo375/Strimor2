function Node = GroupMatrix2Configuration(Groups)
N = sum(abs(Groups(1,:)));
BesicWS = WorkSpace([N,N*2],"RRT*");
WS = BesicWS;

WS.Space.Status(1,floor(((2*N-abs(Groups(1)))/2):(abs(Groups(1))-1+(2*N-abs(Groups(1)))/2))) = ones(1,abs(Groups(1)));

if sign(Groups(1)) ~= WS.Space.Type(1,floor((2*N-abs(Groups(1)))/2))
    WS.Space.Status(1,floor(((2*N-abs(Groups(1)))/2):(abs(Groups(1))-1+(2*N-abs(Groups(1)))/2))) = zeros(1,abs(Groups(1)));

    WS.Space.Status(1,1+floor(((2*N-abs(Groups(1)))/2):(abs(Groups(1))-1+(2*N-abs(Groups(1)))/2))) = ones(1,abs(Groups(1)));
end
for Line = 2:numel(Groups)
    [~,Col]= find(WS.Space.Status(Line-1,:));
    if Groups(Line-1)>0
        Col(1:2:end)=[];
    else
        Col(2:2:end)=[];
    end
    try
    temp = randi(numel(Col));
    Beta = Col(temp);
    catch ee
        ee
    end
    WS.Space.Status(Line,floor(Beta-0.5*abs(Groups(Line)):Beta+0.5*abs(Groups(Line))-1)) = ones(1,abs(Groups(Line)));
    if sign(Groups(Line)) ~= WS.Space.Type(Line,floor(Beta-0.5*abs(Groups(Line))))
        WS.Space.Status(Line,floor(Beta-0.5*abs(Groups(Line)):Beta+0.5*abs(Groups(Line))-1)) = zeros(1,abs(Groups(Line)));
        
        WS.Space.Status(Line,1+floor(Beta-0.5*abs(Groups(Line)):Beta+0.5*abs(Groups(Line))-1)) = ones(1,abs(Groups(Line)));
        
        OK = SplittingCheck(WS,find(WS.Space.Status,1));

        if ~OK
            WS.Space.Status(Line,1+floor(Beta-0.5*abs(Groups(Line)):Beta+0.5*abs(Groups(Line))-1)) = zeros(1,abs(Groups(Line)));
       
            WS.Space.Status(Line,-1+floor(Beta-0.5*abs(Groups(Line)):Beta+0.5*abs(Groups(Line))-1)) = ones(1,abs(Groups(Line)));
        end
    end
    
    if SplittingCheck(WS,find(WS.Space.Status,1))
    Config = GetConfiguration(WS);
    Node = ConfigStruct2Node(Config);
    else
        Node = [];
    end
end

end


