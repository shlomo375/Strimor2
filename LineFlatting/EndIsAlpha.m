function IsAlpha = EndIsAlpha(GroupSize)

IsAlpha = xor(sign(GroupSize)<0,mod(abs(GroupSize),2));

end
