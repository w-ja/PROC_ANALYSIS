function [data_out, data_fs] = H_RAW_SUB_READ_TDT(direc, t_lims, ch)

if ~exist('ch', 'var')
    
    t = SEV2mat([direc '\RSn1\'], 'T1', t_lims(1)/1000, ...
        'T2', t_lims(2)/1000);
    
else
    
    t = SEV2mat([direc '\RSn1\'], 'T1', t_lims(1)/1000, ...
        'T2', t_lims(2)/1000, ...
        'CHANNEL', ch);
end
                
data_fs = t.RSn1.fs;
data_out = t.RSn1.data;

end