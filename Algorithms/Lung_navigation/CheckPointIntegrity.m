function OK = CheckPointIntegrity(Param, Point,PerentPoint)
OK = true;
if isempty(PerentPoint)
    OK = true;
    return
end

if Point(Param.VecMagnitude) > Param.VecMagnitudeRatio * PerentPoint(Param.VecMagnitude)
    OK = false;
end

if Point(Param.Diameter) > Param.Diameter * PerentPoint(Param.Diameter)
    OK = false;
end

end
