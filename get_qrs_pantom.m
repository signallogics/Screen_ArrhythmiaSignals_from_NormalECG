function [ sig_span ] = get_qrs_pantom( ecg_sig )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

hf = [1 -1];
lf = [.25 .5 .25];
s1 = abs(conv(ecg_sig, hf));
s2 = conv(s1, lf);
s3 = abs(conv(s2, hf));
s4 = conv(s3, lf);
s5 = s2 + s4(1:size(s2,2));
sig_env = zeros(size(s5));
sig_env(s5>20) = 1;

% Exclude instance if it is in middle of a QRS complex
while(sig_env(1) == 1)
    sig_env(1) = [];
end

% Original Pan-Tompkins returns sig_env
% But the modified one, in our context returns the span of the indvidual
% ecg signal

% Get the derivative to get onset and offset of the QRS complex
sig_env_d = sig_env(2:end)-sig_env(1:end-1);
sig_begin = find(sig_env_d==1);
sig_end = find(sig_env_d==-1);
span_len = min(size(sig_begin,2), size(sig_end,2));
sig_span = [sig_begin(1:span_len);sig_end(1:span_len)];

% Remove noisy samples
sig_len = sig_span(2,:)-sig_span(1,:);
sig_span(:,sig_len < 15 | sig_len >25) = [];
% The R point is assumed to be the mean of the span of the QRS complex.
sig_r_point = uint32(mean(sig_span));

% The period of the QRS complex is assumed to be 200 and considering
% R point to be the center of the QRS complex, take 100 samples on either
% sides.
sig_r_begin = sig_r_point-99;
% sig_r_begin = max(1,sig_r_begin);
sig_r_end = sig_r_point+100;
% sig_r_end = min(sig_r_end, size(normal_ecg_lead1,2));
sig_span = [sig_r_begin(2:end-1);sig_r_end(2:end-1)];
end

