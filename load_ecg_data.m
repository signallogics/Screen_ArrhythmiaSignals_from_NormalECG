function [ normal_ecg, abnormal_ecg ] = load_ecg_data( action_type, fs_nsrdb, fs_mitdb, fs )

% Function load_ecg_data loads the data required for processing
% It accepts the absolute path to the 

pwd_path = pwd;
db_path = [pwd_path, '/../database/', action_type];
data_path = [pwd_path, '/../data/', action_type];
cd(db_path);
% The below parameter takes only a fraction of the dataset as the dataset
% is huge
nor_max_size = 5000000;

try
    cd ./nsrdb
    files = dir('*.mat');
    n_files = length(files);
    per_file_size = nor_max_size/n_files;
    C = cell(2,n_files);
    C_size = zeros(1, n_files);
    for i = 1:n_files
        % disp(['Saving file : ', files(i).name]);
        load(files(i).name);
        val1_resampled = resample(val(1,1:uint64(per_file_size)),fs,fs_nsrdb);
        val2_resampled = resample(val(2,1:uint64(per_file_size)),fs,fs_nsrdb);
        C{1,i} = val1_resampled;
        C{2,i} = val2_resampled;
        C_size(i) = numel(val1_resampled);
    end
    normal_ecg = zeros(2, sum(C_size));
    idx = cumsum(C_size);
    for i = 1:n_files
        normal_ecg(:, idx(i)-C_size(i)+1:idx(i)) = cell2mat(C(:,i));
    end
	cd(data_path);
    save('normal_ecg.mat', 'normal_ecg','-v7.3');
    
    cd (db_path);
    cd mitdb
    files = dir('*.mat');
    n_files = length(files);
    C = cell(2,n_files);
    C_size = zeros(1, n_files);
    for i = 1:length(files)
        load(files(i).name);
        val1_resampled = resample(val(1,:),fs,fs_mitdb);
        val2_resampled = resample(val(2,:),fs,fs_mitdb);
        C{1,i} = val1_resampled;
        C{2,i} = val2_resampled;
        C_size(i) = numel(val1_resampled);
    end
    
    abnormal_ecg = zeros(2, sum(C_size));
    idx = cumsum(C_size);
    for i = 1:n_files
        abnormal_ecg(:, idx(i)-C_size(i)+1:idx(i)) = cell2mat(C(:,i));
    end
	cd(data_path);
    save('abnormal_ecg.mat', 'abnormal_ecg','-v7.3');
    
    cd(pwd_path);
catch ME
    disp(ME);
    disp('Error while reading data');
    cd(pwd_path);
end

end

