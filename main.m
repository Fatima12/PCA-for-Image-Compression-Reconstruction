clear all
clc
close all

%% Step 1: Load and preprocess image
% Load indexed image, convert to grayscale, and visualize

load mandrill.mat
original_image = mat2gray(X);
figure; subplot(1,2,1); imshow(original_image); title('Original Image');

%% Step 2: PCA decomposition
% Subtract row-wise mean and compute PCA

[num_rows, num_columns] = size(original_image);
mean_rows = mean(original_image, 2);
centered_data = original_image - mean_rows;

% Sample covariance matrix
covariance_matrix = centered_data*centered_data' / (num_columns - 1); 

[eigenvectors, eigenvalue_matrix] = eig(covariance_matrix);
[eigenvalues_sorted, order] = sort(diag(eigenvalue_matrix), 'descend');  % sort eigenvalues in descending order
eigenvectors = eigenvectors(:, order); 

projected_data = eigenvectors' * centered_data;      

%% Step 3: Reconstruction using top principal components
% Rebuild image using top 'num_components' principal components

num_components = 30; % One can adjust this value
reconstruction = pca_image_compression(num_components, eigenvectors, projected_data);

% Add back the row means
reconstructed_image = reconstruction + mean_rows;
reconstructed_image = mat2gray(reconstructed_image); % ensuring final values betwen [0, 1]

%% Step 4: Visualization
% Compare original and reconstructed images

subplot(1,2,2); imshow(reconstructed_image, []); title(sprintf('Reconstructed with %d principal components', num_components));

%% Peak Signal-to-Noise Ratio (PSNR)

psnr_val = psnr(reconstructed_image, original_image);
fprintf('PSNR between original and reconstructed image: %.2f dB\n', psnr_val);

%% Explained variance

explained_variance = sum(eigenvalues_sorted(1:num_components)) / sum(eigenvalues_sorted) * 100;
fprintf('Variance captured by top %d components: %.2f%%\n', num_components, explained_variance);


