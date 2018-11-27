function [data_out, data_fs_out, data_time_out] = ...
    H_DS(ds_val, data_in, data_fs_in, data_time_in)

data_out = [];

if size(data_in, 1) > 1
    for i = 1 : size(data_in, 1)
        data_out = cat(1, data_out, decimate(data_in(i,:), ds_val));
    end
else
    data_out = decimate(data_in, ds_val);
end

data_time_out = downsample(data_time_in, ds_val);
data_fs_out = data_fs_in / ds_val;

end

