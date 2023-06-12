function Node = GroupMatrix2Configuration(Node,Groups,WS)
Groups(~Groups) = [];
N = sum(abs(Groups(:)));



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
    pos = floor(Beta-0.5*abs(Groups(Line)):(Beta+0.5*abs(Groups(Line))-1));
    if any(pos<1)
        pos = pos + abs(min(pos))+1;
    end
    WS.Space.Status(Line,pos) = ones(1,abs(Groups(Line)));
    if sign(Groups(Line)) ~= WS.Space.Type(Line,pos(1))
        WS.Space.Status(Line,pos) = zeros(1,abs(Groups(Line)));
        
        WS.Space.Status(Line,1+pos) = ones(1,abs(Groups(Line)));
        Lines = [Line,Line-1];
        OK = CheckLineConnected(WS,Lines);
        % OK = SplittingCheck(WS,find(WS.Space.Status,1),true);
        % if OK ~=OK1
        %     d=5
        % end

        if ~OK
            WS.Space.Status(Line,1+pos) = zeros(1,abs(Groups(Line)));
       
            WS.Space.Status(Line,-1+pos) = ones(1,abs(Groups(Line)));
        end
    end
    
    
end
% if SplittingCheck(WS,find(WS.Space.Status,1),true)
    Config = GetConfiguration(WS);
    Node = ConfigStruct2Node(Node,Config);

   
% else
%     Node = [];
% end
end

function OK = CheckLineConnected(WS,Lines)

TopLineModuelInd = find(WS.Space.Status(Lines(1),:));
baseLineModuelInd = find(WS.Space.Status(Lines(2),:));

TopLineModuelInd(WS.Space.Type(Lines(1),TopLineModuelInd)==-1) = [];
baseLineModuelInd(WS.Space.Type(Lines(2),baseLineModuelInd)==1) = [];

OK = any(ismember(TopLineModuelInd,baseLineModuelInd));

end


