%% Run Simple Shape expirements
clear
close all
AddDirToPath
TestType = "C2C";
TestFile = dir("SimpleShapeAlg\Experiments");
TestFile([TestFile.isdir]) = [];

for ii = 1:numel(TestFile)
    if contains(TestFile(ii).name,TestType) && str2double(cell2mat(extractBetween(TestFile(ii).name,"N_","_"))) == 100
        load(fullfile(TestFile(ii).folder,TestFile(ii).name),"Exp","BasicWS","Solution")
        N = str2double(cell2mat(extractBetween(TestFile(ii).name,"N_","_")));
        BasicWS = WorkSpace(15*[N,2*N],"RRT*");
        problemSolve = 0;
        for k = 1:numel(Exp)
            if numel(Exp{k}) == 2
                StartNode = Exp{k}{1};
                TargetNode = Exp{k}{2};
                
                if StartNode.ConfigRow > TargetNode.ConfigRow
                [Tree,error] = SimpleShapeAlgorithm(BasicWS,N,StartNode,TargetNode);
                problemSolve = problemSolve+1;
                if error
                    
                    NotTested
                    Solution{k} = "error"
                else
                    Solution{k} = {Tree.Data(1:Tree.LastIndex,:)};
                end
                end
            else
                StartNode = Exp{k}{1};
                TargetNode = Exp{k}{2};
                [Tree1,error1] = SimpleShapeAlgorithm(BasicWS,N,StartNode,TargetNode);
                

                StartNode = Exp{k}{3};
                TargetNode = Exp{k}{2};
                [Tree2,error2] = SimpleShapeAlgorithm(BasicWS,N,StartNode,TargetNode);
                
                if error2 || error1
                    Solution{k} = "error"
                else
                    Solution{k} = {Tree1.Data(1:Tree.LastIndex,:),Tree2.Data(1:Tree.LastIndex,:);};
                end
            end
        end


    end
end
