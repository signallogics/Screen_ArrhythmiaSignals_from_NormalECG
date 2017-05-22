function [ eig_vec, eig_val, n_feature, feature_contri ] = get_pca( sig, tol )
% Compute the eigen values and vectors and the number of principal
% components.

% Get the number of samples
n_sample = size(sig,1);

% Mean-center the data
sig_mc = sig-repmat(mean(sig), n_sample, 1);

% Compute covariance matrix
sig_cov = sig_mc'*sig_mc;

% Compute eigen values and eigen vectors
[eig_vec, eig_val] = eig(sig_cov);

% Sort them in a descending order
eig_vec = fliplr(eig_vec);
eig_val = rot90(eig_val,2);

% Compute number of relevant components
cumsum_feature = cumsum((diag(eig_val).^2)/(sum(diag(eig_val).^2)));
n_feature = find(cumsum_feature>tol,1);
feature_contri = cumsum_feature(n_feature);

end

