function data = D_BET( data, varargin )

data.d_lga.hpc = 80;
data.d_lga.lpc1 = 30;
data.d_lga.lpc2 = 15;

hWn = data.d_lga.hpc / (data.data_fs/2);
[ bwb, bwa ] = butter( 4, hWn, 'high' );

hplga = filtfilt( bwb, bwa, data.data );

lWn = data.d_lga.lpc1 / (data.data_fs/2);
[ bwb, bwa ] = butter( 4, lWn, 'low' );
hplga = filtfilt( bwb, bwa, hplga );

data.lga = hplga;

hplga = abs( hplga );

lWn = data.d_lga.lpc2 / (data.data_fs/2);
[ bwb, bwa ] = butter( 4, lWn, 'low' );
hplga = filtfilt( bwb, bwa, hplga );

data.lga_pwr = hplga;

data.lga_fs = data.data_fs;
data.lga_time = 0:(size(data.data, 2) - 1);
data.lga_time = data.lga_time .* (1000 / data.lga_fs);
data.lga_time = round(data.lga_time + data.t_lims(1));

data.lga_pwr_fs = data.lga_fs;
data.lga_pwr_time = data.lga_time;

end