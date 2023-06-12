function GroupZoneMatrixOriginal = CreatGroupZoneMatrix2(GroupMatrixOriginal,ConfigMatOriginal,ConfigTypeOriginal,GroupIndexesOriginal)

%%
SaveRows = any(GroupMatrixOriginal,2);
GroupMatrix = GroupMatrixOriginal(SaveRows,:);
ConfigMat = ConfigMatOriginal(SaveRows,:);
ConfigType = ConfigTypeOriginal(SaveRows,:);
GroupIndexes = GroupIndexesOriginal(SaveRows);
%%

GroupZoneMatrix = zeros([size(GroupMatrix),2]);
%% zero padding
Type = ConfigType(find(ConfigMat,1));
ConfigMat = [ConfigMat,zeros(size(ConfigMat,1),max(abs(GroupMatrix),[],"all")-1)];    
ConfigType = GetFullType(ConfigMat,Type);
% Eddition = repmat([ConfigType(:,end-1),ConfigType(:,end)],1,floor(max(abs(GroupMatrix),[],"all")/2));
% if mod(max(abs(GroupMatrix),[],"all"),2)
%     ConfigType = [ConfigType,Eddition];
% else
%     ConfigType = [ConfigType,Eddition(:,1:end-1)];    
% end
%%
ConfigMat(ConfigMat~=0) = 1;
HoleMat = ~ConfigMat;
HoleMat = HoleMat.*ConfigType;

AlphaCol = [-1;0;0];
BetaCol =  [0;0;1];
[MaxLine,MaxCol] = size(GroupMatrix);
for Line = 1:MaxLine
    for Col = 1:MaxCol
        TopZone = false;
        ButtomZone = false;
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
                if GroupMatrix(Line,Col) == 1
                    TopZone = true;
                end
                HoleVec = ConvMatrix(3,:);
                if ~HoleVec(1) && HoleMat(Line+1,1) ~= 1
                    HoleVec(1) = [];
                end
                TopHoleValue = conv(HoleMat(Line+1,:),flip(HoleVec),'valid');
                TopZoneLoc = find(TopHoleValue == sum(abs(HoleVec)));
%                 TopZoneLoc(TopZoneLoc==1) = [];
            else
                TopZoneLoc = 1:2:size(ConfigMat,2);
            end

            if Line ~= 1
                if GroupMatrix(Line,Col) == -1
                    ButtomZone = true;
                end
                HoleVec = ConvMatrix(1,:);
                if ~HoleVec(1) && HoleMat(Line-1,1) ~= -1
                    HoleVec(1) = [];
                end
                ButtomHoleValue = conv(HoleMat(Line-1,:),flip(HoleVec),'valid');
                ButtomZoneLoc = find(ButtomHoleValue == sum(abs(HoleVec)));
%                 ButtomZoneLoc(ButtomZoneLoc==1) = [];
            else
                ButtomZoneLoc = 1:2:size(ConfigMat,2);
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
            try
                if ~TopZone
                    GroupZoneMatrix(Line,Col,1) = GetZoneOfGroup(TopZoneLoc,GroupIndex);
                else
                    GroupZoneMatrix(Line,Col,1) = inf;
                end
                if ~ButtomZone
                    GroupZoneMatrix(Line,Col,2) = GetZoneOfGroup(ButtomZoneLoc,GroupIndex);
                else
                    GroupZoneMatrix(Line,Col,2) = inf;
                end
            
            catch ee
                ee
            end

        else
            break
        end
    end
    
end


%%
GroupZoneMatrixOriginal = zeros([size(GroupMatrixOriginal),2]);
GroupZoneMatrixOriginal(SaveRows,:,:) = GroupZoneMatrix;
%%

end
