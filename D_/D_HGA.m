function data = D_HGA( data, varargin )

data.d_hga.hpc = 100;
data.d_hga.lpc1 = 80;
data.d_hga.lpc2 = 40;

hWn = data.d_hga.hpc / (data.data_fs/2);
[ bwb, bwa ] = butter( 4, hWn, 'high' );

hphga = filtfilt( bwb, bwa, data.data );

lWn = data.d_hga.lpc1 / (data.data_fs/2);
[ bwb, bwa ] = butter( 4, lWn, 'low' );
hphga = filtfilt( bwb, bwa, hphga );

data.hga = hphga;

hphga = abs( hphga );

lWn = data.d_hga.lpc2 / (data.data_fs/2);
[ bwb, bwa ] = butter( 4, lWn, 'low' );
hphga = filtfilt( bwb, bwa, hphga );

data.hga_pwr = hphga;

data.hga_fs = data.data_fs;
data.hga_time = 0:(size(data.data, 2) - 1);
data.hga_time = data.hga_time .* (1000 / data.hga_fs);
data.hga_time = round(data.hga_time + data.t_lims(1));

data.hga_pwr_fs = data.hga_fs;
data.hga_pwr_time = data.hga_time;

end