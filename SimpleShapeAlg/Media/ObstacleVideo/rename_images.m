%% rename image file

function rename_images(folder_path)
    % Get a list of all image files in the folder
    image_files = dir(fullfile(folder_path, '*.png'));

    % Find the maximum number of digits in the image names
    max_digits = numel(num2str(max(arrayfun(@(x) extract_numeric_section(x.name), image_files))));

    % Rename each image file with leading zeros
    for i = 1:numel(image_files)
        filename = image_files(i).name;
        [~, name, ext] = fileparts(filename);
        index = extract_numeric_section(filename);
        new_filename = sprintf('%s_%0*d%s', name, max_digits, index, ext);
        movefile(fullfile(folder_path, filename), fullfile(folder_path, new_filename));
    end
end

function index = extract_numeric_section(filename)
    parts = strsplit(filename, '_');
    index = str2double(extractBefore(parts{2}, '.'));
end

% Provide the folder path where the images are located
folder_path = fullfile("");

% Call the function to rename the images
rename_images(folder_path);
