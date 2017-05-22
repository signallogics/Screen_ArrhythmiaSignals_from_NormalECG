clc;
close all;
clear all;

fs = 250;

pwd_path = pwd;
data_path = [pwd_path,'/../data/train/'];
load([data_path,'/normal_ecg.mat']);
nor_sig = normal_ecg(1,:);
nor_sig = (nor_sig - min(nor_sig(:)))/(max(nor_sig) - min(nor_sig(:)));
subplot(121);pwelch(nor_sig);title('PSD of Normal ECG signal');
load([data_path,'/abnormal_ecg.mat']);
abnor_sig = abnormal_ecg(1,:);
abnor_sig = (abnor_sig - min(abnor_sig(:)))/(max(abnor_sig) - min(abnor_sig(:)));
subplot(122);pwelch(abnor_sig);title('PSD of ECG signal with arrhythmia');


%% Decomposition
wname = 'db4';
dec_level = 4;
[nor_C, nor_L] = wavedec(nor_sig, dec_level, wname);
nor_A4 = nor_C(1:nor_L(1));
nor_D4 = nor_C(nor_L(1)+1:nor_L(1)+nor_L(2));
nor_D3 = nor_C(nor_L(1)+nor_L(2)+1:nor_L(1)+nor_L(2)+nor_L(3));
nor_D2 = nor_C(nor_L(1)+nor_L(2)+nor_L(3)+1:nor_L(1)+nor_L(2)+nor_L(3)+nor_L(4));

[abnor_C, abnor_L] = wavedec(abnor_sig, dec_level, wname);
abnor_A4 = abnor_C(1:abnor_L(1));
abnor_D4 = abnor_C(abnor_L(1)+1:abnor_L(1)+abnor_L(2));
abnor_D3 = abnor_C(abnor_L(1)+abnor_L(2)+1:abnor_L(1)+abnor_L(2)+abnor_L(3));
abnor_D2 = abnor_C(abnor_L(1)+abnor_L(2)+abnor_L(3)+1:abnor_L(1)+abnor_L(2)+abnor_L(3)+abnor_L(4));

figure;
subplot(411);plot(nor_A4);
subplot(412);plot(nor_D4);
subplot(413);plot(nor_D3);
subplot(414);plot(nor_D2);

figure;
subplot(411);plot(abnor_A4);
subplot(412);plot(abnor_D4);
subplot(413);plot(abnor_D3);
subplot(414);plot(abnor_D2);