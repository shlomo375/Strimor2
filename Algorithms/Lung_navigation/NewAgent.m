function Agent = NewAgent(Loc,DirVec)

if nargin < 2
    Shift = Rand(size(Loc,1),3)/2;
    Agent = [Loc(:,1) + Shift(:,1),...
        Loc(:,2) + Shift(:,2),...
        Loc(:,3) + Shift(:,3)];
else
    UnitVec = [DirVec(1),DirVec(2),DirVec(3)]./norm(DirVec);
    Shift = rand(size(Loc,1))/2 .* UnitVec;

    Agent = Loc + Shift;
end


end
