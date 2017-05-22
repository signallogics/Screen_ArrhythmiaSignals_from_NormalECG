function [ y ] = MultiGaussPredict( X, all_class, class_prior, mean_class, cov_class )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

num_class = size(all_class, 1);
num_sample = size(X,1);
g = zeros(num_class, num_sample);

%     # Compute discriminant function for each classes
for i = 1:num_class
    
    mean_temp = mean_class(i, :);
    cov_temp = squeeze(cov_class(i, :, :));
    
    cov_class_det = det(cov_temp) + 1e-6;
    cov_class_inv = pinv(cov_temp);
    
    const1 = -0.5*log10(cov_class_det);
    const2 = log10(class_prior(i));
    
    %         # Compute discriminant function for each samples belonging to the current class
    for j = 1:num_sample
        
        %             # Evaluate the discriminant value and store it
        %self.g(i, j) = -0.5*(np.matmul((X[j, :] - mean_temp), (np.matmul(cov_class_inv, (np.transpose(X[j, :] - mean_temp))))))
        
        g(i, j) = -0.5*((X(j, :) - mean_temp)*(cov_class_inv * (X(j, :) - mean_temp)'));
    end
    g(i, :) = g(i, :) + const1 + const2;
end
%             # Get the index of the class which gives maximum value
[gmax, gmax_indices] = max(g);
y = all_class(gmax_indices);
end


