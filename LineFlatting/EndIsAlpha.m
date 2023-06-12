function IsAlpha = EndIsAlpha(GroupSize)

IsAlpha = double(xor(sign(GroupSize)<0,mod(abs(GroupSize),2)));
IsAlpha(~GroupSize) = nan;
end
