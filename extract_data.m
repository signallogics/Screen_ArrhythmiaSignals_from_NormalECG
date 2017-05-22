function extract_data(action_type)
%% Load ecg data

% Initialize parameters
fs_nsrdb = 128;
fs_mitdb = 360;
fs = 250;

pwd_path = pwd;
data_path = [pwd_path, '/../data/', action_type];

% data_path = ['/../database', action_type];
% [normal_ecg, abnormal_ecg] = load_ecg_data(pwd, data_path, fs_nsrdb, fs_mitdb, fs);
[normal_ecg, abnormal_ecg] = load_ecg_data(action_type, fs_nsrdb, fs_mitdb, fs);

% load([pwd,data_path, '/normal_ecg.mat']);
% load([pwd,data_path, '/abnormal_ecg.mat']);

%% Preprocess ecg signal

normal_ecg_lead1 = normal_ecg(1,:);
normal_ecg_lead2 = normal_ecg(2,:);

abnormal_ecg_lead1 = abnormal_ecg(1,:);
abnormal_ecg_lead2 = abnormal_ecg(2,:);

%% Normalize signals
normal_ecg_lead1 = (normal_ecg_lead1-min(normal_ecg_lead1))/(max(normal_ecg_lead1)-min(normal_ecg_lead1));
abnormal_ecg_lead1 = (abnormal_ecg_lead1-min(abnormal_ecg_lead1))/(max(abnormal_ecg_lead1)-min(abnormal_ecg_lead1));

%% Normal ECG signal
% DWT based Detection

% Wavelet for detection - sym4
wname_det = 'sym4';

sig = normal_ecg_lead1;
t = 0:1/fs:(numel(sig)-1)/fs;
[~,loc] = get_rpeak_dwt(sig,t,wname_det);

loc_span = [loc-(99/fs);loc+(100/fs)];
loc_span = loc_span(:,2:end-1);

n_sample = size(loc_span,2);

normal_sig_cell = cell(1,n_sample);

for i = 1:n_sample
    normal_sig_cell{i} = sig(ceil(loc_span(1,i)*fs):floor(loc_span(2,i)*fs));
end

normal_sig_instance = my_cell2mat(normal_sig_cell);


% cd(data_path);
% save('normal_sig_instance.mat', 'normal_sig_instance','-v7.3');
% cd(pwd_path);

%% Abnormal ECG signal
% DWT based Detection

% Wavelet for detection - sym4

sig = abnormal_ecg_lead1;
t = 0:1/fs:(numel(sig)-1)/fs;
[~,loc] = get_rpeak_dwt(sig,t,wname_det);

loc_span = [loc-(99/fs);loc+(100/fs)];
loc_span = loc_span(:,2:end-1);

n_sample = size(loc_span,2);

abnormal_sig_cell = cell(1,n_sample);

for i = 1:n_sample
    abnormal_sig_cell{i} = sig(ceil(loc_span(1,i)*fs):floor(loc_span(2,i)*fs));
end

abnormal_sig_instance = my_cell2mat(abnormal_sig_cell);

ecg_sig_data = [normal_sig_instance;abnormal_sig_instance];
ecg_sig_target = [zeros(size(normal_sig_instance,1),1);ones(size(abnormal_sig_instance,1),1)];

rand_vector = randperm(size(ecg_sig_data,1));

ecg_sig_data = ecg_sig_data(rand_vector,:);
ecg_sig_target = ecg_sig_target(rand_vector);

cd(data_path);
% save('abnormal_sig_instance.mat', 'abnormal_sig_instance','-v7.3');
save('ecg_signal.mat', 'ecg_sig_data','ecg_sig_target');
cd(pwd_path);
end