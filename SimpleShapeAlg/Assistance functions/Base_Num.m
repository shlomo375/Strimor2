function num = Base_Num(GroupSize,BaseType)

if ~mod(GroupSize,2)
    num = abs(GroupSize/2);
    return
elseif GroupSize>0
    Alpha_num = ceil(GroupSize/2);
    Beta_num = floor(GroupSize/2);
else
    Alpha_num = floor(abs(GroupSize)/2);
    Beta_num = ceil(abs(GroupSize)/2);
end

if BaseType == 1
    num = Alpha_num;
else
    num = Beta_num;
end

end
