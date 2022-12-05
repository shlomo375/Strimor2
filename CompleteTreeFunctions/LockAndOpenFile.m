function OpenToRead = LockAndOpenFile(FileName,Action)
LockName = FileName+"_Lock";
OpenToRead = false;
switch Action
    case "Lock"
        Locked = isfile(LockName);
        while Locked
            pause(0.1);
            Locked = isfile(LockName);
        end
        save(LockName,"LockName");
        if isfile(LockName)
            OpenToRead = true;
        end
        
    case "Open"
        delete(LockName);
end


end
