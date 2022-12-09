function TreeName = FileString(SoftwareLocation,varargin)

for idx = 1:numel(varargin)
    str = varargin{idx};

    if matches(str,["Results","BeckupResults","BlankTree"])
        str1 = str;
    else
        if matches(str,digitsPattern+"N")
            str3 = str;
        else
            if contains(str,"tree_"+digitsPattern)
                str4 = str;
            else
                str2 = str;
            end
        end
    end
end
TreeName = fullfile(SoftwareLocation,"RRTtree",str1,str2,str3,str4);

end
