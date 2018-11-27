function data = D_A_MUA( data, varargin )

data.d_mua.deci = floor(data.data_fs/1000);
data.d_mua.hpc = 5000;
data.d_mua.lpc1 = 500;
data.d_mua.lpc2 = 200;

varStrInd = find(cellfun(@ischar,varargin));
for iv = 1:length(varStrInd)
    switch varargin{varStrInd(iv)}
        case {'-d','decimate'}
            data.d_amua.deci = varargin{varStrInd(iv)+1};
        case {'-lpc1','lpc1'}
            data.d_amua.lpc1 = varargin{varStrInd(iv)+1};
        case {'-lpc2','lpc2'}
            data.d_amua.lpc2 = varargin{varStrInd(iv)+1};
        case {'-hpc','hpc'}
            data.d_amua.hpc = varargin{varStrInd(iv)+1};
    end
end

hWn = data.d_mua.hpc / (data.data_fs/2);
[ bwb, bwa ] = butter( 4, hWn, 'high' );

hpMUA = filtfilt( bwb, bwa, data.data );

lWn = data.d_mua.lpc1 / (data.data_fs/2);
[ bwb, bwa ] = butter( 4, lWn, 'low' );
hpMUA = abs( filtfilt( bwb, bwa, hpMUA ) );

lWn = data.d_mua.lpc2 / (data.data_fs/2);
[ bwb, bwa ] = butter( 4, lWn, 'low' );

hpMUA = filtfilt( bwb, bwa, hpMUA );

hpMUA_p = [];
if ~(data.d_mua.deci == false)
    for i = 1 : size(hpMUA, 1)
        hpMUA_p = cat(1,hpMUA_p, decimate( hpMUA(i,:), data.d_mua.deci ));
    end
    hpMUA = hpMUA_p;
end

data.mua = hpMUA;
data.mua_fs = data.data_fs / data.d_mua.deci;
data.mua_time = 0:(size(data.data, 2) - 1);
data.mua_time = data.mua_time .* (1000 / data.mua_fs);
data.mua_time = round(data.mua_time + data.t_lims(1));

end