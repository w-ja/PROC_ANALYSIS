function data = D_ALP( data, varargin )

data.d_bet.hpc = 30;
data.d_bet.lpc1 = 15;
data.d_bet.lpc2 = 7.5;

hWn = data.d_bet.hpc / (data.data_fs/2);
[ bwb, bwa ] = butter( 4, hWn, 'high' );

hpbet = filtfilt( bwb, bwa, data.data );

lWn = data.d_bet.lpc1 / (data.data_fs/2);
[ bwb, bwa ] = butter( 4, lWn, 'low' );
hpbet = filtfilt( bwb, bwa, hpbet );

data.bet = hpbet;

hpbet = abs( hpbet );

lWn = data.d_bet.lpc2 / (data.data_fs/2);
[ bwb, bwa ] = butter( 4, lWn, 'low' );
hpbet = filtfilt( bwb, bwa, hpbet );

data.bet_pwr = hpbet;

data.bet_fs = data.data_fs;
data.bet_time = 0:(size(data.data, 2) - 1);
data.bet_time = data.bet_time .* (1000 / data.bet_fs);
data.bet_time = round(data.bet_time + data.t_lims(1));

data.bet_pwr_fs = data.bet_fs;
data.bet_pwr_time = data.bet_time;

end