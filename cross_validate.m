function [ error_rate ] = cross_validate( X, y, classifier_name, k )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

if (strcmp(classifier_name,'SVC'))
    classifier_model = SVC()
elseif (strcmp(classifier_name,'EBPNN'))
    classifier_model = EBPNN()
elseif (strcmp(classifier_name,'GMM'))
    classifier_model = GMM()
end

n_sample = size(X,1);
samples_per_partition = ceil(n_sample/k);
error_rate = zeros(1,k);

for i = 1:k
    test_l = (i-1)*samples_per_partition + 1;
    test_r = i*samples_per_partition;
    
    if (i == k)
        test_r = n_sample;
    end
    
    X_test = X(test_l:test_r, :);
    y_test = y(test_l:test_r);
    
    if (test_l == 1)
        X_train = X(test_r+1:end, :);
        y_train = y(test_r+1:end);
    elseif (test_r == n_sample)
        X_train = X(1:test_l-1, :);
        y_train = y(1:test_l-1);
    else 
        X_train = [X(1:test_l-1, :);X(test_r+1:end, :)];
        y_train = [y(1:test_l-1);y(test_r+1:end)];
    end
    
%     classifier_model.fit(X_train(:,1:end-1), X_train(:,end));
%     y_predicted = classifier_model.predict(X_test(:,1:end-1));

    [all_class, class_prior, mean_class, cov_class] = MultiGaussFit(X_train, y_train);
    y_predicted = MultiGaussPredict(X_test, all_class, class_prior, mean_class, cov_class);
    
    temp1 = mean(y_predicted);
    temp2 = mean(y_test);

    e = zeros(size(y_test));
    e(y_test ~= y_predicted) = 1;
    error_rate(i) = mean(e(:));
end

end

