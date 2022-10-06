function StartLineIDX = StartLineAxis3(Config,Type)
    ConfigWidth = size(Config,2);
    
    StartLineIDX = ceil(ConfigWidth/2);
    if Type(1,1) ~= 1 && mod(ConfigWidth,2) ==0
        StartLineIDX = StartLineIDX + 1;
    end

end
