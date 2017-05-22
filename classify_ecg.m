function classify_ecg(action_type)

pwd_path = pwd;
k = 5;
classifier_name = 'Multi';

%% Classify w.r.t time domain features

data_path = [pwd_path, '/../data/', action_type];
load([data_path,'/ecg_signal']);
% load([data_path,'/abnormal_sig_instance']);

% Class label - 0 for normal and 1 for abnormal

% X1 = [normal_sig_instance zeros(size(normal_sig_instance,1),1)];
% X2 = [abnormal_sig_instance ones(size(abnormal_sig_instance,1),1)];

X = ecg_sig_data;
y = ecg_sig_target;

n_sample = size(X,1);
rand_vect = randperm(n_sample);
X = X(rand_vect,:);
y = y(rand_vect);

error_rate_time = cross_validate(X, y, classifier_name, k);
disp('Classification using time domain ECG signal');
disp(['Error rate : Mean = ', num2str(mean(error_rate_time)),...
    ' , Standard Deviation = ', num2str(std(error_rate_time))]);
%% Classify w.r.t DWT domain features

data_path = [pwd_path, '/../data/',action_type,'/features/'];

wavelet_file = './wavelets.xlsx';
[~,wname] = xlsread(wavelet_file);

n_iter = numel(wname);
error_rate_dwt = cell(1,n_iter);

for i = 1:n_iter
    load([data_path,wname{i}]);
    
    % Class label - 0 for normal and 1 for abnormal
%     X1 = [normal_wavelet_features zeros(size(normal_wavelet_features,1),1)];
%     X2 = [abnormal_wavelet_features ones(size(abnormal_wavelet_features,1),1)];
    
    X = wavelet_features;
    X = X(rand_vect, :);
    
%     n_sample = size(X,1);
%     X = X(randperm(n_sample),:);
    
    error_rate_dwt{i} = cross_validate(X, y, classifier_name, k);
    disp(['Classification using ',wname{i},' Wavelet decomposition']);
    disp(['Error rate : Mean = ', num2str(mean(error_rate_dwt{i})),...
        ' , Standard Deviation = ', num2str(std(error_rate_dwt{i}))]);
end
end