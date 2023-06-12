for ii = 1:numel(N)
p = Path_N(Path_N(:,ii)>0,ii);
l = DL(Path_N(:,ii)>0)
plot(l,p)
hold on
end