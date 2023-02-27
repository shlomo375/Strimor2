%% plot shaded std
% Sample data
x = 1:10;
mean_data = sin(x);
std_data = 0.2 * ones(1, 10);

% Plot mean as a curve
hold on;
plot(x, mean_data, 'b', 'LineWidth', 2);

% Shade the area behind the mean curve
lower_bound = mean_data - std_data;
upper_bound = mean_data + std_data;
fill([x, fliplr(x)], [upper_bound, fliplr(lower_bound)], 'b', 'FaceAlpha', 0.2, 'EdgeColor', 'none');
