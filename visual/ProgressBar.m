function ProgressBar(varargin)
persistent Data
persistent t1
persistent t2
persistent MaxSize
persistent B
persistent TotalConfig
persistent trees
persistent count
if numel(varargin{1})==1
    figure("Name","Progress bar",'Position',[1.0666e+03 412.2000 468 368]);
    time = zeros(0);
    TotalConfig = 0;
    count = 0;
    trees = ["a","b","c","d"];
    Data = zeros(4,2);
    B = bar(Data);
    MaxSize = varargin{1};
%     B(1).YData = Data(1,:); 
B = bar(Data);
    xtips2 = B(1).XEndPoints;
    ytips2 = B(1).YEndPoints;
    labels2 = string(B(1).YData);
    t = text(xtips2,ytips2,labels2,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom');
    ylim([0 MaxSize*1.2]);
    drawnow
    return
end
delete(t1);
delete(t2)

id =varargin{1}{1};
count = count +1;
trees(id) = varargin{1}{2};
if strcmp(varargin{1}{3},"search")
    time(id) = varargin{1}{6};
    
    if ~varargin{1}{4}
        TotalConfig = Data(id,2)+TotalConfig;
        Data(id,1) = 0;
    end
    Data(id,2) = varargin{1}{4};% varargin{1}{5}];
else
    Data(id,1) = varargin{1}{4};
end
% B(id).YData = Data(:,id);

X = categorical(trees);
X = reordercats(X,trees);

% if ~mod(count,4)
    B = bar(X,Data,'FaceColor','flat');
    for k = 1:size(Data,2)
        B(k).CData = k;
    end
    xtips2 = B(2).XEndPoints;
    ytips2 = B(2).YEndPoints;
    xtips1 = B(1).XEndPoints;
    ytips1 = B(1).YEndPoints;
    labels2 = string(B(2).YData);
    labels1 = string(B(1).YData);
    t1 = text(xtips1,ytips1,labels1,'HorizontalAlignment','center',...
        'VerticalAlignment','bottom');
    t2 = text(xtips2,ytips2,labels2,'HorizontalAlignment','center',...
        'VerticalAlignment','bottom');
    ylim([0 MaxSize*1.2]);
    % title({"config per sec all: "+sum(time),"Total Config this run: "+TotalConfig});
% end
drawnow
end
