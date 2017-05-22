function train_model( model_name, data_name )
%UNTITLED12 Summary of this function goes here
%   Detailed explanation goes here

pwd_path = pwd;
save_path = [pwd_path, '/../model/'];


if (strcmp(model_name, 'MultiGaussClassify'))
    my_model = MultiGaussClassify;
elseif(strcmp(model_name, 'SVC'))
    my_model = SVC;
end

    data_path = [pwd_path, '/../data/train'];
%     load([data_path,'/normal_sig_instance']);
%     load([data_path,'/abnormal_sig_instance']);
    load([data_path,'/ecg_signal']);
    
    y = ecg_sig_target;

if (strcmp(data_name, 'time'))

    X = ecg_sig_data;
%     D1 = [normal_sig_instance zeros(size(normal_sig_instance,1),1)];
%     D2 = [abnormal_sig_instance ones(size(abnormal_sig_instance,1),1)];
    
else
    data_path = [pwd_path, '/../data/train/features/'];
    load([data_path,data_name]);
    
    X = wavelet_features;    
end

rand_vector = randperm(size(X,1));

X = X(rand_vector,:);
y = y(rand_vector);

my_model = my_model.fit(X,y);

my_model.save_model(save_path, model_name, data_name);

end

