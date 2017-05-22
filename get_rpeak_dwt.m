function [ qrspeaks,qrs_locs ] = get_rpeak_dwt( ecg_sig, t, wname )
% It computes the R peaks of the ECG signal.

dec_level = 5;
% min_peak_height = 0.35;
min_peak_dist = 0.5;

% Wavelet Decomposition
dwt_coeff = modwt(ecg_sig,dec_level);
dwt_coeff_res = zeros(size(dwt_coeff));
dwt_coeff_res(4:5,:) = dwt_coeff(4:5,:);
ecg_sig_comp = imodwt(dwt_coeff_res,wname);

% Find peaks
ecg_sig_comp = abs(ecg_sig_comp).^2;

[qrspeaks,qrs_locs] = findpeaks(ecg_sig_comp,t,'MinPeakHeight',...
    prctile(ecg_sig_comp,75),'MinPeakDistance',min_peak_dist);
end