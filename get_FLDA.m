function [ W_proj ] = get_FLDA( X, r )
%UNTITLED15 Summary of this function goes here
%   Detailed explanation goes here

[n_sample, n_feature] = size(X);

% Get all classes and count of each class
[all_class_count, all_class] = hist(r, unique(r));
n_class = numel(all_class);

% Initialize mean vectors and covariance matrices for each class and then fill with values
mean_class = zeros(n_class, n_feature);
s_class = zeros(n_class, n_feature, n_feature);

% Iterate for each class
for i = 1:n_class
    % Get the samples belonging to current class
    X_class = X(r==all_class(i), :);
    
    % Compute the mean for each class
    mean_class(i,:) = mean(X_class);
    
    % Compute the within-class scatter for each class
    s_class(i,:,:) = ((X_class-repmat(mean_class(i,:),size(X_class,1),1))')*(X_class-repmat(mean_class(i,:),size(X_class,1),1));
end
% Get the total within-class scatter
sw = squeeze(sum(s_class));

% Get the transformation matrix
W_proj = pinv(sw)*(mean_class(1,:) - mean_class(2,:))';

end

