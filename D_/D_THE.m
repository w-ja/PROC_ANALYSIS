function data = D_DEL( data, varargin )

data.d_the.hpc = 15;
data.d_the.lpc1 = 9;
data.d_the.lpc2 = 4.5;

hWn = data.d_the.hpc / (data.data_fs/2);
[ bwb, bwa ] = butter( 4, hWn, 'high' );

hpthe = filtfilt( bwb, bwa, data.data );

lWn = data.d_the.lpc1 / (data.data_fs/2);
[ bwb, bwa ] = butter( 4, lWn, 'low' );
hpthe = filtfilt( bwb, bwa, hpthe );

data.the = hpthe;

hpthe = abs( hpthe );

lWn = data.d_the.lpc2 / (data.data_fs/2);
[ bwb, bwa ] = butter( 4, lWn, 'low' );
hpthe = filtfilt( bwb, bwa, hpthe );

data.the_pwr = hpthe;

data.the_fs = data.data_fs;
data.the_time = 0:(size(data.data, 2) - 1);
data.the_time = data.the_time .* (1000 / data.the_fs);
data.the_time = round(data.the_time + data.t_lims(1));

data.the_pwr_fs = data.the_fs;
data.the_pwr_time = data.the_time;

end