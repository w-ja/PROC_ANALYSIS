function data = D_LFP(data, varargin)

data.d_lfp.lpc = 200;
data.d_lfp.deci = floor(data.fs/1000);

varStrInd = find(cellfun(@ischar,varargin));
for iv = 1:length(varStrInd)
    switch varargin{varStrInd(iv)}
        case {'lpc'}
            data.d_lfp.lpc = varargin{varStrInd(iv)+1};
        case {'deci'}
            data.d_lfp.deci = varargin{varStrInd(iv)+1};
    end
end

if data.d_lfp.deci > 1
    if size( data.data, 2 ) == 1
        t_lfp = data.data.';
    end
    for i = 1 : size(data.data,1)
        t_lfp(i,:) = decimate( data.data(i,:), data.d_lfp.deci );
    end
else
    t_lfp = data.data;
end

data.lfp_fs = data.fs / data.d_lfp.deci;
data.lfp_nyq = data.lfp_fs / 2;

lWn = data.d_lfp.lpc / data.lfp_nyq;
[ bwb, bwa ] = butter( 4, lWn, 'low' );

data.lfp = filtfilt( bwb, bwa, t_lfp); 

data.lfp_vec_time = 0:(size(data.data, 2) - 1);
data.lfp_vec_time = data.lfp_vec_time .* (1000 / data.lfp_fs);
data.lfp_vec_time = round(data.lfp_vec_time + data.t_lims(1));

end