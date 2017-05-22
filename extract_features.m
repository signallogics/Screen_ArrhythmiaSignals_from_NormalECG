function extract_features(action_type)

pwd_path = pwd;
data_path = [pwd_path,'/../data/',action_type];
model_path = [pwd_path, '/../model/'];
% load([data_path,'/normal_sig_instance']);
% load([data_path,'/abnormal_sig_instance']);
load([data_path,'/ecg_signal'])

y = ecg_sig_target;

save_path = [pwd_path, '/../data/',action_type,'/features/'];

wavelet_file = './wavelets.xlsx';
[~,wname] = xlsread(wavelet_file);

dec_level = 4;

for i = 1:numel(wname)
    
    % ECG signal wavelet decomposition
    n_sample = size(ecg_sig_data,1);
    C = cell(1,n_sample);
    L = cell(1,n_sample);
    
    [C{1}, L{1}] = wavedec(ecg_sig_data(1,:), dec_level, wname{i});
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
        [C{j}, L{j}] = wavedec(ecg_sig_data(j,:), dec_level, wname{i});
        sig_A4(j,:) = C{j}(1:p1);
        sig_D4(j,:) = C{j}(p1+1:p2);
        sig_D3(j,:) = C{j}(p2+1:p3);
        sig_D2(j,:) = C{j}(p3+1:p4);
    end
    
    if (strcmp(action_type,'train'))
                
        W_A4 = get_FLDA(sig_A4, y);
        W_D4 = get_FLDA(sig_D4, y);
        W_D3 = get_FLDA(sig_D3, y);
        W_D2 = get_FLDA(sig_D2, y);
        
        cd(model_path);
        save([wname{i},'.mat'],'W_A4','W_D4','W_D3','W_D2');
        cd(pwd_path);
    elseif (strcmp(action_type, 'test'))
        cd(model_path);
        load([wname{i},'.mat']);
        cd(pwd_path);
    end
    
    FLDA_A4 = sig_A4*W_A4;
    FLDA_D4 = sig_D4*W_D4;
    FLDA_D3 = sig_D3*W_D3;
    FLDA_D2 = sig_D2*W_D2;
    
    wavelet_features = [FLDA_A4 FLDA_D4 FLDA_D3 FLDA_D2];
    %     abnormal_wavelet_features = [abnor_pca_A4 abnor_pca_D4 abnor_pca_D3 abnor_pca_D2];
    
    cd(save_path);
    save([wname{i},'.mat'], 'wavelet_features');
    cd(pwd_path);
end
end