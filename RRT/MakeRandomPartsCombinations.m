function [Comb, NumOfCombinations, OK] = MakeRandomPartsCombinations(Parts,ConfigVisits,RandomType)
OK = true;
NumOfCombinations = [];

% GroupsNumber
if ~matches(RandomType,"Complete")
    n = randi(ConfigVisits*2+1);
    if n == 1 && ~matches(RandomType,"Complete")
        Comb = cell(1,3);
        Comb{1} = Parts(:,:,1);
        Comb{2} = Parts(:,:,2);
        Comb{3} = Parts(:,:,3);
        return
    end
else 
    n = 1;
end

Comb = cell(1,3);
for dir = 3:-1:1
    GroupNum = find(Parts(1,:,dir),1,"last");
    if n > GroupNum/2
        continue
    end
    switch RandomType
        case "Partial"
            CombLoc = nchoosek(1:GroupNum,n);
            for ii = size(CombLoc,1):-1:1
                MultiGroup = Parts(:,CombLoc(ii,:),dir);
                MultiGroup = MultiGroup(:);
                Comb{dir}(1:sum(MultiGroup>0),ii) = MultiGroup(MultiGroup>0);
            end
        case "Complete"
            f = @(x) factorial(x);
            RowSize = [0; f(GroupNum)./(f(GroupNum-(1:floor(GroupNum/2))').*f((1:floor(GroupNum/2))'))];
            
            for NumG = floor(GroupNum/2):-1:1
                CombLoc(RowSize(NumG)+1:RowSize(NumG)+RowSize(NumG+1),1:NumG) = nchoosek(1:GroupNum,NumG);
            end
            for ii = size(CombLoc,1):-1:1
                MultiGroup = Parts(:,CombLoc(ii,CombLoc(ii,:)>0),dir);
                MultiGroup = MultiGroup(:);
                Comb{dir}(1:sum(MultiGroup>0),ii) = MultiGroup(MultiGroup>0);
            end
    end
end

% NumOfCombinations = size(Comb,2);

end
