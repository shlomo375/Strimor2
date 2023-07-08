%% rename image file
% Provide the folder path where the images are located
folder_path = fullfile("SimpleShapeAlg","Media","ObstacleVideo");

% Call the function to rename the images
rename_images(folder_path);

function rename_images(folder_path)
    % Get a list of all image files in the folder
    image_files = dir(fullfile(folder_path, '*.png'));

    % Find the maximum number of digits in the image names
    max_digits = numel(num2str(max(arrayfun(@(x) extract_numeric_section(x.name), image_files))));

    % Rename each image file with leading zeros
    for i = 1:numel(image_files)
        filename = image_files(i).name;
        [~, name, ext] = fileparts(filename);
        [index,BasicName] = extract_numeric_section(filename);
        new_filename = sprintf('%s_%0*d%s', BasicName, max_digits, index, ext);
        try
            movefile(fullfile(folder_path, filename), fullfile(folder_path, new_filename));
        catch e
            e;
        end
    end
end

function [index,Str] = extract_numeric_section(filename)
    parts = strsplit(filename, '_');
    index = str2double(extractBefore(parts{2}, '.'));
    Str = parts{1};
end


