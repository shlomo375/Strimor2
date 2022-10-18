%% Copy TreeDir
SoftwareLocation = pwd;
AddDirToPath;


OriginalOrBeckUpBasic = "BlankTree";
TreeTypeBasic = "uniform_IM1Axis__3";
TreeType = ["uniform_IM1Axis__3","uniform_IM2Axis__3","uniform_IM3Axis__3"];
TreeIndexes = [1:50];
OriginalOrBeckUp = ["BlankTree","Results","BeckupResults"];
ModuleRange = [16:20];

for Type = TreeType
    for OriginalOrBeck = OriginalOrBeckUp
        for Range = ModuleRange
            OldLoc = fullfile(SoftwareLocation,"RRTtree",OriginalOrBeckUpBasic,Range+"N",TreeTypeBasic);
            NewLoc = replace(OldLoc,[OriginalOrBeckUpBasic,TreeTypeBasic],[OriginalOrBeck,Type])
            if strcmp(OldLoc,NewLoc)
                continue
            end
            try
            rmdir(NewLoc,'s');
            end
            mkdir(NewLoc);
            try
            copyfile(OldLoc,NewLoc);
            end
        end
    end
end