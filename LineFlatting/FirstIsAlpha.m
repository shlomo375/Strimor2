function IsAlpha = FirstIsAlpha(GroupSize)

IsAlpha = double(GroupSize>0);
IsAlpha(~GroupSize) = nan;

end
