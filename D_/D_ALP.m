function data = D_THE( data, varargin )

data.d_alp.hpc = 15;
data.d_alp.lpc1 = 9;
data.d_alp.lpc2 = 4.5;

hWn = data.d_alp.hpc / (data.data_fs/2);
[ bwb, bwa ] = butter( 4, hWn, 'high' );

hpalp = filtfilt( bwb, bwa, data.data );

lWn = data.d_alp.lpc1 / (data.data_fs/2);
[ bwb, bwa ] = butter( 4, lWn, 'low' );
hpalp = filtfilt( bwb, bwa, hpalp );

data.alp = hpalp;

hpalp = abs( hpalp );

lWn = data.d_alp.lpc2 / (data.data_fs/2);
[ bwb, bwa ] = butter( 4, lWn, 'low' );
hpalp = filtfilt( bwb, bwa, hpalp );

data.alp_pwr = hpalp;

data.alp_fs = data.data_fs;
data.alp_time = 0:(size(data.data, 2) - 1);
data.alp_time = data.alp_time .* (1000 / data.alp_fs);
data.alp_time = round(data.alp_time + data.t_lims(1));

data.alp_pwr_fs = data.alp_fs;
data.alp_pwr_time = data.alp_time;

end