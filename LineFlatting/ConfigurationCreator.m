%% One group in line - configuration creator
clear

N = 17;


tic
OptionVector = [1,1];
for GroupSize = 2:N
    OptionVector = [OptionVector, ones(1,floor(N/GroupSize))*GroupSize];
    
end
PosibleComb = cell(floor(N/2),1);
for LineNum = 2:floor(N/2)+1
    MaxGroupSize = N-2*(LineNum-2);
    Comb = nchoosek(OptionVector(OptionVector<MaxGroupSize),LineNum);
    Comb(sum(abs(Comb),2)~= N,:) = [];
    PosibleComb{LineNum-1} = unique(Comb,"rows");
end

NewPosibleComb = cell(numel(PosibleComb),1);
for LineNum = 1:numel(PosibleComb)
    OptionVector = [PosibleComb{LineNum}, - PosibleComb{LineNum}];
    for ii = 1:size(OptionVector,1)
        Comb = nchoosek(OptionVector(ii,:),LineNum+1);
        Comb(sum(abs(Comb),2)~= N,:) = [];
        NumAlphaBeta = sign(Comb);
        NumAlphaBeta(~mod(Comb,2))  = 0;
        if ~mod(N,2)
            Comb(sum(NumAlphaBeta,2)~=0,:) = [];
        else
            Comb(abs(sum(NumAlphaBeta,2))~= 1,:) = [];
        end
        try
        NewPosibleComb{LineNum} = [NewPosibleComb{LineNum};Comb];
        catch eee
eee
        end
    end
end

for LineNum = 1:numel(PosibleComb)
    Temp = unique(NewPosibleComb{LineNum},"rows");
    AllPerm = [];
    for Row = 1:size(Temp,1)
        Perm = perms(Temp(Row,:));
       
        Delete = Perm(:,1) == 1 | Perm(:,end) == -1 | any(abs(Perm(:,2:end-1)) == 1,2);
%         if any(any(abs(Perm(:,2:end-1)) == 1,2))
%             d=5
%         end
        if ~isempty(Delete)
            Perm(Delete,:) = [];
        end
        AllPerm = [AllPerm; unique(Perm,"rows")];
    end
    NewPosibleComb{LineNum} = unique(AllPerm,"rows");
end

TotalConfigInLineNum = cellfun(@(x) size(x,1),NewPosibleComb);
TotalConfig = sum(TotalConfigInLineNum)

try


VarName = {'time','Index','ParentIndex','Type','Level','Cost', ...
           'Dir','Step','ConfigRow','ConfigCol','ParentRow','ParentCol',...
           'Visits','Cost2Target','ConfigStr','ParentStr','ConfigMat',...
           'ParentMat','IsomorphismMatrices1','IsomorphismMatrices2','IsomorphismMatrices3'...
           'IsomorphismStr1','IsomorphismStr2','IsomorphismStr3','IsoSiz1r','IsoSiz1c','IsoSiz2r','IsoSiz2c','IsoSiz3r','IsoSiz3c'};
VarType = {'duration','double','double','double','double',...
           'double','double','double','double','double','double','double'...
           ,'double','double','string','string','cell','cell','cell','cell'...
           ,'cell','string','string','string','double','double','double','double','double','double'};
            
TotalProblem  = table('Size',[TotalConfig,numel(VarName)],'VariableTypes',VarType,'VariableNames',VarName);

toc
save("ConfigurationCreator.mat");
%% 
% load("ConfigurationCreator.mat");
tic
TimeForConfig = 0;
for LineNum = 1:numel(NewPosibleComb)

    Set = NewPosibleComb{LineNum};
    ProblemSoFar = sum(TotalConfigInLineNum(1:LineNum-1));
    disp(["left: "+string(TotalConfig-ProblemSoFar),"ExpectedTimeMinets: "+string(round(TimeForConfig*size(Set,1)/60)),"Date: "+string(datetime)])
    pause(1);
    
    parfor idx = 1:size(Set,1)
%         disp(idx)
        TotalProblem(ProblemSoFar + idx,:) = GroupMatrix2Configuration(Set(idx,:));
    
    end
    a = toc;
    TimeForConfig = a/ProblemSoFar; 
    save("Problems17.mat","TotalProblem");
end
catch e
e
end
