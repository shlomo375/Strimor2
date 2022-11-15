function GroupZoneMatrix = CreatGroupZoneMatrix(GroupMatrix,GroupIndexes)
GroupZoneMatrix = zeros(size(GroupMatrix));

GapsValues = [-22;-23;-27;-28;28;27;23;22];
SpecialGapValues = [33;32;-18;-17]; %GapFromBelow

GapFromAbove_Indexes = [];
GapFromBelow_Indexes = [];

for GapRank = (size(GroupMatrix,2)-2):-1:0
    n = GapRank*2 + 2;
    if ~GapRank
        OverlapValue = [-n:-2,2:n];
        SpecialOverlapValue = [1,-(n+1)]; %overlap on top;
    else %GapTank>2
        OverlapValue = [n,-n];
        SpecialOverlapValue = [n-1,-(n+1)]; %overlap on top;
    end

AllAboveGapValues = [GapsValues;SpecialGapValues;-SpecialGapValues];
AllBelowGapValues = AllAboveGapValues;
if ~GapRank
    AllAboveGapValues = [GapsValues;-SpecialGapValues];
    AllBelowGapValues = [GapsValues;SpecialGapValues];
end

G=GroupMatrix;  
m=mod(GroupMatrix,2);
s=sign(GroupMatrix);
G(m==0&G)=2;
G(m==1&abs(G)>1)= 3;
G = G.*s;

Temp = conv2(G,[1,ones(1,GapRank)*100,10],"valid");

GapsMap = Temp + GapRank*100;
[GapFromAbove_Row, GapFromAbove_Col] = find(ismember(GapsMap,AllAboveGapValues)); 

GapsMap = Temp - GapRank*100;
[GapFromBelow_Row, GapFromBelow_Col] = find(ismember(GapsMap,AllBelowGapValues));

if isempty(GapFromAbove_Col) || isempty(GapFromBelow_Row)
    continue
end

GapFromAbove_Indexes = GetGapIndexes(GapFromAbove_Col, GapFromAbove_Row, GroupIndexes, GapFromAbove_Indexes);
GapFromBelow_Indexes = GetGapIndexes(GapFromBelow_Col, GapFromBelow_Row, GroupIndexes, GapFromBelow_Indexes);

[OverlapAboveGap_Row, OverlapAboveGap_Col] = find(ismember(GroupMatrix,[OverlapValue, SpecialOverlapValue]));
[OverlapBelowGap_Row, OverlapBelowGap_Col] = find(ismember(GroupMatrix,[OverlapValue, -SpecialOverlapValue]));

GroupZoneMatrix = UpdateGroupZoneMatrix(OverlapAboveGap_Row, OverlapAboveGap_Col,GapFromBelow_Indexes,GroupIndexes,"Below",GroupZoneMatrix);
GroupZoneMatrix = UpdateGroupZoneMatrix(OverlapBelowGap_Row, OverlapBelowGap_Col,GapFromAbove_Indexes,GroupIndexes,"Above",GroupZoneMatrix);

end
