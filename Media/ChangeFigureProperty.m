
Old = gcf
New = gcf
%%
Oldline = findobj(Old, 'Type', 'line')

Newline = findobj(New, 'Type', 'line')
NewPatch = findobj(New, 'Type', 'patch')
for i=1:numel(Newline)
    
set(Newline(i),'Color',Oldline(i).Color)
set(NewPatch(i),'FaceAlpha',0.2,'EdgeColor', 'none','FaceColor',Oldline(i).Color)%'FaceColor',Oldline(i).Color,
end
