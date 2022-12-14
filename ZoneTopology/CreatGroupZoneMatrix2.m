function GroupZoneMatrix = CreatGroupZoneMatrix2(GroupMatrix,ConfigType,ConfigMat,GroupIndexes)

GroupZoneMatrix = zeros([size(GroupMatrix),2]);

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
            
            if Line ~= MaxLine
                HoleVec = ConvMatrix(3,:);
                if ~HoleVec(1)
                    HoleVec(1) = [];
                end
                TopHoleValue = conv(HoleMat(Line+1,:),flip(HoleVec),'valid');
                TopZoneLoc = find(TopHoleValue == sum(abs(HoleVec)));
            else
                TopZoneLoc = [];
            end
            if Line ~= 1
                HoleVec = ConvMatrix(1,:);
                if ~HoleVec(1)
                    HoleVec(1) = [];
                end
                ButtomHoleValue = conv(HoleMat(Line-1,:),flip(HoleVec),'valid');
                ButtomZoneLoc = find(ButtomHoleValue == sum(abs(HoleVec)));
            else
                ButtomZoneLoc = [];
            end
%             switch Line
%                 case 1
%                     Value = conv2(HoleMat(Line+1,:),flip(ConvMatrix(3,:)),'valid');
%                     ZoneLoc = find(Value == sum(abs(ConvMatrix(3,:))));
%                 case MaxLine
%                     Value = conv2(HoleMat(Line-1,:),flip(ConvMatrix(1,:)),'valid');
%                     ZoneLoc = find(Value == sum(abs(ConvMatrix(1,:))));
%                 otherwise
%                     Value = conv2(HoleMat(Line-1:Line+1,:),flip(flip(ConvMatrix),2),'valid');
%                     ZoneLoc = find(Value == sum(abs(ConvMatrix),'all'));
%             end
            
            %The gap index is of the left edge of the gap, so if the overlap is
            % less then the gap index, it means that it has reached the
            % area to the left of the gap
            GroupIndex = GroupIndexes{Line}{Col}';

            GroupZoneMatrix(Line,Col,1) = GetZoneOfGroup(TopZoneLoc,GroupIndex);
            GroupZoneMatrix(Line,Col,2) = GetZoneOfGroup(ButtomZoneLoc,GroupIndex);
            

        else
            break
        end
    end
    
end
% GroupZoneMatrix   
end
