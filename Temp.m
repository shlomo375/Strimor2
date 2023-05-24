rows = 9;
cols = 41;
series = createSeries(rows, cols);


function series = createSeries(rows, cols)
    series = zeros(rows, cols); % Preallocate a matrix to hold the series
    
    % Populate the matrix with the given pattern
    for i = 1:rows
        for j = 1:cols
            if j <= i*2
                series(i, j) = (j-1) * 2^(i-1);
            end
        end
    end
end