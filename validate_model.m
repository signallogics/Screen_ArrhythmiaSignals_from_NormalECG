function [ decision, y_pred ] = validate_model( db, patient, wname, obsv_time )
%UNTITLED16 Summary of this function goes here
%   Detailed explanation goes here

fs = 250;
fs_nsrdb = 128;
fs_mitdb = 360;
nor_max_size = 5000000;

n_sample = obsv_time*60*fs;

% Load raw patient data
pwd_path = pwd;
patient_data = [pwd_path, '/../database/test/', db, '/', patient];
load(patient_data);
if (nor_max_size > size(val,2))
    nor_max_size = size(val,2);
end
val = val(1,1:nor_max_size);

% Resample
if (strcmp(db, 'mitdb'))
    val1_resampled = resample(val,fs,fs_mitdb);
elseif (strcmp(db, 'nsrdb'))
    val1_resampled = resample(val,fs,fs_nsrdb);
end

val1_resampled = val1_resampled(1:n_sample);
sig = (val1_resampled-min(val1_resampled))/(max(val1_resampled)-min(val1_resampled));


% Wavelet for detection - sym4
wname_det = 'sym4';

t = 0:1/fs:(numel(sig)-1)/fs;
[~,loc] = get_rpeak_dwt(sig,t,wname_det);

loc_span = [loc-(99/fs);loc+(100/fs)];
loc_span = loc_span(:,2:end-1);

n_sample = size(loc_span,2);

sig_cell = cell(1,n_sample);

for i = 1:n_sample
    sig_cell{i} = sig(ceil(loc_span(1,i)*fs):floor(loc_span(2,i)*fs));
end

ecg_sig_data = my_cell2mat(sig_cell);

% Extract features
dec_level = 4;
n_sample = size(ecg_sig_data,1);
C = cell(1,n_sample);
L = cell(1,n_sample);

[C{1}, L{1}] = wavedec(ecg_sig_data(1,:), dec_level, wname);
sig_A4 = zeros(n_sample, L{1}(1));
sig_D4 = zeros(n_sample, L{1}(2));
sig_D3 = zeros(n_sample, L{1}(3));
sig_D2 = zeros(n_sample, L{1}(4));

p1 = L{1}(1);
p2 = L{1}(1)+L{1}(2);
p3 = L{1}(1)+L{1}(2)+L{1}(3);
p4 = L{1}(1)+L{1}(2)+L{1}(3)+L{1}(4);

for j = 1:n_sample
    % Sub-band decomposition
    [C{j}, L{j}] = wavedec(ecg_sig_data(j,:), dec_level, wname);
    sig_A4(j,:) = C{j}(1:p1);
    sig_D4(j,:) = C{j}(p1+1:p2);
    sig_D3(j,:) = C{j}(p2+1:p3);
    sig_D2(j,:) = C{j}(p3+1:p4);
end

model_path = [pwd_path, '/../model/'];
cd(model_path);
load([wname,'.mat']);
cd(pwd_path);

FLDA_A4 = sig_A4*W_A4;
FLDA_D4 = sig_D4*W_D4;
FLDA_D3 = sig_D3*W_D3;
FLDA_D2 = sig_D2*W_D2;

wavelet_features = [FLDA_A4 FLDA_D4 FLDA_D3 FLDA_D2];

model_name = 'MultiGaussClassify';
load([model_path,model_name,'_',wname]);
if (strcmp(model_name, 'MultiGaussClassify'))
    my_model = MultiGaussClassify;
    my_model.all_class = all_class;
    my_model.class_prior = class_prior;
    my_model.mean_class = mean_class;
    my_model.cov_class = cov_class;
elseif(strcmp(model_name, 'SVC'))
    my_model = SVC;
end

y_pred = my_model.predict(wavelet_features);
decision = mean(y_pred)>0.85;
end

