%% multiple file at once
f=fieldnames(Maneuver_Cost)
for ii = 1:numel(f)
fid = fopen(join([f{ii},".m"],""),"w");
fwrite(fid,join(["function [Axis, Step, Moving_Log] = ",f{ii},"(Top_GroupInd,Mid_GroupInd,Buttom_GroupInd,MovmentDirection,Edges)"],""))

fwrite(fid, newline);
fwrite(fid, 'arguments');
fwrite(fid, newline);
fwrite(fid, '    Top_GroupInd {mustBeVector,mustBeInteger,mustBePositive}');
fwrite(fid, newline);
fwrite(fid, '    Mid_GroupInd {mustBeVector,mustBeInteger,mustBePositive}');
fwrite(fid, newline);
fwrite(fid, '    Buttom_GroupInd {mustBeVector,mustBeInteger,mustBePositive}');
fwrite(fid, newline);
fwrite(fid, '    MovmentDirection (1,1) {matches(MovmentDirection,["Right","Left"])}');
fwrite(fid, newline);
fwrite(fid, '    Edges = [];');
fwrite(fid, newline);
fwrite(fid, 'end');
fwrite(fid, newline);
fwrite(fid, newline);
fwrite(fid, 'end');
fclose(fid);
end
