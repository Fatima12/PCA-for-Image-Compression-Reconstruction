function reconstruction = pca_image_compression(num_components, eigenvectors, projected_data)

%PCA_IMAGE_COMPRESSION Reconstructs image using selected principal components.
%   Inputs:
%       num_components - Number of top principal components to retain
%       eigenvectors   - Matrix of eigenvectors (basis)
%       projected_data - PCA-projected data (principal components)
%   Output:
%       reconstruction - Reconstructed data using top components

    reconstruction = eigenvectors(:, 1:num_components) * projected_data(1:num_components, :);

end