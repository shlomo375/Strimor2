function [Comb, NumOfCombinations, OK] = MakeRandomPartsCombinations(Parts,m)
OK = true;
NumOfCombinations = [];


n = GroupsNumber(m);
if n == 1
    Comb = Parts;
    return
end
Comb = cell(1,3);
for dir = 3:-1:1
    if n>numel(Parts{dir})/2
        continue
    end
    CombLoc = nchoosek(1:numel(Parts{dir}),n);
    for ii = size(CombLoc,1):-1:1
        Comb{dir}{ii} = [Parts{dir}{CombLoc(ii,1)}; Parts{dir}{CombLoc(ii,2)}]';
    end
end

NumOfCombinations = numel(Comb);

end
