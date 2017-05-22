function [ all_class, class_prior, mean_class, cov_class ] = MultiGaussFit( X, y )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

% Compute number of classes

[all_class_count, all_class] = hist(y, unique(y));
num_class = size(all_class,1);

% Compute number of feautures, prior
% Also mean vector and covariance matrix

num_features = size(X,2);
class_prior = all_class_count/size(X,1);
mean_class = zeros(num_class, num_features);
cov_class = zeros(num_class, num_features, num_features);

for i = 1: num_class
    
    %             # Get the input samples corresponding to the class concerned
    X_class = X(all_class(i) == y, :);
    %             # Get mean of the current input
    mean_class(i, :) = mean(X_class);
    %             # Get covariance matrix of the current input
    % cov_class(i, :, :) = (np.matmul(np.transpose(X_class - self.mean_class[i, :]), X_class - self.mean_class[i, :]))/(self.all_class_count[i])
    temp_mean = repmat(mean_class(i,:), [size(X_class, 1), 1]);
    cov_class(i, :, :) = ((X_class-temp_mean)'*(X_class-temp_mean))/all_class_count(i);
    
end

end
