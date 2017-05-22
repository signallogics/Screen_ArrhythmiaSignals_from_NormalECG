clc;
close all;
% clear all;

%% Extract raw data
% extract_data('train');
% extract_data('test');

%% Extract wavelet features and save it in compressed form
% extract_features('train');
% extract_features('test');

%% Cross validate
% disp('======Training dataset======');
% classify_ecg('train');
% disp('======Test dataset======');
% classify_ecg('test');

%% Train and test the model
train_model('MultiGaussClassify', 'time');
error_rate_time = test_model('MultiGaussClassify','time');

wavelet_file = './wavelets.xlsx';
[~,wname] = xlsread(wavelet_file);

error_rate_feature = cell(size(wname));

for i = 1:numel(wname)
    train_model('MultiGaussClassify', wname{i});
    error_rate_feature{i} = test_model('MultiGaussClassify',wname{i});
end

%% Validate model
% Select a patient at random and make a decision whether he/she is
% sufferring from arrhythmia

% db = cell(2,1);
% db{1} = 'mitdb';
% db{2} = 'nsrdb';
% pwd_path = pwd;
% 
% decision = cell(size(db));
% y_pred = cell(size(db));
% 
% wavelet_file = './wavelets.xlsx';
% [~,wname] = xlsread(wavelet_file);
% obsv_time = 10;
% 
% for i = 1:numel(db)
%     data_path = [pwd_path,'/../database/test/',db{i}];
%     cd(data_path);
%     files = dir('*.mat');
%     n_files = length(files);
%     cd(pwd_path)
%     
%     decision1 = zeros(n_files,numel(wname));
%     y_pred1 = cell(n_files,numel(wname));
%     for j = 1:n_files
%         for k = 1:numel(wname)
%             [decision1(j,k), y_pred1{j,k}] = validate_model(db{i}, files(j).name, wname{k}, obsv_time);
%         end
%     end
%     decision{i} = decision1;
%     y_pred{i} = y_pred1;
% end
% 
% decision_mitdb = decision{1};
% decision_nsrdb = decision{2};