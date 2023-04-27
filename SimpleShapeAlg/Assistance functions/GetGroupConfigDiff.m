function [AbsDiff, AlphaDiff, BetaDiff] = GetGroupConfigDiff(StartGroupConfig,TargetGroupConfig)
[StartGroupAlpha, StartGroupBeta] = Num_Alpha_Beta_In_Group(StartGroupConfig);
[TargetGroupAlpha, TargetGroupBeta] = Num_Alpha_Beta_In_Group(TargetGroupConfig);

AlphaDiff = TargetGroupAlpha - StartGroupAlpha; %minus mean to substract the module
BetaDiff  = TargetGroupBeta  - StartGroupBeta;
AbsDiff = AlphaDiff + BetaDiff;
end

function [Alpha, Beta] = Num_Alpha_Beta_In_Group(Groups)

Alpha = floor(abs(Groups)/2);
Alpha(mod(abs(Groups),2) & Groups>0) = Alpha(mod(abs(Groups),2) & Groups>0) + 1;

Beta = floor(abs(Groups)/2);
Beta(mod(abs(Groups),2) & Groups<0) = Beta(mod(abs(Groups),2) & Groups<0) + 1;

end

