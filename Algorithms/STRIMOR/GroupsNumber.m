function n = GroupsNumber(data)
    switch data.function
        case "normal"
            n = ceil(abs(normrnd(0,data.parameter)));
            if ~n
                n=1;
            end
        case "uniform"
            n = randi(data.parameter);
        otherwise
            n = 1;
    end

end