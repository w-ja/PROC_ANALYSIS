function data = D_DEL( data, varargin )

data.d_del.hpc = 15;
data.d_del.lpc1 = 9;
data.d_del.lpc2 = 4.5;

hWn = data.d_del.hpc / (data.data_fs/2);
[ bwb, bwa ] = butter( 4, hWn, 'high' );

hpdel = filtfilt( bwb, bwa, data.data );

lWn = data.d_del.lpc1 / (data.data_fs/2);
[ bwb, bwa ] = butter( 4, lWn, 'low' );
hpdel = filtfilt( bwb, bwa, hpdel );

data.del = hpdel;

hpdel = abs( hpdel );

lWn = data.d_del.lpc2 / (data.data_fs/2);
[ bwb, bwa ] = butter( 4, lWn, 'low' );
hpdel = filtfilt( bwb, bwa, hpdel );

data.del_pwr = hpdel;

data.del_fs = data.data_fs;
data.del_time = 0:(size(data.data, 2) - 1);
data.del_time = data.del_time .* (1000 / data.del_fs);
data.del_time = round(data.del_time + data.t_lims(1));

data.del_pwr_fs = data.del_fs;
data.del_pwr_time = data.del_time;

end