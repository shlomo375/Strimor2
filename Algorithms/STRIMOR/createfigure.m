function createfigure(tbl1, XVar1, YVar1, tbl2)
%CREATEFIGURE(tbl1, XVar1, YVar1, tbl2)
%  TBL1:  plot source table
%  XVAR1:  plot x variable
%  YVAR1:  plot y variable
%  TBL2:  plot source table

%  Auto-generated by MATLAB on 03-Jun-2022 16:28:19

% Create figure
figure1 = figure('Name','Mean',...
    'Color',[0.941176470588235 0.941176470588235 0.941176470588235]);

% Create axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');

% Create plot
plot(tbl1,XVar1,YVar1,'DisplayName','M = 1','Marker','o','LineWidth',3);

% Create plot
plot(tbl2,XVar1,YVar1,'DisplayName','M = 3','Marker','o','LineWidth',3);

% Create ylabel
ylabel('Path Length');

% Create xlabel
xlabel('number of modules');

% Create title
title({'Number of module groups in movments'});

% Uncomment the following line to preserve the X-limits of the axes
% xlim(axes1,[10.0067204301075 20.0067204301075]);
% Uncomment the following line to preserve the Y-limits of the axes
% ylim(axes1,[10.7549668874172 40.7549668874172]);
box(axes1,'on');
hold(axes1,'off');
% Set the remaining axes properties
set(axes1,'Clipping','off','FontSize',24);
% Create legend
legend1 = legend(axes1,'show');
set(legend1,...
    'Position',[0.151783305574235 0.75216686751836 0.12254130778399 0.119830829756601]);
