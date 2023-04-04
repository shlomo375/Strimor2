function NewConfig = AddConfigShifts(Config, Shifts)

NewConfig = [zeros([Shifts(1),size(Config,[2,3])]); Config; zeros([Shifts(2),size(Config,[2,3])])];

end