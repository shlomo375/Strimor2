function [Agent2Move, dir] = RandomAgent2Move(WS,dir)
    
%     temp = setdiff(-3:3,0);
%     dir = temp(randi(length(temp)));
    switch abs(dir)
        case 1
            R = WS.R1;
        case 2
            R = WS.R2;
        case 3
            R = WS.R3;     
    end
%     find number of row is chosen dir
    tempInd = (R==1);
    R(R==0) = 1;
    Space = reshape([WS.Space(R).Status],size(R));
    R(R==1) = 0;
    R(tempInd) = 1;
    Space(R==0) = 0;    
    
    CutSpace = Space(any(Space,2),any(Space));
    ShiftCutSpace = find(any(Space,2),1)-1;

    MaxRow = floor(sum(any(Space,2))/2);
    NumOfRowToMove = randi(MaxRow);
    RowToMove = ones(1,NumOfRowToMove).*randi(MaxRow);
    for i = 2:NumOfRowToMove
        RowDir = randi(2);
        if RowDir == 1 
            if max(RowToMove) < MaxRow
                RowToMove(i) = max(RowToMove)+1;
            else
                RowToMove(i) = min(RowToMove)-1;
            end
        else
            if min(RowToMove) > 1
                RowToMove(i) = min(RowToMove)-1;
            else
                RowToMove(i) = max(RowToMove)+1;
            end
        end
    end
    
    
    NumOfAgentInSelectedRow = sum(CutSpace(RowToMove,:),2);
    for i = length(NumOfAgentInSelectedRow):-1:1
        NumAgent2Move(i) = randi(NumOfAgentInSelectedRow(i));
        p = 2-NumAgent2Move(i):NumOfAgentInSelectedRow(i);
        pos{i} = find(Space(ShiftCutSpace+RowToMove(i),:),1)-1 + p;
    end
    
    AllCombination = cell(1,numel(pos));
    [AllCombination{:}] = ndgrid(pos{:});
    AllCombination = cellfun(@(X) reshape(X,[],1),AllCombination,'UniformOutput',false);
    AllCombination = horzcat(AllCombination{:});

    if dir<0
        AllCombination = flip(AllCombination);
    end
    Size = size(AllCombination);
%     AllCombination = mat2cell(AllCombination,Size(1),ones(1,Size(2)));
    for i = Size(2):-1:1
        a = [ones(1,NumAgent2Move(i)) ; 1:NumAgent2Move(i)];
        try
        Col(i) = {[AllCombination(:,i),ones(Size(1),1)]*a};
        Row(i) = {ones(size(Col{i})).*RowToMove(i)+ShiftCutSpace};
        catch e
             fprintf(e.identifier);
        end

    end
    Row = cat(2,Row{:});
    Col = cat(2,Col{:});
    Col = mat2cell(Col,ones(1,size(Col,1)),size(Col,2));
    Row = mat2cell(Row,ones(1,size(Row,1)),size(Row,2));
    
    MaxCol = num2cell(ones(size(Col,1),1)*size(R,2),2);
    Row = cellfun(@(x,y,r) x((y>0) & (y<=r)),Row,Col,MaxCol,'UniformOutput',false);
    Col = cellfun(@(x,y,r) x((y>0) & (y<=r)),Col,Col,MaxCol,'UniformOutput',false);
    
    Loc2Move = cellfun(@(row,col,r) r(sub2ind(size(r),row,col)),Row,Col,repmat({R},size(Col,1),1),'UniformOutput',false);
    Agent2Move = cellfun(@(x) x(x~=0),Loc2Move,'UniformOutput',false);
    try
    Agent2Move = cellfun(@(x,status) x(status(x)~=0),Agent2Move, repmat({[WS.Space.Status]},size(Col,1),1),'UniformOutput',false);
%     sizeComb = size(Agent2Move,1)
    catch
        d=5
    end
    
end