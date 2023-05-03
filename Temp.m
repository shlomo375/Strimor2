% Define a function that returns three outputs


% Call the function and set the fourth output to a value of your choice
[output1, output2, output3, myValue] = myFunction(3);

% Check the number of output arguments requested by the caller
if nargout > 3
    myValue = 0;
end

% The fourth output argument will have the value of 0
disp(myValue); % Output: 0

function [output1, output2, output3] = myFunction(input)
    output1 = input + 1;
    output2 = input - 1;
    output3 = input * 2;
end