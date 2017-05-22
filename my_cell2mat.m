function [ sig ] = my_cell2mat( sig_cell )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here


sig_size = 200;
num_sig = numel(sig_cell);
sig = zeros(num_sig,sig_size);

for i = 1:num_sig
    sig_sizeI = numel(sig_cell{i});
    if (sig_sizeI > sig_size)
        sig(i,:) = sig_cell{i}(1:sig_size);
    else
        sig(i,:) = [sig_cell{i} zeros(1, sig_size-sig_sizeI)];
    end
    sig(i,:) = (sig(i,:)-min(sig(i,:)))/(max(sig(i,:))-min(sig(i,:)));
end

end

