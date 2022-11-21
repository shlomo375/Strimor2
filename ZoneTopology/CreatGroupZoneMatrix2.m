function GroupZoneMatrix = CreatGroupZoneMatrix2(GroupMatrix,ConfigType,ConfigMat,GroupIndexes)
GroupZoneMatrix = zeros(size(GroupMatrix));

ConfigMat(ConfigMat~=0) = 1;
HoleMat = ~ConfigMat;
HoleMat = HoleMat.*ConfigType;

AlphaCol = [-1;0;0];
BetaCol =  [0;0;1];
[MaxLine,MaxCol] = size(GroupMatrix);
for Line = 1:MaxLine
    for Col = 1:MaxCol
        if GroupMatrix(Line,Col)~=0
            
            if GroupMatrix(Line,Col)>0
                ConvMatrix = repmat([AlphaCol,BetaCol],1,ceil(abs(GroupMatrix(Line,Col))/2));
            else
                ConvMatrix = repmat([BetaCol,AlphaCol],1,ceil(abs(GroupMatrix(Line,Col))/2));
            end
            if mod(GroupMatrix(Line,Col),2)
                ConvMatrix(:,end) = [];
            end
            
            switch Line
                case 1
                    Value = conv2(HoleMat(Line+1,:),flip(ConvMatrix(3,:)),'valid');
                    ZoneLoc = find(Value == sum(abs(ConvMatrix(3,:))));
                case MaxLine
                    Value = conv2(HoleMat(Line-1,:),flip(ConvMatrix(1,:)),'valid');
                    ZoneLoc = find(Value == sum(abs(ConvMatrix(1,:))));
                otherwise
                    Value = conv2(HoleMat(Line-1:Line+1,:),flip(flip(ConvMatrix),2),'valid');
                    ZoneLoc = find(Value == sum(abs(ConvMatrix),'all'));
            end
            if isempty(ZoneLoc)
                continue
            end
            %The gap index is of the left edge of the gap, so if the overlap is
            % less then the gap index, it means that it has reached the
            % area to the left of the gap
            GroupIndex = GroupIndexes{Line}{Col}';
            ZoneLocFiltered = ZoneLoc(~[0, diff(ZoneLoc) == 2]);
            GroupZone = find(any((GroupIndex - ZoneLocFiltered')<0,2),1);

            if isempty(GroupZone)
                GroupZone = numel(ZoneLocFiltered)+1;
            end
            GroupZoneMatrix(Line,Col) = GroupZone;
        else
            break
        end
    end
    
end
% GroupZoneMatrix   
end
