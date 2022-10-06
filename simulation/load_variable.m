function [data,variables,done] = load_variable(filename,variables)
    
    % If variable list is empty, 
    % create list of variables from the file
    if isempty(variables) 
        variables = who('-file', filename);
    end
    
    % Load a variable from the list of variables
    data = load(filename, variables{1});
    
    % Remove the newly-read variable from the list
    variables(1) = []; 
    
    % Move on to the next file if this file is done reading.
    done = isempty(variables); 
    
end
