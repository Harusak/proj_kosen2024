clc;

load('moony_disk_grayscale_80_shine.mat')
%%
for i = 1:height(targetT)
    % Extract the image from the cell
    image = targetT{i};
    
    % Create the filename with the format mondoXXX.png
    filename = sprintf("mondrian%03d.png", i);
    filename = fullfile('mask',filename);
    % Save the image as a PNG file
    imwrite(image, filename);
end


%%
% Specify the directory containing the images
imageDir = 'img'; % Change this to your actual directory

% Get a list of all PNG files in the directory
imageFiles = dir(fullfile(imageDir, '*.png'));

% Initialize a cell array to store the filenames and image data
data = cell(length(imageFiles)/2, 2);

for i = 1:length(imageFiles)/2
    % Get the filename without the extension
    [~, filename, ~] = fileparts(imageFiles(i).name);
    
    % Read the image data
    imageData = imread(fullfile(imageDir, imageFiles(i).name));
    
    % Store the filename and image data in the cell array
    data{i, 1} = filename;
    data{i, 2} = uint8(imageData);
end

% Convert the cell array to a table
imageTable = cell2table(data, 'VariableNames', {'Filename', 'ImageData'});

% Display the table
disp(imageTable);
%%
clc;

% Define the field of view and image resolution
field_of_view_deg = 7.5; % field of view in degrees (example value)

%%
image_resolution = height(imageTable{1,"ImageData"}); % Assuming square images

% Prepare storage for contrast ratios and spatial frequencies
contrast_ratios_mooney = [];
spatial_freqs_moonney = [];

for i = 1:height(imageTable)
    % Extract the image from the cell
    image = double(imageTable.ImageData{i}  );
    
    [spatial_freq_mooney, contrast_ratio] = analyze_spatial_frequency(image,field_of_view_deg);
    
    % Store results for plotting
    contrast_ratios_mooney = [contrast_ratios_mooney; contrast_ratio'];
    spatial_freqs_moonney = [spatial_freqs_moonney; spatial_freq_mooney];
end

% Average contrast ratios across all images
mean_contrast_ratios_mooney = mean(contrast_ratios_mooney, 1);

% Plot the contrast ratio vs. spatial frequency

h(1) = subplot(1, 2, 1);
hold on;
for i = 1:height(imageTable)
    plot(spatial_freqs_moonney(i, :), contrast_ratios_mooney(i, :));
end
plot(spatial_freq_mooney, mean_contrast_ratios_mooney, 'k', 'LineWidth', 2);
% xlim([0.01,0.5])
% ylim([0,0.25])
hold off;
title('Contrast Ratio vs. Spatial Frequency for mooney');
xlabel('Spatial Frequency (cpd)');
ylabel('Contrast Ratio');
% legend(arrayfun(@(x) sprintf('%d', x), 1:height(targetT), 'UniformOutput', false));
grid on;

% Save the figure
% saveas(gcf, 'spatial_frequency_analysis_mooney.png');
%
image_resolution = height(targetT); % Assuming square images

% Prepare storage for contrast ratios and spatial frequencies
contrast_ratios_mask = [];
spatial_freqs_mask = [];

for i = 1:height(imageTable)
    % Extract the image from the cell
    image = double(targetT{i});
    
    [spatial_freq_mask, contrast_ratio] = analyze_spatial_frequency(image,field_of_view_deg);
    
    % Store results for plotting
    contrast_ratios_mask = [contrast_ratios_mask; contrast_ratio'];
    spatial_freqs_mask = [spatial_freqs_mask; spatial_freq_mask];
end

% Average contrast ratios across all images
mean_contrast_ratios_mask = mean(contrast_ratios_mask, 1);

% Plot the contrast ratio vs. spatial frequency
h(2) = subplot(1, 2, 2);
hold on;
for i = 1:height(imageTable)
    plot(spatial_freqs_mask(i, :), contrast_ratios_mask(i, :));
end
plot(spatial_freq_mask, mean_contrast_ratios_mask, 'k', 'LineWidth', 2);
hold off;
title('Contrast Ratio vs. Spatial Frequency for masks');
xlabel('Spatial Frequency (cpd)');
ylabel('Contrast Ratio');
% legend(arrayfun(@(x) sprintf('%d', x), 1:height(targetT), 'UniformOutput', false));
grid on;

% Save the figure
% saveas(gcf, 'spatial_frequency_analysis_mask.png');

linkaxes(h)

xlim([0.01,0.55])
ylim([0,0.25])

setFig(gcf, 30, 20, 10, "A")
printFig(gcf, "spatial_analysis_side.png", "png", false)


%%
clc;
figure();

clf;

hold on
shadedErrorBar(spatial_freq_mask,contrast_ratios_mask,{@mean,@std},'lineprops','-b','patchSaturation',0.33)
shadedErrorBar(spatial_freq_mooney,contrast_ratios_mooney,{@mean,@std},'lineprops','-r','patchSaturation',0.33)

title('Contrast Ratio vs. Spatial Frequency');
subtitle('Red: Mooney, Blue: Mondrian')
xlabel('Spatial Frequency (cpd)');
ylabel('Contrast Ratio');
xlim([0.01,0.5])
ylim([0,0.25])

hold off
grid on

setFig(gcf, 10, 10, 10, "A")
printFig(gcf, "spatial_analysis.png", "png", false)
%%

function [spatial_freq, contrast_ratio] = analyze_spatial_frequency(image, field_of_view_deg)
    % Convert the image to double precision
    image = double(image);
    
    % Compute the 2D Fourier Transform of the image
    F = fft2(image);
    
    % Shift zero frequency component to the center of the spectrum
    F_shifted = fftshift(F);
    
    % Compute the magnitude spectrum
    magnitude_spectrum = abs(F_shifted);
    
    % Average the magnitude spectrum along circular frequencies
    [rows, cols] = size(image);
    [u, v] = meshgrid(1:cols, 1:rows);
    u = u - ceil(cols/2);
    v = v - ceil(rows/2);
    radial_distance = sqrt(u.^2 + v.^2);
    max_radius = ceil(sqrt((cols/2)^2 + (rows/2)^2));
    
    radial_profile = zeros(max_radius, 1);
    for r = 1:max_radius
        radial_profile(r) = mean(magnitude_spectrum(radial_distance >= r-1 & radial_distance < r), 'all');
    end
    
    % Calculate the spatial frequency (cycles per degree)
    spatial_freq = (0:max_radius-1) / (cols / field_of_view_deg);
    
    % Normalize the contrast ratio
    contrast_ratio = radial_profile / max(radial_profile);
end

