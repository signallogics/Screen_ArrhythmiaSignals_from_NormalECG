function err = test_model( model_name, data_name )
%UNTITLED13 Summary of this function goes here
%   Detailed explanation goes here

pwd_path = pwd;
model_path = [pwd_path, '/../model/'];

load([model_path,model_name,'_',data_name]);

if (strcmp(model_name, 'MultiGaussClassify'))
    my_model = MultiGaussClassify;
    my_model.all_class = all_class;
    my_model.class_prior = class_prior;
    my_model.mean_class = mean_class;
    my_model.cov_class = cov_class;
elseif(strcmp(model_name, 'SVC'))
    my_model = SVC;
end

data_path = [pwd_path, '/../data/test'];
load([data_path,'/ecg_signal']);

y = ecg_sig_target;

if (strcmp(data_name, 'time'))
    %     load([data_path,'/abnormal_sig_instance']);
    
    X = ecg_sig_data;
    %     X2 = [abnormal_sig_instance ones(size(abnormal_sig_instance,1),1)];
    
else
    data_path = [pwd_path, '/../data/test/features/'];
    load([data_path,data_name]);
    X = wavelet_features;
%     X1 = [normal_wavelet_features zeros(size(normal_wavelet_features,1),1)];
%     X2 = [abnormal_wavelet_features ones(size(abnormal_wavelet_features,1),1)];
    
end

% X = [X1;X2];
% n_sample = size(X,1);

y_pred = my_model.predict(X);
e = zeros(size(y_pred));
e(y ~= y_pred) = 1;
err = mean(e(:));

end

